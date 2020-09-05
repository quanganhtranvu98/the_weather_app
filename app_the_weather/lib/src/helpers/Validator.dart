import 'package:flutter/material.dart';

class Validator{
  bool isValidEmail(String email){
    return email.length>6 && email.contains('@');
  }

  bool isValidPass(String pass){
    return pass.length>6;
  }



}