import 'dart:async';

import 'package:app_the_weather/src/helpers/Validator.dart';
import 'package:flutter/material.dart';
class SignInController{
  StreamController _isEmail = new StreamController();
  StreamController _isPassword=new StreamController();

  Stream get emailStream => _isEmail.stream;
  Stream get passwordStream => _isPassword.stream;

  Validator validator=new Validator();

  bool onSubmidSignIn({
  @required String email,
  @required String password
}){
    _isEmail.sink.add('OKE');
    _isPassword.sink.add('OKE');
    if(!validator.isValidEmail(email))
      {
        _isEmail.sink.addError('Invalid email address.');
        return false;
      }

    if(!validator.isValidPass(password))
      {
        _isPassword.sink.addError('Invalid password.');
        return false;
      }
    else return true;

  }

  void dispose(){
    _isEmail.close();
    _isPassword.close();
  }
}