import 'package:buy_it_app/provider/modal_hud.dart';
import 'package:buy_it_app/screens/login_screen.dart';
import 'package:buy_it_app/screens/user/home_page.dart';
import 'package:buy_it_app/services/auth.dart';
import 'package:buy_it_app/widgets/custem_textfield.dart';
import 'package:buy_it_app/widgets/custom_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  static const String id = 'SignupScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _email;
  String _password;

  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              CustomLogo(),
              SizedBox(height: height * .1),
              CustemTextField(
                hint: 'Enter Your Name',
                icon: Icons.person,
                onClick: (val) {},
              ),
              SizedBox(height: height * .02),
              CustemTextField(
                hint: 'Enter Your Email',
                icon: Icons.email,
                onClick: (val) {
                  _email = val;
                },
              ),
              SizedBox(height: height * .02),
              CustemTextField(
                hint: 'Enter Your Password',
                icon: Icons.lock_open_outlined,
                onClick: (val) {
                  _password = val;
                },
              ),
              SizedBox(height: height * .05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (ctx) => FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final modalHud =
                          Provider.of<ModalHud>(context, listen: false);
                      modalHud.changeIsLoading(true);

                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        try {
                          await _auth.signUp(_email, _password);
                          modalHud.changeIsLoading(false);
                          Navigator.of(context)
                              .pushReplacementNamed(HomePage.id);
                        } on FirebaseAuthException catch (e) {
                          modalHud.changeIsLoading(false);

                          Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text(
                              e.message,
                            ),
                          ));
                        }
                      }
                      modalHud.changeIsLoading(false);
                    },
                  ),
                ),
              ),
              SizedBox(height: height * .05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'do have an account ? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.id);
                    },
                    child: Text(
                      'LogIn ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
