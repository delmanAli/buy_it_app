import 'package:buy_it_app/provider/admin_mode.dart';
import 'package:buy_it_app/provider/modal_hud.dart';
import 'package:buy_it_app/screens/admin/admin_home.dart';
import 'package:buy_it_app/screens/signup_screen.dart';
import 'package:buy_it_app/screens/user/home_page.dart';
import 'package:buy_it_app/services/auth.dart';
import 'package:buy_it_app/widgets/custem_textfield.dart';
import 'package:buy_it_app/widgets/custom_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buy_it_app/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final adminPassword = 'admin1234';

  String _email;

  String _password;

  bool isAdmin = false;

  bool keepMeLogedIn = false;

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: widget.globalKey,
          child: ListView(
            children: [
              CustomLogo(),
              SizedBox(height: height * .1),
              CustemTextField(
                hint: 'Enter Your Email',
                icon: Icons.email,
                onClick: (val) {
                  _email = val;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: Checkbox(
                        checkColor: kSecondaryColor,
                        activeColor: kMainColor,
                        value: keepMeLogedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLogedIn = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
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
                    onPressed: () {
                      if (keepMeLogedIn == true) {
                        keepUserLoggedIn();
                      }
                      _validate(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black,
                    child: Text(
                      'login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * .05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'don\t have an account ? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SignupScreen.id);
                    },
                    child: Text(
                      'Sognup ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(true);
                        },
                        child: Text(
                          'i\am an admin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin
                                ? kMainColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        child: Text(
                          'i\am a user',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin
                                ? Colors.white
                                : kMainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modalHud = Provider.of<ModalHud>(context, listen: false);
    modalHud.changeIsLoading(true);
    if (widget.globalKey.currentState.validate()) {
      widget.globalKey.currentState.save();

      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            await _auth.signIn(_email, _password);
            Navigator.of(context).pushReplacementNamed(AdminHome.id); //admin
          } on FirebaseAuthException catch (e) {
            modalHud.changeIsLoading(false);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.message,
                ),
              ),
            );
          }
        } else {
          modalHud.changeIsLoading(false);

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error ouccurred',
              ),
            ),
          );
        }
      } else {
        try {
          await _auth.signIn(_email, _password);
          Navigator.of(context).pushReplacementNamed(HomePage.id);
        } on FirebaseAuthException catch (e) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.message,
              ),
            ),
          );
        }
      }
    }
    modalHud.changeIsLoading(false);
  }

  void keepUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(kKeepMeLoggedIn, keepMeLogedIn);
  }
}
