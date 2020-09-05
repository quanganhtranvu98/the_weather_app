import 'package:app_the_weather/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_the_weather/Firebase/Firebase_auth.dart';
class mainDrawer extends StatefulWidget {
  @override
  _mainDrawerState createState() => _mainDrawerState();
}

class _mainDrawerState extends State<mainDrawer> {
  FirebaseUser user;
  var _authBase=file_auth();
  var name;
  getUserData()async{
    FirebaseUser userData=await FirebaseAuth.instance.currentUser();
    setState(() {
      user=userData;
      name=user.displayName;
      print(userData);
    });
  }
  void initState(){
    super.initState();
    getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/imagef.jpg'),
                      fit: BoxFit.fill,

                    ),
                  ),
                ),
                Text(name==null? ' ':name.toString(),style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),),
                Text(user==null? ' ':user.email.toString(),style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile',style: TextStyle(fontSize: 18),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting',style: TextStyle(fontSize: 18),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Logout',style: TextStyle(fontSize: 18),),
            onTap: (){
              _authBase.SignOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Screean()));

            },
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text('Version 0.0.1',style: TextStyle(fontSize: 13,color: Colors.black45),),
            ),
          )
        ],
      ),
    );
  }
}
