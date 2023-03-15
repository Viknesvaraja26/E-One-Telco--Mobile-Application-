import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/responsive.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/banner_widget.dart';

class UploadbannerSc extends StatefulWidget {
  static const String routeName = '\UploadbannerSc';

  @override
  State<UploadbannerSc> createState() => _UploadbannerScState();
}

class _UploadbannerScState extends State<UploadbannerSc> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* dynamic _image;

  String? fileName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;

        fileName = result.files.first.name;
      });
    }
  }*/

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

  _UploadbannerSToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('Banners').child(fileName!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  uploadToFireStore() async {
    EasyLoading.show();
    if (_image != null) {
      String imageUrl = await _UploadbannerSToStorage(_image);

      await _firestore.collection('Banners').doc(fileName).set({
        'image': imageUrl,
      }).whenComplete(() {
        EasyLoading.showSuccess('Upload Complete!');
        EasyLoading.dismiss();
        setState(() {
          _image = null;
        });
      });
    } else {
      EasyLoading.showError('Upload Fail!');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Banners',
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
                              child: Text('Uploaded Banner'),
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
                        uploadToFireStore();
                      },
                      label: Text(
                        'Save Image',
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
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Uploaded Banners \n",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Responsive(
            mobile: BannerWidget(
              crossAxisCount: size.width < 650 ? 2 : 3,
              childAspectRatio:
                  size.width < 650 && size.width > 350 ? 1.1 : 0.8,
            ),
            desktop: BannerWidget(
              childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
            ),
          ),
        ],
      ),
    );
  }
}
