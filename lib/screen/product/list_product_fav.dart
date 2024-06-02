// ignore_for_file: prefer_const_constructors

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/product/model_get_fav.dart';
import 'package:ecommerce_app/screen/product/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListProductFavPage extends StatefulWidget {
  const ListProductFavPage({super.key});

  @override
  State<ListProductFavPage> createState() => _ListProductFavPageState();
}

class _ListProductFavPageState extends State<ListProductFavPage> {
  bool isLoading = false;
  late List<Favorite> _productList = [];
  late List<Favorite> _sortedProductList = [];
  late List<Favorite> _latestProductList = [];
  String? id;

  @override
  void initState() {
    super.initState();
    getSession().then((value) => getProduct());
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print('id user $id');
    });
  }

  Future<void> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      print('id userr $id');
      final res =
          await http.get(Uri.parse('${url}get_favorite.php?user_id=$id'));

      if (res.statusCode == 200) {
        List<Favorite> data = modelGetFavFromJson(res.body).favorites ?? [];
        setState(() {
          _productList = data;
          _sortedProductList = _sortProductsByPrice(data);
          _latestProductList = _sortProductsByDate(data);
          _searchResult = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed Load data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  TextEditingController txtcari = TextEditingController();
  late List<Favorite> _searchResult = [];

  void _filterBerita(String query) {
    List<Favorite> filteredProducts = _productList
        .where((produk) =>
            produk.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchResult = filteredProducts;
    });
  }

  // Sort by price
  List<Favorite> _sortProductsByPrice(List<Favorite> products) {
    List<Favorite> sortedList =
        List.from(products); // Create a copy of the list
    sortedList.sort((a, b) => a.productPrice.compareTo(b.productPrice));
    return sortedList;
  }

  // Sort by date
  List<Favorite> _sortProductsByDate(List<Favorite> products) {
    List<Favorite> sortedList =
        List.from(products); // Create a copy of the list
    sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
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

  Widget buildProductGrid(List<Favorite> productList) {
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
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              if (productList.isNotEmpty) {
                Favorite data = productList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailProductPage(data)));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Image.network(
                          '${urlImg}${data.productImage}',
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.productName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('\$${data.productPrice}'),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text('No products found.'));
              }
            },
          ),
        ),
      ],
    );
  }
}
