import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUpUser() async {
    try {
      // Create user with email & password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Store user details in Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "full_name": fullNameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "city": cityController.text.trim(),
          "uid": user.uid, // Store user ID
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-up successful! Please log in.")),
        );

        // Navigate to Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.green.withOpacity(0.3),
                  child: Icon(Icons.recycling, size: 80, color: Colors.green),
                ),
                SizedBox(height: 20),

                Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Sign up to contribute to e-waste recycling!", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 30),

                TextField(controller: fullNameController, decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
                SizedBox(height: 20),

                TextField(controller: emailController, decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
                SizedBox(height: 20),

                TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
                SizedBox(height: 20),

                TextField(controller: cityController, decoration: InputDecoration(labelText: "City", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city))),
                SizedBox(height: 20),

                TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: signUpUser,
                  child: Text("Sign Up", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("Already have an account? Login", style: TextStyle(color: Colors.green, fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
