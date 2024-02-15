import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostelmanagement/Screens/homescreen/student_screen.dart';
import 'package:hostelmanagement/Screens/registration_screen.dart';

import 'homescreen/staff_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple.shade200,
                  Colors.indigo.shade200
                ],
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/hostel_image.jfif"),
                    Text("MT HOSTEL",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                  ]
                ),
                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF527DAA),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: _obscureText ? Colors.grey : Colors.blue, // Customize icon color
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText; // Toggle the value
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _signInWithEmailAndPassword(context),
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          primary: Color(0xFF527DAA),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                        child: Text('Register'),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('Signed in: ${userCredential.user!.uid}');

      // Fetch user role from Firestore using the user's email
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      // Ensure only one document is retrieved
      if (userQuery.docs.length == 1) {
        var userRole = userQuery.docs.first.data()['role'];

        // Navigate to the appropriate dashboard based on user role
        switch (userRole.toLowerCase()) {
          case 'student':
            Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentScreen()));
            break;
          case 'staff':
            Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffScreen()));
            break;
          case 'owner':
            Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffScreen()));
            break;
          default:
          // Handle other cases or show a message for invalid role
            print('Invalid role found in Firestore for the user.');
            break;
        }
      } else {
        // Handle case where user document is not found or multiple documents found (which should not happen)
        print('User not found or multiple users found');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Show a snackbar or dialog to inform the user
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // Show a snackbar or dialog to inform the user
      }
    } catch (e) {
      print('Error: $e');
      // Show a snackbar or dialog to inform the user
    }
  }

}
