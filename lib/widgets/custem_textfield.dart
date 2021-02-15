import 'package:flutter/material.dart';

import '../constants.dart';

class CustemTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onClick;
  CustemTextField({
    @required this.hint,
    @required this.icon,
    @required this.onClick,
  });

  String _errorMessage(String str) {
    switch (hint) {
      case 'Enter Your Name':
        return 'Name is empty !';
      case 'Enter Your Email':
        return 'Email is empty !';
      case 'Enter Your Password':
        return 'Password is empty !';
    }
    return 'check all';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessage(hint);
          }
        },
        onSaved: onClick,
        obscureText: hint == 'Enter Your Password' ? true : false,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          hintText: hint,
          fillColor: kSecondaryColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
