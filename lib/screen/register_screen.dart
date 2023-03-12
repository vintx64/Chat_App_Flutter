import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../widgets/custom_btn.dart';
import '../widgets/cutom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  static String id = 'registerScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;

  String? password;

  bool isLoading = false;

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
                      'Register',
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
                  hintText: 'Password',
                  obsecureText: true,
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
                        await registerUser();
                        Navigator.pushNamed(context, ChatScreen.id);
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'weak-password') {
                          showSnackBar(
                              context, 'The password provided is too weak.');
                        } else if (ex.code == 'email-already-in-use') {
                          showSnackBar(context,
                              'The account already exists for that email.');
                        }
                      } catch (ex) {
                        showSnackBar(context, 'There was an error');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                  titleBtn: 'Sign Up',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'already have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'LoginScreen');
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '   Login',
                          style: TextStyle(color: Color(0xffC7EDE6)),
                        ),
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

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
