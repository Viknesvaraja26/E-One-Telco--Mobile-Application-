import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/inner_screens/categoryprod_sc.dart';

class CategoryText extends StatefulWidget {
  CategoryText({
    super.key,
    required bool isDark,
  }) : _isDark = isDark;

  final bool _isDark;

  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _categoryName = [];

  getCategories() {
    return _firestore
        .collection('Categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (this.mounted) {
          setState(() {
            _categoryName.add(doc['categoryName']);
          });
        }
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
    bool isemptyList = false;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          const Text(
            '\tTags',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            child: Row(
              children: [
                Expanded(
                  child: isemptyList == true
                      ? ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No Tags available, Comming Soon.. Please be Patient',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _categoryName.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                child: ActionChip(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, CategoryprodSc.routeName,
                                          arguments:
                                              _categoryName[index].toString());
                                    },
                                    backgroundColor: widget._isDark
                                        ? Colors.purple.shade900
                                        : Colors.purple.shade500,
                                    label: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 6),
                                        child: Text(
                                          _categoryName[index].toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.arrowRight2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
