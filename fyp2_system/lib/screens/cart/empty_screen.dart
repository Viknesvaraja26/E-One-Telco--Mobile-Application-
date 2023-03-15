import 'package:flutter/material.dart';
import 'package:fyp2_system/inner_screens/featured_sc.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';

class ECartSc extends StatelessWidget {
  const ECartSc(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.buttontext})
      : super(key: key);
  final String imagePath, title, buttontext;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: size.height * 0.4,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.purple),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                        child: Text(
                          buttontext,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
