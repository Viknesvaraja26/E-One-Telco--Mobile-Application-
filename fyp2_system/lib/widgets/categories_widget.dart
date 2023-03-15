import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class categoriesWidget extends StatefulWidget {
  const categoriesWidget({super.key});

  @override
  State<categoriesWidget> createState() => _categoriesWidgetState();
}

class _categoriesWidgetState extends State<categoriesWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _categoryImage = [];

  getCategories() {
    return _firestore
        .collection('Categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categoryImage.add(doc['image']);
        });
      });
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withOpacity(0.7),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: _screenWidth * 0.3,
            width: _screenWidth * 0.3,
            child: FutureBuilder<QuerySnapshot>(
              future: getCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  Fluttertoast.showToast(
                      msg: '${snapshot.error}',
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitChasingDots(color: Colors.purple);
                }

                return Container(
                  height: 200,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Categories'),
                          Text('See all'),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
