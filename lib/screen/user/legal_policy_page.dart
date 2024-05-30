import 'package:flutter/material.dart';

class LegalPolicyPage extends StatefulWidget {
  const LegalPolicyPage({super.key});

  @override
  State<LegalPolicyPage> createState() => _LegalPolicyPageState();
}

class _LegalPolicyPageState extends State<LegalPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "Legal & Policy",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Terms",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elitUrna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna ",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Change to the Service and/or Term",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elitUrna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna amet, suspendisse ullamcorper ac elit diam facilis cursus vestibuluum.Urna ",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
