import 'package:app_the_weather/Page/Page_weather.dart';
import 'package:app_the_weather/views/Rigister/Signin/sign_in_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'SignIn_screen.dart';
import 'package:app_the_weather/dialog/Loading_dialog.dart';
import 'package:app_the_weather/dialog/Msg_dialog.dart';
import 'package:app_the_weather/Firebase/Firebase_auth.dart';

class Login_Screean extends StatefulWidget {
  @override
  _Login_ScreeanState createState() => _Login_ScreeanState();
}

class _Login_ScreeanState extends State<Login_Screean> {
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final _formkey=GlobalKey<FormState>();
  var _authBase=file_auth();
  String _email,_password;
  bool rememberMe=false;
  bool _obscure=true;
  TextEditingController _userController= new TextEditingController();
  TextEditingController _passController= new TextEditingController();
  SignInController signInController=new SignInController();

  String _textErrorPassword='You entered the wrong email or password ';


  var _passInvalid=false;
  @override
  void initState(){
    super.initState();
      Future(() async {
        if (await _firebaseAuth.currentUser() != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page_weather()));
        }
      });
  }

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
                      Text('Sign In',style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0

                      ),),
                      SizedBox( height:30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Email', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),) ,
                          SizedBox(height: 10.0,),
                          StreamBuilder(
                            stream: signInController.emailStream,
                            builder: (context,snapshot) =>
                                 TextField(
                                    autofocus: false,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.white),
                                    controller: _userController,
                                    decoration:InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue),
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red),
                                      ),
                                      focusedErrorBorder:OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red),
                                      ) ,

                                      contentPadding: EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(Icons.email,color: Colors.white,),
                                      hintText: 'Enter a Email',
                                      errorText: snapshot.hasError?snapshot.error:null,
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontFamily: 'OpenSans',
                                      ),




                                    )
                                    ,

                                  ),
                                )



                        ],
                      ),
                      SizedBox(height: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Password', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),) ,
                          SizedBox(height: 10.0,),
                          Stack(
                            children: [
                              Container(
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
                                height: 48,
                              ),
                              StreamBuilder(
                                stream: signInController.passwordStream,
                                builder: (context,snapshot) => TextFormField(
                                  obscureText: _obscure,
                                  controller: _passController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      errorText: snapshot.hasError?snapshot.error:null,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue),
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red),
                                      ),
                                      focusedErrorBorder:OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red),
                                      ) ,
                                      contentPadding: EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(Icons.lock,color: Colors.white,),
                                      hintText: 'Enter a Password',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontFamily: 'OpenSans',

                                      ),
                                      suffixIcon: IconButton(icon: Icon(_obscure==true? Icons.visibility:Icons.visibility_off),

                                        onPressed: (){
                                          setState(() {
                                            _obscure=!_obscure;
                                          });
                                        },
                                      )

                                  ),

                                ),
                              ),

                            ],
                          )


                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: (){},
                          padding: EdgeInsets.only(right: 0),
                          child: Text('Forgot Password',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),),
                        ),
                      ),
//                      Container(
//                        height: 20,
//                        child: Row(
//                          children: <Widget>[
//                            Theme(data: ThemeData(unselectedWidgetColor: Colors.white),
//                            child: Checkbox(
//                              value: rememberMe,
//                              checkColor: Colors.green,
//                              activeColor: Colors.white,
//                              onChanged: (value){
//                                setState(() {
//                                  rememberMe=true;
//                                });
//                              },
//                            ),
//                            ),
//                            Text('Remember me', style: TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.bold,
//                              fontFamily: 'OpenSans',
//                            ),)
//
//                          ],
//                        ),
//                      ), //remember pass
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 25.0, ),
                        child: RaisedButton(
                          elevation: 4.0,
                          onPressed: _submid,
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                          ),
                          color: Colors.white,
                          child: Text('Login', style: TextStyle(
                            color: Color(0xFF527DAA),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),),

                        ),
                      ), //login
                      Column(
                        children: <Widget>[
                          Text('-OR-',style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5
                          ),),
                          SizedBox(height: 10,),
                          Text('Sign in with', style: TextStyle(
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),),

                        ],
                      ),
                      //build sign in with text
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                           GestureDetector(
                            onTap: () => print('login face'),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0,2),
                                      blurRadius: 6.0
                                  )],
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/facebook.jpg')
                                  )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => print('login google'),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0,2),
                                      blurRadius: 6.0
                                  )],
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/google.jpg')
                                  )
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),
                      //icon face anh google
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Signin_Screen()));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: 'Dont have an Accoun? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,

                            )),
                            TextSpan(text: 'Sign Up? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,

                                )),
                          ]),
                        ),
                      )
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

  void _submid() {
      // ignore: unrelated_type_equality_checks
      if(signInController.onSubmidSignIn(email: _userController.text, password: _passController.text)==true)
        {
            print('_passInvalid=true');
            loadingDialog.showLoadingDialog(context, 'Loading...');
            // ignore: unnecessary_statements
            _authBase.SignIn(_userController.text, _passController.text, (){
              loadingDialog.hideDialog(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => page_weather()));
            }, (err){
              loadingDialog.hideDialog(context);
              Msgdialog.showMsgDialoog(context, "Notification", err);

            });

        }






  }
}
