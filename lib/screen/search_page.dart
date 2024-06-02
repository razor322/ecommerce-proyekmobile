// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ecommerce_app/components/bottom_navigation.dart';
import 'package:ecommerce_app/components/custom_snackbar.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/product/model_get_product.dart';
import 'package:ecommerce_app/screen/product/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  List<Product?> listProduct = [];
  List<Product?> filteredProducts = [];
  TextEditingController txtcari = TextEditingController();

  final List<Map<String, String>> _image = [
    {
      'image': 'assets/images/nike.png',
      'title': 'Nike',
      'subtitle': '1,6 Search Today',
      'acion': 'Hot',
      'color': 'red'
    },
    {
      'image': 'assets/images/tas.png',
      'title': 'Bag',
      'subtitle': '1,6 Search Today',
      'acion': 'New',
      'color': 'Amber'
    },
    {
      'image': 'assets/images/baju.png',
      'title': 'Shirt',
      'subtitle': '1,6 Search Today',
      'acion': 'Popular',
      'color': 'green'
    },
  ];

  final Map<String, Color> _colorMap = {
    'red': Colors.red,
    'amber': Colors.amber,
    'green': Colors.green,
  };

  @override
  void initState() {
    super.initState();
    getProduct();
    txtcari.addListener(_filterProducts);
  }

  @override
  void dispose() {
    txtcari.removeListener(_filterProducts);
    txtcari.dispose();
    super.dispose();
  }

  Future<void> getProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.get(Uri.parse('${url}get_product.php'));

      if (res.statusCode == 200) {
        final modelProduct = modelProductFromJson(res.body);
        setState(() {
          listProduct = modelProduct.products ?? [];
          filteredProducts = listProduct;
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

  void _filterProducts() {
    final query = txtcari.text.toLowerCase();
    setState(() {
      filteredProducts = listProduct.where((product) {
        final productName = product!.productName.toLowerCase();
        return productName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSearchQuery = txtcari.text.isNotEmpty;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => BotNav()),
                          (route) => false);
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                Container(
                  width: 310,
                  child: TextFormField(
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (!hasSearchQuery) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last Search",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Clear all",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 140,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 1)),
                    child: Center(
                      child: Text(
                        "Electronic    X",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.shopping_bag,
                    size: 30,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Search ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _image.length,
                    itemBuilder: (context, index) {
                      final item = _image[index];
                      final color = _colorMap[item['color']!.toLowerCase()] ??
                          Colors.grey;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //gambar dan penjelasan
                            Row(
                              children: [
                                Container(
                                  width: 70, // specify a width
                                  height: 70, // specify a height
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.asset(
                                    item['image']!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item['subtitle']!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            Container(
                              height: 35,
                              width: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: color),
                              child: Center(
                                child: Text(
                                  item['acion']!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ] else ...[
              createFilterList(),
            ]
          ],
        ),
      )),
    );
  }

  Widget createFilterList() {
    return HasilSearch();
  }

  Widget HasilSearch() {
    return Expanded(
      child: GridView.builder(
        itemCount: filteredProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Optional: Adjust aspect ratio
        ),
        itemBuilder: (context, index) {
          Product? data = filteredProducts[index];
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
                        child: Image.network(
                          '${urlImg}${data!.productImage}', // Assuming Product has an imageUrl field
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data!.productName,
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
                        "\$${data?.productPrice}", // Assuming Product has a price field
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
        },
      ),
    );
  }
}
