import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

class StaffScreen extends StatelessWidget {
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
                    future: UserDetail(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String name = snapshot.data?['name'] ?? 'staff';
                          String role = snapshot.data?['role'] ?? 'role';
                          return Column(
                            children: [
                              Text(
                                'Name: $name',
                                style: TextStyle(
                                    color: Colors.white,fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Role: $role',
                                style: TextStyle(color: Colors.white,fontSize: 18),
                              ),
                            ],
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
                'Contact: 9876543210',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildSectionTitle(context,'Available Seats'),
              _buildSeatInformation(),
              SizedBox(height: 20),
              _buildSectionTitle(context,'Filled Rooms'),
              _buildRoomInformation(),
              SizedBox(height: 20),
              _buildSectionTitle(context,'Payment Details'),
              _buildPaymentDetails(),
              SizedBox(height: 20),
              _buildSectionTitle(context,'Feedback from Students'),
              _buildFeedbackList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> UserDetail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();
        if (userQuery.docs.isNotEmpty) {
          return {
            'name': userQuery.docs.first.data()['name'],
            'role': userQuery.docs.first.data()['role'],
          };
        }
      }
      return {};
    } catch (e) {
      print('Error fetching user name: $e');
      return {};
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _buildSeatInformation() {
    return Text('10 seats are available');
  }

  Widget _buildRoomInformation() {
    return Text('10 rooms are filled');
  }

  Widget _buildPaymentDetails() {
    return Text('Payment details will be displayed here.');
  }


  Widget _buildFeedbackList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot feedbackDoc = snapshot.data!.docs[index];
              String feedbackText = feedbackDoc['others'] ?? 'No feedback provided';
              String userName = feedbackDoc['name'] ?? 'Anonymous'; // Assuming 'name' field contains the username
              int roomRating = feedbackDoc['roomrating'] ?? 0;
              int cleanlinessRating = feedbackDoc['cleanlinessrating'] ?? 0;
              int foodRating = feedbackDoc['foodrating'] ?? 0;
              int others = feedbackDoc['others'] ?? 0;

              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submitted by: $userName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Feedback: $feedbackText'),
                    Text('Room Rating: $roomRating'),
                    Text('Cleanliness Rating: $cleanlinessRating'),
                    Text('Food Rating: $foodRating'),
                    Text('Other Feedback: $others'),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }


}
