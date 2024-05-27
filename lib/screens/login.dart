import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'createAccount.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
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
            child: LoginForm(
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

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.togglePasswordVisibility,
    required this.formKey,
    required this.auth,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final VoidCallback togglePasswordVisibility;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
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
                    'Log in to your Account',
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
                      formKey.currentState!.save();
                      login(emailController.text, passwordController.text,
                          context);
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
                        'Log in',
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
                      MaterialPageRoute(
                          builder: (context) => const CreateAccountt()),
                    ); // Handle already have an account button press
                  },
                  child: const SizedBox(
                    width: 354,
                    child: Text(
                      'Dont have an account, Sign up',
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

  void login(String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(
          msg: "Login successful", backgroundColor: Colors.green);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }
  }
}
