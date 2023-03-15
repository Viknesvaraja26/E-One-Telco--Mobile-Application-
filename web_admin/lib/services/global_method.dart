import 'package:flutter/material.dart';
import 'package:web_admin/widgets/text_widget.dart';
import 'package:web_admin/widgets/vtext_widget.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Icon(Icons.warning_amber_sharp),
              const SizedBox(
                width: 2,
              ),
              Text(title),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Cancel',
                  textSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                },
                child: TextWidget(
                  color: Colors.red,
                  text: 'OK',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              vicon,
              SizedBox(
                width: 8,
              ),
              Text('An Error Occured'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: vTextWidget(
                    text: "Ok",
                    color: Colors.white,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        });
  }
}
