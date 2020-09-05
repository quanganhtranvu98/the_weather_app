import 'package:app_the_weather/Firebase/Firebase_auth.dart';
import 'package:app_the_weather/Page/Page_weather.dart';
import 'package:app_the_weather/dialog/Loading_dialog.dart';
import 'package:app_the_weather/dialog/Msg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
class Signin_Screen extends StatefulWidget {
  @override
  _Signin_ScreenState createState() => _Signin_ScreenState();
}

class _Signin_ScreenState extends State<Signin_Screen> {
  final _formkey=GlobalKey<FormState>();
  var _authBase=file_auth();
  TextEditingController _nameController=new TextEditingController();
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passController= new TextEditingController();
  String _email;
  String _password;
  String _name;

  bool inName=true;
  bool inEmail=true;
  bool inPass=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient:LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5)

                      ],
                      stops: [0.1,0.4,0.7,0.9]

                  )
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Create an Account',style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0

                      ),),
                      SizedBox( height:30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('User Name', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),) ,
                          SizedBox(height: 10.0,),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Color(0xFF6CA8F1),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              controller: _nameController,
                              //validator: (input) => !input.contains('@') ? 'Please an email' : null,
                              onSaved: (input) => _name=input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(Icons.perm_identity,color: Colors.white,),
                                hintText: 'Enter a Name',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'OpenSans',
                                ),

                              ),

                            ),

                          )

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(inName==true?'':'Try again your Name',style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15
                        ),),
                      ),
                      SizedBox( height: 15.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Email', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),) ,
                          SizedBox(height: 10.0,),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Color(0xFF6CA8F1),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              controller: _emailController,
                              //validator: (input) => !input.contains('@') ? 'Please an email' : null,
                              onSaved: (input) => _email=input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(Icons.email,color: Colors.white,),
                                hintText: 'Enter a Email',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'OpenSans',
                                ),

                              ),

                            ),

                          )

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(inEmail==true?'':'Try again your Email',style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15
                        ),),
                      ),
                      SizedBox(height: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Password', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),) ,
                          SizedBox(height: 10.0,),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Color(0xFF6CA8F1),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60,
                            child: TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              controller: _passController,
                              //validator: (input) => input.length<6 ? 'Please enter a Password' : null,
                              onSaved: (input) => _password=input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(Icons.lock,color: Colors.white,),
                                hintText: 'Enter a Password',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'OpenSans',
                                ),

                              ),

                            ),

                          )

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                        child: Text(inName==true?'':'Try again your Password',style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15
                        ),),
                      ),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 25.0, ),
                        child: RaisedButton(
                          elevation: 4.0,
                          onPressed: _onSignUpClick,
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          color: Colors.white,
                          child: Text('Create an Account', style: TextStyle(
                              color: Color(0xFF527DAA),
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                          ),),

                        ),
                      ),
                      SizedBox(height: 5,),//login
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Screean()));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: 'Already a User? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,

                                )),
                            TextSpan(text: 'Login now',
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,

                                )),
                          ]),
                        ),
                      )
                      //icon face anh google
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _onSignUpClick(){
    setState(() {
      if(_nameController.text.length<2)
      {
        inName=false;
      }else inName=true;
      if(_emailController.text.length<6 || !_emailController.text.contains('@'))
      {
        inEmail=false;
      }else inEmail=true;
      if(_passController.text.length<6 ){inPass=false;}
      else inPass=true;
    });
    if(inName==true && inPass==true && inEmail==true)
      {
        loadingDialog.showLoadingDialog(context, 'Loading...');
        _authBase.SingIn(_emailController.text, _passController.text, _nameController.text,(){
          loadingDialog.hideDialog(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => page_weather()));

        }, (errorRegister){
          //show messega dialog
          loadingDialog.hideDialog(context);
          Msgdialog.showMsgDialoog(context, 'Notification', errorRegister);

        });

      }



  }
}
