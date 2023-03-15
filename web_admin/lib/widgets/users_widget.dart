import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_admin/services/utils.dart';

import 'text_widget.dart';

class usersWidget extends StatefulWidget {
  usersWidget(
      {Key? key,
      required this.addressLine1,
      required this.addressLine2,
      required this.city,
      required this.createdAt,
      required this.email,
      required this.id,
      required this.name,
      required this.profilePic,
      required this.state,
      required this.zipcode})
      : super(key: key);

  final String addressLine1,
      addressLine2,
      city,
      email,
      id,
      name,
      state,
      zipcode;
  final String profilePic;
  final Timestamp createdAt;

  @override
  _usersWidgetState createState() => _usersWidgetState();
}

class _usersWidgetState extends State<usersWidget> {
  // String token = "";

//  @override
  // void initState() {

  //   super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).cardColor.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: size.width < 650 ? 3 : 2,
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    // ignore: unnecessary_null_comparison
                    child: widget.profilePic == null
                        ? Image(
                            width: size.height * 20,
                            height: size.width * 0.17,
                            fit: BoxFit.fill,
                            image:
                                AssetImage('lib/assets/images/error_image.png'),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FancyShimmerImage(
                              width: size.height * 20,
                              height: size.width * 0.17,
                              imageUrl: widget.profilePic,
                              boxFit: BoxFit.fill,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: '\t${widget.email}',
                            color: Colors.blue,
                            textSize: 26,
                            isTitle: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: '\t${widget.name}',
                            color: Colors.black,
                            textSize: 26,
                            isTitle: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: '\t\t${widget.addressLine1},',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: '\t\t${widget.addressLine2},',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: '\t\t${widget.zipcode}\t${widget.city},',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: '\t\t${widget.state}.',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Future.delayed(
                              Duration(seconds: 0),
                              () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Row(children: [
                                        Icon(Icons.warning_amber_sharp),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text('Clear user Data?'),
                                      ]),
                                      content: Text('Press okay to confirm'),
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
                                          onPressed: () async {
                                            await EasyLoading.show();
                                            deleteUserdata();
                                            await EasyLoading.showSuccess(
                                                'Successfully Deleted');
                                            await EasyLoading.dismiss();
                                            await Fluttertoast.showToast(
                                              msg: "User has been deleted",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                            );
                                            //while (Navigator.canPop(
                                            // context)) {
                                            Navigator.pop(context);
                                            // }
                                          },
                                          child: TextWidget(
                                            color: Colors.red,
                                            text: 'Delete',
                                            textSize: 18,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          },
                          child: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ],
            ),
          ),
        ));
  }

  void deleteUserdata() async {
    final CollectionReference userCollection =
        await FirebaseFirestore.instance.collection('ShopUsers');

    await userCollection.doc(widget.id).delete();

    // FirebaseFirestore.instance.collection('ShopUsers').doc(widget.id).delete();
  }
}
