import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/inner_screens/categoryprod_sc.dart';
import 'package:fyp2_system/screens/main_sc.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/emptyprod_widget.dart';

class CategoriesSc extends StatefulWidget {
  static const routeName = "/categoriesSc";
  const CategoriesSc({Key? key}) : super(key: key);

  @override
  State<CategoriesSc> createState() => _CategoriesScState();
}

class _CategoriesScState extends State<CategoriesSc> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _categoryImage = [];
  final List _categoryName = [];

  Future<void> getCategories() async {
    return await _firestore
        .collection('Categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (this.mounted) {
          setState(() {
            _categoryName.add(doc['categoryName']);
            _categoryImage.add(doc['image']);
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
    final Color color = Utils(context).color;
    bool _isCatEmpty = false;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MainSc();
              }));
            },
            child: Icon(IconlyLight.arrowLeft2, color: color),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: Colors.black),
          title: vTextWidget(
            text: 'Categories',
            color: color,
            textSize: 24.0,
            isTitle: true,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: _isCatEmpty == true
            ? emptyprodSc(text: 'Comming Soon...\n\nPlease wait Patiently!')
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _categoryImage.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 70,
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CategoryprodSc.routeName,
                                    arguments: _categoryName[index].toString());
                              },
                              leading: Image.network(
                                _categoryImage[index],
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                              dense: true,
                              visualDensity: VisualDensity(vertical: 4),
                              title: Text(
                                _categoryName[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
