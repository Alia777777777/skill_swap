import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String userType = "Student";

  InputDecoration input(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFF647FBC)),
      prefixIcon: Icon(icon, color: Color(0xFF44ACFF)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color(0xFF44ACFF).withOpacity(0.3)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFF44ACFF).withOpacity(0.12),
              Color(0xFF647FBC).withOpacity(0.18),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF44ACFF).withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage("assets/logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 25),

                TextField(
                  controller: emailController,
                  decoration: input("Username", Icons.person),
                ),

                SizedBox(height: 15),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: input("Password", Icons.lock),
                ),

                SizedBox(height: 15),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xFF44ACFF).withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: userType,
                    dropdownColor: Colors.white,
                    underline: SizedBox(),
                    isExpanded: true,
                    items: ["Student", "Freelancer", "Company"]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(color: Color(0xFF647FBC)),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() => userType = val!);
                    },
                  ),
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(userType: userType),
                      ),
                    );
                  },
                  child: Text("LOGIN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}