import 'package:ecommerce_app/components/bottom_navigation.dart';
import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/user/model_edit_user.dart';
import 'package:ecommerce_app/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfiluser extends StatefulWidget {
  const EditProfiluser({super.key});

  @override
  State<EditProfiluser> createState() => _EditProfiluserState();
}

class _EditProfiluserState extends State<EditProfiluser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? id, username, email;
  TextEditingController txtusername = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      email = pref.getString("email") ?? '';
      print("id $id");
      print("id $username");
    });
  }

  Future<ModelEditProfile?> editUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res =
          await http.post(Uri.parse('${url}edit_profile.php'), body: {
        "id": '$id',
        "username": _usernameController.text,
        "email": _emailController.text,
      });
      ModelEditProfile data = modelEditProfileFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          session.saveSession(
              data.value ?? 0, id ?? "", data.email ?? "", data.username ?? ""
              // data.username ?? "",
              );
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BotNav()),
            (route) => false);
      } else if (data.value == 0) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
    print(id);
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: keyForm,
            child: Column(
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
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                // Space between profile picture and user information
                SizedBox(height: 24.0),

                // Username Edit Form
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username  $username',
                    hintText: '$username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email  $email',
                    hintText: '$email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 50.0),

                // Update Button
                Container(
                  width: 350, // Lebar tombol
                  height: 60, // Tinggi tombol

                  child: ElevatedButton(
                    onPressed: () {
                      if (keyForm.currentState?.validate() == true) {
                        setState(() {
                          editUser();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("silahkan isi data terlebih dahulu")));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.greenAccent), // Background color
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // Text color
                    ),
                    child: Text(
                      'Confim',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
