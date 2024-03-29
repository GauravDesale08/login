import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mlsc/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedClass = '8th'; // Default value
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: 3,
              ),
              SizedBox(height: 10.0),
              Text('Gender'),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 10.0),
              Text('Class'),
              DropdownButton<String>(
                value: _selectedClass,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    // Set the selected class
                    setState(() {
                      _selectedClass = newValue;
                    });
                  }
                },
                items: <String>['8th', '9th', '10th', '11th', '12th']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission here
                  _submitForm(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    // Extract form data
    String name = _nameController.text;
    String email = _emailController.text;
    String mobile = _mobileController.text;
    String address = _addressController.text;
    String gender = _selectedGender ?? ''; // Use selected gender

    // Save data to Firestore
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'email': email,
          'mobile': mobile,
          'address': address,
          'gender': gender,
          'class': _selectedClass,
          'userId': user.uid,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );

        // Clear form fields after submission
        _nameController.clear();
        _emailController.clear();
        _mobileController.clear();
        _addressController.clear();
        setState(() {
          _selectedGender = null; // Reset selected gender
          _selectedClass = '8th'; // Reset to default class
        });

        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: user.uid)),
        );
      } else {
        throw Exception("User not signed in");
      }
    } catch (e) {
      // Show error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form')),
      );
      print('Error submitting form: $e');
    }
  }
}
