import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'About Our Classes',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'Description about the classes...',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 24.0),
          Text(
            'Faculty',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // You can replace this with a ListView.builder if you have a list of faculty members
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8.0),
                  Text('Faculty Name 1'),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8.0),
                  Text('Faculty Name 2'),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Text(
            'Courses Offered',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // List of courses offered
          Text('Course 1'),
          Text('Course 2'),
          Text('Course 3'),
          // Add more Text widgets for additional courses
        ],
      ),
    );
  }
}

