import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/widgets/users_widget.dart';

import '../../consts/constants.dart';

class Userssc extends StatelessWidget {
  static const String routeName = '\UsersSc';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Users',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            //there was a null error just add those lines
            stream: FirebaseFirestore.instance
                .collection('ShopUsers')
                .orderBy('createdAt', descending: true)
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              usersWidget(
                                addressLine1: snapshot.data!.docs[index]
                                    ['address Line1'],
                                addressLine2: snapshot.data!.docs[index]
                                    ['address Line2'],
                                city: snapshot.data!.docs[index]['city'],
                                createdAt: snapshot.data!.docs[index]
                                    ['createdAt'],
                                email: snapshot.data!.docs[index]['email'],
                                id: snapshot.data!.docs[index]['id'],
                                name: snapshot.data!.docs[index]['name'],
                                profilePic: snapshot.data!.docs[index]
                                    ['profilePic'],
                                state: snapshot.data!.docs[index]['state'],
                                zipcode: snapshot.data!.docs[index]['zipcode'],
                              ),
                              const Divider(
                                thickness: 3,
                              ),
                            ],
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('No Orders!'),
                    ),
                  );
                }
              }
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
