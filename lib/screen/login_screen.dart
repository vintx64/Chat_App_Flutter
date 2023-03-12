import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/register_screen.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:chat_app/widgets/custom_btn.dart';
import 'package:chat_app/widgets/cutom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  static String id = 'loginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 75,
                ),
                Image.asset(
                  kLogo,
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontFamily: 'pacifico',
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 75,
                ),
                Row(
                  children: const [
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomFormTextField(
                  onChanged: (data) {
                    password = data;
                  },
                  obsecureText: true,
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomBtn(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, ChatScreen.id,
                            arguments: email);
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'user-not-found') {
                          showSnackBar(
                              context, 'No user found for that email.');
                        } else if (ex.code == 'wrong-password') {
                          showSnackBar(context,
                              'Wrong password provided for that user.');
                        }
                      } catch (ex) {
                        print(ex);
                        showSnackBar(context, 'There was an error');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                  titleBtn: 'Sign In',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterScreen.id);
                      },
                      child: const Text(
                        '   Sign Up',
                        style: TextStyle(color: Color(0xffC7EDE6)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
