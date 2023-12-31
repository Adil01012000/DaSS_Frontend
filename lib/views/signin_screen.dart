// ignore_for_file: unused_local_variable, prefer_const_constructors, avoid_print, prefer_const_declarations, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, depend_on_referenced_packages, use_build_context_synchronously, non_constant_identifier_names, sort_child_properties_last

import 'dart:convert';
import 'package:dass_frontend/user/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../admin/admin_dashboard.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signIn_screen';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final url = 'http://127.0.0.1:8000/api/login';
    // final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'pin_number': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = responseData['user'];
        final userType = user['type'];
        final quizId = user['quiz_id'];
        final name = user['name'];
        final quiz_attempt_id = responseData['quiz_attempt_id'];

        if (userType == 'admin') {
          Navigator.pushNamed(context, AdminDashboard.routeName);
        } else if (userType == 'user') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDashboard(
                quizId: quizId,
                name: name,
                quiz_attempt_id: quiz_attempt_id,
              ),
            ),
          );
        } else {
          // showToastMessage('Invalid User Type');
        }
      } else if (response.statusCode == 401) {
        // Incorrect email or password
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Sign-in Failed'),
            content: Text('Incorrect Pin Number'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // showToastMessage('Sign-in Failed');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 211, 255),
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/signin.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 400.0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: GoogleFonts.lobster(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Color.fromARGB(255, 50, 50, 50),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // TextFormField(
                      //   controller: _emailController,
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: InputDecoration(
                      //     labelText: 'Email',
                      //   ),
                      // ),
                      // SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(5),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter PIN',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a pin number.';
                          }
                          if (value.length != 5) {
                            return 'Pin length should be 5.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _signIn,
                        child: Text('Sign In'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 76, 52, 225),
                          ),
                        ),
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
