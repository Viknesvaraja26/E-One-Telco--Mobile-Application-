import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/text_widget.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection('Categories').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.grey),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            mainAxisExtent: 300.0,
          ),
          itemBuilder: (context, index) {
            final categoryData = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                          Duration(seconds: 0),
                                          () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Row(children: [
                                                    Icon(Icons
                                                        .warning_amber_sharp),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text('Delete?'),
                                                  ]),
                                                  content: Text(
                                                      'Press okay to confirm'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        if (Navigator.canPop(
                                                            context)) {
                                                          Navigator.pop(
                                                              context);
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
                                                        await EasyLoading
                                                            .show();
                                                        await FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (Transaction
                                                                    myTransaction) async {
                                                          await myTransaction
                                                              .delete(snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .reference);
                                                        });
                                                        await EasyLoading
                                                            .showSuccess(
                                                                'Successfully Deleted');
                                                        await EasyLoading
                                                            .dismiss();
                                                        await Fluttertoast
                                                            .showToast(
                                                          msg:
                                                              "Category has been deleted",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
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
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      value: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // flex: 2,
                                  // height: 100,
                                  // width: 100,
                                  Image.network(
                                    categoryData['image'],
                                    fit: BoxFit.fill,
                                    height: size.width * 0.08,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Column(
                          children: [
                            Text(
                              categoryData['categoryName'],
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
