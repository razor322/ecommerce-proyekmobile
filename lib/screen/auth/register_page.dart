// ignore_for_file: prefer_const_constructors

import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/auth/model_register.dart';
import 'package:ecommerce_app/screen/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscurepass = true;
  bool isLoading = false;

  Future<ModelRegister?> registerAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        ;
      });

      try {
        http.Response res = await http.post(Uri.parse('${url}register.php'),
            body: {
              "username": _username.text,
              "email": _email.text,
              "password": _password.text
            });
        final data = modelRegisterFromJson(res.body);
        if (data.value == 1) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
              (route) => false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.message)));
        } else if (data.value == 2) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.message)));
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    "Start learning with create your account",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Username",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      hintText: "Create your username",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: Colors.grey,
                      ),
                      fillColor: Colors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: "Enter your email or phone number",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      fillColor: Colors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: "Create your password",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      fillColor: Colors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurepass
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurepass = !_obscurepass;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurepass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                      width: 350,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              registerAccount();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Silahkan isi data terlebih dahulu")));
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ))),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}