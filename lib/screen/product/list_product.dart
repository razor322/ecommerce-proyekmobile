import 'package:ecommerce_app/components/custom_snackbar.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/product/model_get_product.dart';
import 'package:ecommerce_app/screen/product/detail_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  bool isLoading = false;
  late List<Product> _productList = [];

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
        final modelProduct = modelProductFromJson(res.body);
        setState(() {
          _productList = modelProduct.products ?? [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
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
              itemCount: _productList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Optional: Adjust aspect ratio
              ),
              itemBuilder: (context, index) {
                Product data = _productList[index];
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
                                '${urlImg}${data.productImage}', // Assuming Product has an imageUrl field
                                fit: BoxFit.cover,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
