import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dialogs {
  static void alert(BuildContext context,
      {String title = '', String message = '', VoidCallback onOk}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            content: Text(message,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18.0,
                )),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("ok"))
            ],
          );
        });
  }

  static void confirm(BuildContext context,
      {String title = '',
      String message = '',
      VoidCallback onCancel,
      onConfirm}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            content: Text(message,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18.0,
                )),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: onCancel,
                child: Text("Cancel"),
              ),
              CupertinoDialogAction(
                  onPressed: onConfirm, child: Text("Confirm"))
            ],
          );
        });
  }
}
