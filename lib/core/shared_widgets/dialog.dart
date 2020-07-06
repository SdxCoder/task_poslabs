import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';

import 'button.dart';

BuildContext _context = Modular.navigatorKey.currentState.overlay.context;

Future _dialogBox({
  String title,
  Widget content,
  Widget confirmButton,
  Widget cancelButton,
}) {
  return showDialog(
      context: Modular.navigatorKey.currentState.overlay.context,
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Container(
              width: 500,
              margin: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    content,
                    SizedBox(
                      height: 20,
                    ),
                    ButtonBar(children: [ cancelButton, confirmButton]),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ));
}

Future showDialogBox({@required String title,@required String description}) {
  return _dialogBox(
      title: title,
      content: Text(
        description,
        textAlign: TextAlign.center,
      ),
      confirmButton: raisedButton(
          widget: Text("OK"),
          onPressed: () {
            Modular.to.pop();
          }));
}
