import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackFormScreen extends StatefulWidget {
  @override
  _FeedbackFormScreenState createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final TextEditingController _otherFeedbackController =
      TextEditingController();
  String _name = "";
  int _roomRating = 5;
  int _cleanlinessRating = 5;
  int _foodRating = 5;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade200, Colors.indigo.shade200],
        )),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feedback Form',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.group),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    RatingSelector('Room Rating', _roomRating, (value) {
                      setState(() {
                        _roomRating = value!;
                      });
                    }),
                    SizedBox(height: 10),
                    RatingSelector('Cleanliness Rating', _cleanlinessRating,
                        (value) {
                      setState(() {
                        _cleanlinessRating = value!;
                      });
                    }),
                    SizedBox(height: 10),
                    RatingSelector('Food Rating', _foodRating, (value) {
                      setState(() {
                        _foodRating = value!;
                      });
                    }),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _otherFeedbackController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Other Feedback',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitFeedback(context);
                      },
                      child: Text('Submit Feedback'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget RatingSelector(
      String label, int rating, void Function(int?) onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label),
        ),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            value: rating,
            onChanged: onChanged,
            items: List.generate(10, (index) => index + 1)
                .map((value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _submitFeedback(BuildContext context) async {
    try {
      // Check if all required fields are filled
      if (_roomRating == null ||
          _cleanlinessRating == null ||
          _foodRating == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please provide feedback for all fields'),
          duration: Duration(seconds: 2),
        ));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Get the feedback details
      String otherFeedback = _otherFeedbackController.text;

      // Construct a map containing the feedback data
      Map<String, dynamic> feedbackData = {
        'name': _name,
        'roomrating': _roomRating,
        'cleanlinessrating': _cleanlinessRating,
        'foodrating': _foodRating,
        'others': otherFeedback,
        'timestamp': FieldValue.serverTimestamp(),
        // Add a timestamp for the feedback
      };

      // Add the feedback data to Firestore
      await FirebaseFirestore.instance.collection('feedback').add(feedbackData);

      // Clear the input fields after submission
      _otherFeedbackController.clear();

      // Show a snackbar or toast to inform the user that the feedback has been submitted
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback submitted successfully!'),
        duration: Duration(seconds: 2),
      ));
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting feedback: $e');
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }
}
