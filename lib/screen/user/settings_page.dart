import 'package:ecommerce_app/screen/auth/login_page.dart';
import 'package:ecommerce_app/screen/user/edit_profil_page.dart';
import 'package:ecommerce_app/screen/user/legal_policy_page.dart';
import 'package:ecommerce_app/utils/cek_session.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                    "Settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ListTile(
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfiluser()),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
              title: Text("Edit Profile"),
            ),
            ListTile(
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LegalPolicyPage()),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
              title: Text("Legal & Policy"),
            ),
            ListTile(
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      session.clearSession();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginpage()),
                      );
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
              title: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
