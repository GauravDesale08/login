import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mlsc/AboutUs.dart';
import 'package:mlsc/course.dart';
import 'package:mlsc/live.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var userData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                  if (userData == null || userData['name'] == null) {
                    return Center(
                      child: Text('Name not found in user data'),
                    );
                  }

                  String name = userData['name'];
                  String email = userData['email'];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        // You can set the avatar image here
                        backgroundColor: Colors.white,
                        child: Text('A'), // Placeholder avatar
                      ),
                      SizedBox(height: 10),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to home screen
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Courses'),
              onTap: () {
                // Navigate to courses screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => course()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv),
              title: Text('Live Classes'),
              onTap: () {
                // Navigate to live classes screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Live()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                // Navigate to about us screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            // Add more list items for navigation options
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (userData == null || userData['name'] == null) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Name not found in user data'),
            );
          }

          String name = userData['name'];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Hello, $name!',
              style: TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
