import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostelmanagement/Screens/login_screen.dart';

import '../student/feedback.dart';
import '../student/payment.dart';

class StudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple.shade200, Colors.indigo.shade200])),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: UserName(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String name = snapshot.data ?? 'Student';
                          return Text(
                            'Welcome $name',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          );
                        }
                      }
                    },
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.power_settings_new),
                          Text("Logout"),
                        ],
                      ),
                  )
                ],
              ),
              SizedBox(height: 20),
              // Hostel Information Section
              Text(
                'Hostel Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Add hostel image and details
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/hostel_image.jfif'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Name: MT Hostel',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Owner: Martin Thekkat',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Contact: 9876543210\nEmail: mthostel@gmail.com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Rent Information Section
              Text(
                'Rent Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Add rent details
              Text(
                'Your rent is due on 15th of every month.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Feedback Section
              Text(
                'Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  // Navigate to feedback page
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackFormScreen()));
                },
                child: Text('Provide Feedback'),
              ),
              SizedBox(height: 20),
              // Payment Section
              Text(
                'Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Add payment options or link to payment page
              ElevatedButton(
                onPressed: () {
                  // Navigate to payment page
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
                },
                child: Text('Make Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> UserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();
        if (userQuery.docs.isNotEmpty) {
          return userQuery.docs.first.data()['name'];
        }
      }
      return '';
    } catch (e) {
      print('Error fetching user name: $e');
      return '';
    }
  }
}
