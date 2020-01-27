// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:winbin/signIn.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'main.dart';

// class SignUp extends StatefulWidget {
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   String _email, _username, _password;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _userController = TextEditingController();
//   TextEditingController _passController = TextEditingController();
//   FocusNode _emailFocus = FocusNode();
//   FocusNode _userFocus = FocusNode();
//   FocusNode _passFocus = FocusNode();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: themeData.colorScheme.secondary,
//         title: Text("Sign Up"),
//       ),
//       body: Builder(builder: (BuildContext context) {
//         return Form(
//           key: _formKey,
//           child: Container(
//             color: themeData.backgroundColor,
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
//                   child: TextFormField(
//                     style: themeData.textTheme.title,
//                     focusNode: _emailFocus,
//                     controller: _emailController,
//                     onEditingComplete: () {
//                       _fieldFocusChange(context, _emailFocus, _userFocus);
//                     },
//                     autofocus: true,
//                     textInputAction: TextInputAction.next,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (String value) {
//                       return value.isEmpty
//                           ? 'You must provide an email.'
//                           : null;
//                     },
//                     onSaved: (input) => _email = input,
//                     decoration: InputDecoration(
//                       labelStyle: themeData.textTheme.title,
//                       errorStyle: themeData.textTheme.title,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.secondary,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.primary,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.error,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.primary,
//                         ),
//                       ),
//                       labelText: "Email",
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
//                   child: TextFormField(
//                     style: themeData.textTheme.title,
//                     focusNode: _userFocus,
//                     controller: _userController,
//                     onEditingComplete: () {
//                       _fieldFocusChange(context, _userFocus, _passFocus);
//                     },
//                     textInputAction: TextInputAction.next,
//                     validator: (String value) {
//                       return value.isEmpty
//                           ? 'You must provide a username.'
//                           : null;
//                     },
//                     onSaved: (input) => _username = input,
//                     decoration: InputDecoration(
//                       labelStyle: themeData.textTheme.title,
//                       errorStyle: themeData.textTheme.title,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.secondary,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.primary,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.error,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.primary,
//                         ),
//                       ),
//                       labelText: "Username",
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
//                   child: TextFormField(
//                     style: themeData.textTheme.title,
//                     focusNode: _passFocus,
//                     controller: _passController,
//                     validator: (String value) {
//                       return value.isEmpty
//                           ? 'You must provide a password.'
//                           : null;
//                     },
//                     textInputAction: TextInputAction.go,
//                     onEditingComplete: () {
//                       signUp(context);
//                     },
//                     onSaved: (input) => _password = input,
//                     decoration: InputDecoration(
//                       labelStyle: themeData.textTheme.title,
//                       errorStyle: themeData.textTheme.title,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.secondary,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.primary,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.error,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                           style: BorderStyle.solid,
//                           color: themeData.colorScheme.primary,
//                         ),
//                       ),
//                       labelText: "Password",
//                     ),
//                     obscureText: true,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(8, 3, 8, 0),
//                   width: 400,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                             offset: Offset.fromDirection(1, 3),
//                             color: Color(0x55000000),
//                             blurRadius: 2,
//                             spreadRadius: 2)
//                       ],
//                       color: themeData.colorScheme.primaryVariant,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: FlatButton(
//                     color: Colors.transparent,
//                     onPressed: () {
//                       signUp(context);
//                     },
//                     child: Text(
//                       "Sign Up",
//                       style: themeData.textTheme.title,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Future<void> signUp(BuildContext cont) async {
//     final _formState = _formKey.currentState;
//     if (_formState.validate()) {
//       _formState.save();
//       try {
//         FirebaseUser user = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: _email, password: _password).then((user){return user.user;});
//         Map<String, dynamic> data = {
//           'username': _username,
//           'email': _email,
//           "password": _password,
//           'posts':[],
//         };
//         Firestore.instance
//             .collection("users")
//             .document(user.uid)
//             .setData(data);
//         user.sendEmailVerification();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString("email", _email);
//         prefs.setString("password", _password);
//         Navigator.of(context).pop();
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => LoginPage(true)));
//       } catch (err) {
//         if (Theme.of(context).platform == TargetPlatform.iOS) {
//           setState(() {
//             Scaffold.of(cont).showSnackBar(SnackBar(
//               content: Text(err.message),
//             ));
//           });
//         } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//           setState(() {
//             Scaffold.of(cont).showSnackBar(SnackBar(
//               content: Text(err.code),
//             ));
//           });
//         } else {
//           setState(() {
//             Scaffold.of(cont).showSnackBar(SnackBar(
//               content: Text("How are you on neither android or ios?"),
//             ));
//           });
//         }
//       }
//     }
//   }

//   _fieldFocusChange(
//       BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
//     currentFocus.unfocus();
//     FocusScope.of(context).requestFocus(nextFocus);
//   }
// }
