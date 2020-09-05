import 'package:flutter/material.dart';
class loadingDialog{
  static void showLoadingDialog(BuildContext context,String msg)
  {
    showDialog(context: context,barrierDismissible: false,//ko cho an dialog
        builder: (context)=> new Dialog(
          child: Container(
            color: Colors.white,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    msg,style: TextStyle(
                    fontSize: 18,

                  ),
                  ),
                )
              ],
            ),
          ),
        ) );
  }
  static void hideDialog(BuildContext context){
    Navigator.of(context).pop(loadingDialog);
  }
}