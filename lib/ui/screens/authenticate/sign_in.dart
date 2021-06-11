import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_on_click/services/authentication.dart';
import 'package:travel_on_click/ui/helper/common_classes.dart';
import 'package:travel_on_click/ui/helper/sharedpref_helper.dart';
import 'package:travel_on_click/ui/screens/authenticate/register.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String _email;
  late String _password;
  String error = "";
  bool _obscureText = true;
  String? emailKey = SharedPreferenceHelper.userEmailKey;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0) ,
          child: Scaffold(
        key: _scaffoldKey,
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
                    'Sign In',
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
                  SizedBox(height: 17.0),
                  TextButton(
                      onPressed: () async {
                        SnackBarWidget(
                                duration: 1, text: "Logging in.. please wait")
                            .showSnackBar(context);

                        User? result = await AuthMethods()
                            .signInWithEmailAndPassword(_email, _password);
                        if (result == null) {
                          SnackBarWidget(duration: 2, text: "Sign In Failed")
                              .showSnackBar(context);
                        }
                        if (result != null) {
                          SnackBarWidget(duration: 2, text: "Welcome Back")
                              .showSnackBar(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("email", result.email!);
                          prefs.setString("userId", result.uid);
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sign in with google
                        IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text("You are signing in with Google")));

                              AuthMethods().signInWithGoogle(context);
                            },
                            icon: Icon(Icons.account_circle_outlined)),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text('Not yet registered?'),
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register())),
                            child: Text('Register here..'))
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
