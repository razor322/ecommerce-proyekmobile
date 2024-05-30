import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ecommerce_app/components/custom_snackbar.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/product/model_get_product.dart';
import 'package:ecommerce_app/screen/product/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListProductFavPage extends StatefulWidget {
  const ListProductFavPage({super.key});

  @override
  State<ListProductFavPage> createState() => _ListProductFavPageState();
}

class _ListProductFavPageState extends State<ListProductFavPage> {
  bool isLoading = false;
  late List<Product> _productList = [];
  late List<Product> _sortedProductList = [];
  late List<Product> _latestProductList = [];

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future<void> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.get(Uri.parse('${url}get_product.php'));

      if (res.statusCode == 200) {
        List<Product> data = modelProductFromJson(res.body).products ?? [];
        setState(() {
          _productList = data;
          _sortedProductList = _sortProductsByPrice(data);
          _latestProductList = _sortProductsByDate(data);
          _searchResult = data;
        });
      } else {
        CustomSnackbar("Failed to load data");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  TextEditingController txtcari = TextEditingController();
  late List<Product> _searchResult = [];

  void _filterBerita(String query) {
    List<Product> filteredProducts = _productList
        .where((produk) =>
            produk.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchResult = filteredProducts;
    });
  }

  // Sort by price
  List<Product> _sortProductsByPrice(List<Product> products) {
    List<Product> sortedList = List.from(products); // Create a copy of the list
    sortedList.sort((a, b) => a.productPrice.compareTo(b.productPrice));
    return sortedList;
  }

  // Sort by date
  List<Product> _sortProductsByDate(List<Product> products) {
    List<Product> sortedList = List.from(products); // Create a copy of the list
    sortedList.sort((a, b) => b.created.compareTo(a.created));
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: _filterBerita,
                controller: txtcari,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      size: 25,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.orange.shade100,
                  hintText: "Search",
                  hintStyle: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            DefaultTabController(
              length: 4,
              child: Expanded(
                child: Column(
                  children: [
                    ButtonsTabBar(
                      backgroundColor: Colors.green,
                      unselectedBackgroundColor: Colors.green.shade200,
                      unselectedLabelStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 20),
                            child: Text(
                              "All",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Text(
                              "Cheapest",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Text(
                              "Popular",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Text(
                              "Latest",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          buildProductGrid(_searchResult.isNotEmpty
                              ? _searchResult
                              : _productList),
                          buildProductGrid(_searchResult.isNotEmpty
                              ? _sortProductsByPrice(_searchResult)
                              : _sortedProductList),
                          buildProductGrid(_searchResult.isNotEmpty
                              ? _searchResult
                              : _productList),
                          buildProductGrid(_searchResult.isNotEmpty
                              ? _sortProductsByDate(_searchResult)
                              : _latestProductList),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductGrid(List<Product> productList) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Product 🔥",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: productList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7, // Optional: Adjust aspect ratio
            ),
            itemBuilder: (context, index) {
              if (productList.isNotEmpty) {
                Product data = productList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailProductPage(data)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Stack(
                                children: [
                                  Image.network(
                                    '${urlImg}${data.productImage}', // Assuming Product has an imageUrl field
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 100, top: 25),
                                    child: Icon(Icons.favorite,
                                        color: Colors.red, size: 25.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            child: Text(
                              "\$${data.productPrice}", // Assuming Product has a price field
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text("No products available"),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
