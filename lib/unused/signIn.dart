// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:winbin/home.dart';
// import 'package:winbin/main.dart';
// import 'package:winbin/signUp.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   final bool autoLogin;
//   LoginPage(this.autoLogin);

//   @override
//   State<StatefulWidget> createState() {
//     return _LoginPageState(autoLogin);
//   }
// }

// class _LoginPageState extends State<LoginPage> {
//   bool autoLogin = true;
//   _LoginPageState(this.autoLogin);
//   String _email, _password;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passController = TextEditingController();
//   FocusNode _emailFocus = FocusNode();
//   FocusNode _passFocus = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     if (autoLogin) {
//       tryAutoLogin();
//     }
//   }

//   void tryAutoLogin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _emailController.text = prefs.getString("email") ?? "";
//     _passController.text = prefs.getString("password") ?? "";
//     if (_emailController.text != "" && _passController.text != "") {
//       signIn(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: themeData.colorScheme.secondary,
//           title: Text("Sign In"),
//         ),
//         body: FutureBuilder(
//           future: SharedPreferences.getInstance(),
//           builder: (BuildContext context, prefs) {
//             return Form(
//               key: _formKey,
//               child: Container(
//                 color: themeData.backgroundColor,
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
//                       child: TextFormField(
//                         style: themeData.textTheme.title,
//                         focusNode: _emailFocus,
//                         controller: _emailController,
//                         onEditingComplete: () {
//                           _fieldFocusChange(context, _emailFocus, _passFocus);
//                         },
//                         textInputAction: TextInputAction.next,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (String value) {
//                           return value.isEmpty
//                               ? 'You must provide an email.'
//                               : null;
//                         },
//                         onSaved: (input) => _email = input,
//                         decoration: InputDecoration(
//                           labelStyle: themeData.textTheme.title,
//                           errorStyle: themeData.textTheme.title,
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.secondary,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.primary,
//                             ),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.error,
//                             ),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.primary,
//                             ),
//                           ),
//                           labelText: "Email",
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
//                       child: TextFormField(
//                         style: themeData.textTheme.title,
//                         focusNode: _passFocus,
//                         controller: _passController,
//                         validator: (String value) {
//                           return value.isEmpty
//                               ? 'You must provide a password.'
//                               : null;
//                         },
//                         textInputAction: TextInputAction.go,
//                         onEditingComplete: () {
//                           signIn(context);
//                         },
//                         onSaved: (input) => _password = input,
//                         decoration: InputDecoration(
//                           labelStyle: themeData.textTheme.title,
//                           errorStyle: themeData.textTheme.title,
//                           errorBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.error,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.secondary,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.primary,
//                             ),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               color: themeData.colorScheme.primary,
//                             ),
//                           ),
//                           labelText: "Password",
//                         ),
//                         obscureText: true,
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                       width: 400,
//                       height: 55,
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                                 offset: Offset.fromDirection(1, 3),
//                                 color: Color(0x55000000),
//                                 blurRadius: 2,
//                                 spreadRadius: 2)
//                           ],
//                           color: themeData.colorScheme.primaryVariant,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: FlatButton(
//                         color: Colors.transparent,
//                         onPressed: (){signIn(context);},
//                         child: Text(
//                           "Sign In",
//                           style: themeData.textTheme.title,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
//                       width: 400,
//                       height: 55,
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                                 offset: Offset.fromDirection(1, 3),
//                                 color: Color(0x55000000),
//                                 blurRadius: 2,
//                                 spreadRadius: 2)
//                           ],
//                           color: themeData.colorScheme.secondaryVariant,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: FlatButton(
//                         color: Colors.transparent,
//                         onPressed: goToSignUp,
//                         child: Text(
//                           "New? Create an account.",
//                           style: themeData.textTheme.title,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ));
//   }

//   void goToSignUp() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
//   }

//   Future signIn(BuildContext cont) async {
//     final _formState = _formKey.currentState;
//     if (_formState.validate()) {
//       _formState.save();
//       try {
//         FirebaseUser user = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(email: _email, password: _password).then((auth){return auth.user;});
//         currentUser = user;
//         await SharedPreferences.getInstance().then((d) {
//           d.setString('email', _email);
//           d.setString('password', _password);
//         });
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => Home(user: user)));
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
//               content: Text("How did you do this?"),
//             ));
//           });
//         }
//       }
//     }
//   }

//   _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
//     currentFocus.unfocus();
//     FocusScope.of(context).requestFocus(nextFocus);
//   }
// }
