import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mlsc/LoginScreen.dart';
import 'package:mlsc/form/formPage.dart';

import 'home.dart';

class SignUpPage extends StatefulWidget {
  final void Function()? onPressed;
  const SignUpPage({Key? key, this.onPressed}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  var _isObscure = true;
  bool isLoading = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

createUserWithEmailAndPassword(BuildContext context) async {
  try {
    setState(() {
      isLoading = true;
    });

    // Create the user in Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );

    // If the user creation is successful, store the username in the Realtime Database
    if (userCredential.user != null) {
      await saveUsernameToDatabase(userCredential.user!.uid);

      setState(() {
        isLoading = false;
      });

      // Navigate to the form page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FormPage(), // Navigate to FormPage after successful account creation
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Account created successfully."),
      ));
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      isLoading = false;
    });
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The password provided is too weak."),
      ));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The account already exists for that email."),
      ));
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print(e);
  }
}



  // Function to save username to Realtime Database
  Future<void> saveUsernameToDatabase(String userId) async {
    final reference = FirebaseDatabase.instance.reference().child('users');

    await reference.child(userId).set({
      'username': _username.text,
      // Add any other user-related information you want to store in the database
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/vege.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _username,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Username is empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _email,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Email is empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _password,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Password is empty';
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            child: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: Icon(Icons.vpn_key),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPassword,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Confirm Password is empty';
                          } else if (text != _password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            child: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: Icon(Icons.vpn_key),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createUserWithEmailAndPassword(context);
                            // Navigate to the form page
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    FormPage(), // Navigate to FormPage after successful account creation
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text("Sign Up"),
                      ),
                      SizedBox(height: 10),
                      Icon(Icons.arrow_forward),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: widget.onPressed ??
                                () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage(), // Replace HomeScreen with your actual home screen widget
                                    ),
                                  );
                                },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
