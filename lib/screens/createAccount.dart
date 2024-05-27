import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_work/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/user_model.dart';
import 'login.dart';

class CreateAccountt extends StatefulWidget {
  const CreateAccountt({super.key});

  @override
  State<CreateAccountt> createState() => _CreateAccounttState();
}

class _CreateAccounttState extends State<CreateAccountt> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: CreateAccount(
              fullNameController: fullNameController,
              emailController: emailController,
              passwordController: passwordController,
              passwordVisible: _passwordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              formKey: _formKey,
              auth: _auth,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateAccount extends StatelessWidget {
  const CreateAccount({
    Key? key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.togglePasswordVisibility,
    required this.formKey,
    required this.auth,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final VoidCallback togglePasswordVisibility;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    final fullNameField = Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: TextFormField(
        autofocus: false,
        controller: fullNameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Your Full Name";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

    final emailField = Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Your Email";
          }
          // reg expression for email validation
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return "Please Enter a valid email";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

    final passwordField = Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: !passwordVisible,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Your Password";
          }
          if (value.length < 6) {
            return "Password must be at least 6 characters long";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon:
                Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: togglePasswordVisibility,
          ),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

    return Column(
      children: [
        Container(
          width: 414,
          height: 932,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 30,
                top: 103,
                child: SizedBox(
                  width: 354,
                  child: Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 35,
                top: 261,
                child: Container(
                  width: 343,
                  child: fullNameField,
                ),
              ),
              Positioned(
                left: 35,
                top: 339,
                child: Container(
                  width: 343,
                  child: emailField,
                ),
              ),
              Positioned(
                left: 35,
                top: 417,
                child: Container(
                  width: 343,
                  child: passwordField,
                ),
              ),
              Positioned(
                left: 30,
                top: 520,
                child: GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      signUp(emailController.text, passwordController.text,
                          context);
                      formKey.currentState!.save();
                      print("Create account button pressed");
                    }
                  },
                  child: Container(
                    width: 354,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF31A062),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Create account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 594,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    ); // Handle already have an account button press
                  },
                  child: const SizedBox(
                    width: 354,
                    child: Text(
                      'Already have an account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF31A062),
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 152,
                child: SizedBox(
                  width: 354,
                  child: Text(
                    'Invest and double your income now',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void signUp(String email, String password, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    if (formKey.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(context),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message, backgroundColor: Colors.red);
        Navigator.of(context).pop();
      });
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  postDetailsToFirestore(BuildContext context) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullNameController.text;
    userModel.email = emailController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(
        msg: "Account created successfully ", backgroundColor: Colors.red);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }
}
