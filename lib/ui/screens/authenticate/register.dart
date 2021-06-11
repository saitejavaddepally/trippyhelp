import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_on_click/services/authentication.dart';
import 'package:travel_on_click/services/database.dart';
import 'package:travel_on_click/ui/helper/common_classes.dart';
// import 'package:travel_on_click/ui/helper/sharedpref_helper.dart';
import 'package:travel_on_click/ui/screens/authenticate/sign_in.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _email;
  late String _password;
  late String userId;
  late String _passwordRepeat;
  String error = "";
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0) ,
          child: Scaffold(
        appBar: AppBarThemeCustom([]),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(30.9),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                      image: AssetImage('lib/ui/assets/images/travel_world.png')),
                  Text(
                    'Register',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 17.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                  SizedBox(
                    height: 19.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye_sharp))),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value.trim();
                      });
                    },
                  ),
                  SizedBox(
                    height: 19.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Retype Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _passwordRepeat = value.trim();
                      });
                    },
                  ),
                  SizedBox(height: 17.0),
                  TextButton(
                      onPressed: () async {
                        if (_password == _passwordRepeat) {
                          SnackBarWidget(
                                  duration: 1, text: "Registering.. please wait")
                              .showSnackBar(context);

                          User? result = await AuthMethods()
                              .signUpWithEmailAndPassword(_email, _password);
                          DatabaseLocationService(uid: result!.uid).getUserData();

                          setState(() {
                            userId = result.uid;
                          });
                          // ignore: unnecessary_null_comparison
                          if (result == null) {
                            SnackBarWidget(
                                    duration: 2, text: "Failed to register")
                                .showSnackBar(context);
                          }

                          // ignore: unnecessary_null_comparison
                          if (result != null)
                            SnackBarWidget(
                                    duration: 2,
                                    text: "Welcome, Thankyou for registering")
                                .showSnackBar(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("email", result.email!);
                          prefs.setString("userId", result.uid);

                          Navigator.of(context).pushReplacementNamed('/home');
                        } else if (_password != _passwordRepeat) {
                          SnackBarWidget(duration: 2, text: "Check the password")
                              .showSnackBar(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text("You are signing in with Google")));
                              AuthMethods().signInWithGoogle(context);
                            },
                            icon: Icon(Icons.account_box)),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn())),
                            child: Text('Login here..'))
                      ],
                    ),  
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
