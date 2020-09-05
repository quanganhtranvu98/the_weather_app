import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
class file_auth{
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;


   SingIn(String username, String password, String name, Function onSuccess, Function(String) onRegisterError) async
  {
    final authResult= _firebaseAuth.createUserWithEmailAndPassword(email: username, password: password);
    await authResult.then((user){
      //neu thanh cong ngay vao day
//      print(user);
//      createUser(user.user.uid, name,onSuccess,onRegisterError);
    onSuccess();
    }).catchError((err){
      onSignUp(err.code, onRegisterError);

    });

   await updateUserName(name, (await authResult).user);

    
  }
//  Future<String> getCurrentID() async{
//     return (await _firebaseAuth.currentUser()).uid;
//  }
//
//  Future getCurrenUser()async{
//     return await _firebaseAuth.currentUser();
//  }
//  createUser(String Userid, String name, Function onSuccess,Function(String) onRegisterError){
//    var user={
//      "name":name
//    };
//    var ref=FirebaseDatabase.instance.reference().child('user');
//    ref.child('Userid').set(user).then((user){
//      onSuccess();
//    }).catchError((err){
//      onRegisterError('Sign Up Fail, try again!');
//
//    });
//
//
//  }

  Future updateUserName(String name, FirebaseUser currentUser) async{
     UserUpdateInfo userUpdateInfor=new UserUpdateInfo();
     userUpdateInfor.displayName=name;
     print('test  '+ currentUser.updateProfile(userUpdateInfor).toString());

     await  currentUser.updateProfile(userUpdateInfor);
     await currentUser.reload();

  }
  void onSignUp (String code, Function(String) onRegiterError){
     switch(code){
       case "ERROR_INVALID_EMAIL":
       case "ERROR_INVALID_CREDENTIAL":
         onRegiterError('Invalid Email');
         break;
       case "ERROR_EMAIL_ALREADY_IN_USE":
         onRegiterError('Email have Exists');
         break;
       case "ERROR_WEAK_PASSWORD" :
         onRegiterError('Invalid Password');
         break;
       default:
         onRegiterError("SignUp fail, please try again");
         break;

     }

  }

  //Sign in
   void SignIn(String Email, String Password, Function onSuccess, Function(String) onError)
   {
     _firebaseAuth.signInWithEmailAndPassword(email: Email, password: Password).then((value) {
       onSuccess();

     }).catchError((error){
       onError('Sign in fail, try again!');
     });
   }
   //sign out
  SignOut() async{
     return await _firebaseAuth.signOut();
  }
  Future<bool> isSignInOut() async{
     return await _firebaseAuth.currentUser()!=null;

}
Future<void> getUser()async{
     return await _firebaseAuth.currentUser();
}


}