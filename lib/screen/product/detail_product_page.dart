import 'package:ecommerce_app/components/custom_snackbar.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/cart/model_add_cart.dart';
import 'package:ecommerce_app/model/product/model_add_fav.dart';
import 'package:ecommerce_app/model/product/model_get_fav.dart';
import 'package:ecommerce_app/model/product/model_get_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductPage extends StatefulWidget {
  final dynamic data; // Accepts either Product or Favorite
  DetailProductPage(this.data, {super.key});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  int _quantity = 1;
  String? id;
  double _totalPrice = 0.0;
  bool isLoadoing = false;

  Product get _productData {
    if (widget.data is Product) {
      return widget.data;
    } else if (widget.data is Favorite) {
      final favorite = widget.data as Favorite;
      return Product(
        productId: favorite.productId.toString(),
        productName: favorite.productName,
        productDescription: favorite.productDescription,
        productImage: favorite.productImage,
        productPrice: favorite.productPrice.toString(),
        productStore: favorite.productStore,
        created: favorite.createdAt,
        updated: favorite.updated.toString(), productCategory: '',
        // Add other necessary fields and conversions here
      );
    }
    throw Exception("Invalid data type");
  }

  @override
  void initState() {
    super.initState();
    getSession();
    _totalPrice = _calculateTotalPrice(); // Initialize the total price
    print('id produk ${_productData.productId} ');
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = _calculateTotalPrice(); // Update the total price
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        _totalPrice = _calculateTotalPrice(); // Update the total price
      }
    });
  }

  double _calculateTotalPrice() {
    final productPrice =
        double.tryParse(_productData.productPrice ?? '0') ?? 0.0;
    return productPrice * _quantity;
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print('id user $id');
    });
  }

  Future<void> addFav(String idp) async {
    try {
      http.Response res = await http.post(Uri.parse('${url}add_favorite.php'),
          body: {"user_id": id, "product_id": idp});

      if (res.statusCode == 200) {
        ModelAddFavorite data = modelAddFavoriteFromJson(res.body);

        if (data.value == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal menambahkan data')),
      );
    }
  }

  Future<void> addToCart(String idp) async {
    try {
      http.Response res = await http.post(Uri.parse('${url}add_cart.php'),
          body: {"user_id": id, "product_id": idp});

      if (res.statusCode == 200) {
        ModelAddCart data = modelAddCartFromJson(res.body);

        if (data.value == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal menambahkan data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _productData;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 375,
              child: Center(
                child: Image.network(
                  '${urlImg}${data.productImage}',
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Text('Image failed to load');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    "Detail Product",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 350),
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.productName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                addFav(data.productId);
                              },
                              icon: Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        data.productDescription,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 3, color: Colors.green),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.green,
                              size: 22,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              data.productStore,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "100 Products",
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "1K Followers",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 78,
                          height: 34,
                          child: Center(
                            child: Text(
                              'Follow',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: _decrementQuantity,
                                  icon: Icon(Icons.remove),
                                  color: Colors.black,
                                  iconSize: 24,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '$_quantity',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                child: IconButton(
                                  onPressed: _incrementQuantity,
                                  icon: Icon(Icons.add),
                                  color: Colors.white,
                                  iconSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '\$ ',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.green),
                              children: <TextSpan>[
                                TextSpan(
                                    text: _totalPrice.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                addToCart(data.productId);
                              },
                              child: Text("add to Cart"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
