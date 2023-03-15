import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';
import 'package:web_admin/widgets/category_widget.dart';

class CategoriesSc extends StatefulWidget {
  static const String routeName = '\CategoriesSc';

  @override
  State<CategoriesSc> createState() => _CategoriesScState();
}

class _CategoriesScState extends State<CategoriesSc> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String categoryName;

  Uint8List? _image;

  String? fileName;

  _pickImage() async {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    await input.onChange.first;

    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file);

    await reader.onLoad.first;

    final encoded = reader.result as String;
    final stripped =
        encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final bytes = base64.decode(stripped);
    final uint8list = Uint8List.fromList(bytes);

    setState(() {
      _image = uint8list;
      fileName = file.name;
    });
  }

  _uploadCategoryBannerToStorage(image) async {
    Reference ref = _storage.ref().child('CategoryImages').child(fileName!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  uploadCategory() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      String imageURL = await _uploadCategoryBannerToStorage(_image);

      final _uuid = const Uuid().v4();

      await _firestore.collection('Categories').doc(_uuid).set({
        'id': _uuid,
        'image': imageURL,
        'categoryName': categoryName,
      }).whenComplete(() {
        EasyLoading.showSuccess('Upload Complete!');
        EasyLoading.dismiss();
        setState(() {
          _image = null;
          _formKey.currentState!.reset();
        });
      });
    } else {
      EasyLoading.showError('Upload Failed!');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 180,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          border: Border.all(color: Colors.grey.shade800),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54, //New
                                blurRadius: 6.0,
                                offset: Offset(0, 0)),
                          ],
                        ),
                        child: _image != null
                            ? Image.memory(
                                _image!,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text('Uploaded Image'),
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 270,
                        child: TextFormField(
                          onChanged: (value) {
                            categoryName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Category name must not be empty! ';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter the name of your Category here :',
                            hintText: 'Input Category Name',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        icon: Icon(CupertinoIcons.cloud_upload),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(20),
                          elevation: 15,
                          shadowColor: Colors.purple.shade600,
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        label: Text(
                          'Upload Image',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        icon: Icon(CupertinoIcons.floppy_disk),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(20),
                          elevation: 15,
                          shadowColor: Colors.purple.shade600,
                        ),
                        onPressed: () {
                          uploadCategory();
                        },
                        label: Text(
                          'Save Category',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Uploaded Categories \n',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
