import 'dart:convert';
//import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:uuid/uuid.dart';
import 'package:web_admin/services/global_method.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/addprod_header.dart';
import 'package:web_admin/widgets/buttons.dart';
import 'package:web_admin/widgets/text_widget.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var _categoryName;
  var setDefaultCategory = true;

  Uint8List? _image;

  String? fileName;

  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      fileName = DateTime.now().millisecond.toString() + file.name;
    });
  }

  _uploadImageToStorage(image) async {
    Reference ref = _storage.ref().child('productImages').child(fileName!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Uint8List? _image2;

  String? fileName2;

  final FirebaseStorage _storage2 = FirebaseStorage.instance;

  _pickImage2() async {
    final input2 = html.FileUploadInputElement();
    input2.accept = 'image/*';
    input2.click();

    await input2.onChange.first;

    final file2 = input2.files!.first;
    final reader2 = html.FileReader();
    reader2.readAsDataUrl(file2);

    await reader2.onLoad.first;

    final encoded2 = reader2.result as String;
    final stripped2 =
        encoded2.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final bytes2 = base64.decode(stripped2);
    final uint8list2 = Uint8List.fromList(bytes2);

    setState(() {
      _image2 = uint8list2;
      fileName2 = DateTime.now().millisecond.toString() + file2.name;
    });
  }

  _uploadImage2ToStorage(image2) async {
    Reference ref2 = _storage2.ref().child('productImages').child(fileName2!);

    UploadTask uploadTask2 = ref2.putData(image2);

    TaskSnapshot snapshot2 = await uploadTask2;
    String downloadURL2 = await snapshot2.ref.getDownloadURL();

    return downloadURL2;
  }

  Uint8List? _image3;

  String? fileName3;

  final FirebaseStorage _storage3 = FirebaseStorage.instance;

  _pickImage3() async {
    final input3 = html.FileUploadInputElement();
    input3.accept = 'image/*';
    input3.click();

    await input3.onChange.first;

    final file3 = input3.files!.first;
    final reader3 = html.FileReader();
    reader3.readAsDataUrl(file3);

    await reader3.onLoad.first;

    final encoded3 = reader3.result as String;
    final stripped3 =
        encoded3.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final bytes3 = base64.decode(stripped3);
    final uint8list3 = Uint8List.fromList(bytes3);

    setState(() {
      _image3 = uint8list3;
      fileName3 = DateTime.now().millisecond.toString() + file3.name;
    });
  }

  _uploadImage3ToStorage(image3) async {
    Reference ref3 = _storage3.ref().child('productImages').child(fileName3!);

    UploadTask uploadTask3 = ref3.putData(image3);

    TaskSnapshot snapshot3 = await uploadTask3;
    String downloadURL3 = await snapshot3.ref.getDownloadURL();

    return downloadURL3;
  }

  Uint8List? _image4;

  String? fileName4;

  final FirebaseStorage _storage4 = FirebaseStorage.instance;

  _pickImage4() async {
    final input4 = html.FileUploadInputElement();
    input4.accept = 'image/*';
    input4.click();

    await input4.onChange.first;

    final file4 = input4.files!.first;
    final reader4 = html.FileReader();
    reader4.readAsDataUrl(file4);

    await reader4.onLoad.first;

    final encoded4 = reader4.result as String;
    final stripped4 =
        encoded4.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final bytes4 = base64.decode(stripped4);
    final uint8list4 = Uint8List.fromList(bytes4);

    setState(() {
      _image4 = uint8list4;
      fileName4 = DateTime.now().millisecond.toString() + file4.name;
    });
  }

  _uploadImage4ToStorage(image4) async {
    Reference ref4 = _storage4.ref().child('productImages').child(fileName4!);

    UploadTask uploadTask4 = ref4.putData(image4);

    TaskSnapshot snapshot4 = await uploadTask4;
    String downloadURL4 = await snapshot4.ref.getDownloadURL();

    return downloadURL4;
  }

  late final TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _stockController;

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _stockController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _priceController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _stockController.clear();
    setState(() {
      _image = null;

      _image2 = null;

      _image3 = null;

      _image4 = null;
    });
  }

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_image == null &&
        _image2 == null &&
        _image3 == null &&
        _image4 == null) {
      GlobalMethods.errorDialog(
          subtitle: 'Please Upload the images',
          vicon: Icon(Icons.warning_amber_sharp),
          context: context);
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: SpinKitFadingFour(color: Colors.black),
          );
        },
      );
      final _uuid = const Uuid().v4();
      EasyLoading.show();
      try {
        String imageURL = await _uploadImageToStorage(_image);
        String imageURL2 = await _uploadImage2ToStorage(_image2);
        String imageURL3 = await _uploadImage3ToStorage(_image3);
        String imageURL4 = await _uploadImage4ToStorage(_image4);
        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'title': _titleController.text,
          'price': _priceController.text,
          'discountPrice': 0.1,
          'imageUrl': [imageURL, imageURL2, imageURL3, imageURL4],
          'productCategoryName': _categoryName,
          'productDescription': _descriptionController.text,
          'stock': _stockController.text,
          'isDiscounted': false,
          'createdAt': Timestamp.now(),
        });
        _clearForm();
        EasyLoading.showSuccess('Successfully Uploaded!');
        EasyLoading.dismiss();
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Navigator.pop(context);
        EasyLoading.dismiss();
        GlobalMethods.errorDialog(
            subtitle: '${e.message}',
            vicon: Icon(Icons.warning_amber_sharp),
            context: context);
      } catch (e) {
        Navigator.pop(context);
        EasyLoading.dismiss();
        GlobalMethods.errorDialog(
            subtitle: '${e}',
            vicon: Icon(Icons.warning_amber_sharp),
            context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  addproductsHeader(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ButtonsWidget(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icons.arrow_back_outlined,
                          text: 'Return',
                          backgroundColor: Colors.purple,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: size.width > 650 ? 650 : size.width,
                    color: Colors.white.withOpacity(0.5),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 350,
                                        child: TextWidget(
                                          text: 'Product title*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 350,
                                        child: TextFormField(
                                          controller: _titleController,
                                          key: const ValueKey('Title'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a Title';
                                            }
                                            return null;
                                          },
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: 'Stock*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: _stockController,
                                          key: const ValueKey('Stock*'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Stock is missed';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]')),
                                          ],
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      TextWidget(
                                        text: 'Price in RM*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: _priceController,
                                          key: const ValueKey('Price RM*'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missed';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]')),
                                          ],
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextWidget(
                                        text: 'Porduct category*',
                                        color: color,
                                        isTitle: true,
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: _categoryDropDown(),
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 22,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Image to be picked code is here
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: size.width > 650
                                        ? 350
                                        : size.width * 0.45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54, //New
                                            blurRadius: 6.0,
                                            offset: Offset(0, 0)),
                                      ],
                                    ),
                                    child: _image == null
                                        ? _chooseImage(color: color)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.memory(
                                              _image!,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _image = null;
                                          });
                                        },
                                        child: TextWidget(
                                          text: 'Clear',
                                          textSize: 30,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _pickImage();
                                        },
                                        child: TextWidget(
                                          text: 'Update image',
                                          textSize: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Image to be picked code is here
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: size.width > 650
                                        ? 350
                                        : size.width * 0.45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54, //New
                                            blurRadius: 6.0,
                                            offset: Offset(0, 0)),
                                      ],
                                    ),
                                    child: _image2 == null
                                        ? _chooseImage2(color: color)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.memory(
                                              _image2!,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _image2 = null;
                                          });
                                        },
                                        child: TextWidget(
                                          text: 'Clear',
                                          textSize: 30,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _pickImage2();
                                        },
                                        child: TextWidget(
                                          text: 'Update image',
                                          textSize: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Image to be picked code is here
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: size.width > 650
                                        ? 350
                                        : size.width * 0.45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54, //New
                                            blurRadius: 6.0,
                                            offset: Offset(0, 0)),
                                      ],
                                    ),
                                    child: _image3 == null
                                        ? _chooseImage3(color: color)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.memory(
                                              _image3!,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _image3 = null;
                                          });
                                        },
                                        child: TextWidget(
                                          text: 'Clear',
                                          textSize: 30,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _pickImage3();
                                        },
                                        child: TextWidget(
                                          text: 'Update image',
                                          textSize: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Image to be picked code is here
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: size.width > 650
                                        ? 350
                                        : size.width * 0.45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54, //New
                                            blurRadius: 6.0,
                                            offset: Offset(0, 0)),
                                      ],
                                    ),
                                    child: _image4 == null
                                        ? _chooseImage4(color: color)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.memory(
                                              _image4!,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _image4 = null;
                                          });
                                        },
                                        child: TextWidget(
                                          text: 'Clear',
                                          textSize: 30,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _pickImage4();
                                        },
                                        child: TextWidget(
                                          text: 'Update image',
                                          textSize: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        TextWidget(
                                          text: 'Products Description*',
                                          color: color,
                                          isTitle: true,
                                          textSize: 8,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            textAlign: TextAlign.left,
                                            maxLines: 10,
                                            maxLength: 800,
                                            style: TextStyle(
                                              fontSize: 5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            controller: _descriptionController,
                                            key: const ValueKey('Description'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter the product description';
                                              }
                                              return null;
                                            },
                                            decoration: inputDecoration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: _attributes()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonsWidget(
                                  onPressed: () {
                                    _clearForm();
                                  },
                                  text: 'Clear form',
                                  icon: IconlyBold.danger,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  onPressed: () {
                                    _uploadForm();
                                  },
                                  text: 'Upload',
                                  icon: IconlyBold.upload,
                                  backgroundColor: Colors.blue,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryDropDown() {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Categories')
            .orderBy('categoryName')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();

          if (setDefaultCategory) {
            _categoryName = snapshot.data!.docs[0].get('categoryName');
          }
          return DropdownButton(
            isExpanded: false,
            value: _categoryName,
            items: snapshot.data!.docs.map((value) {
              return DropdownMenuItem(
                value: value.get('categoryName'),
                child: Text(
                  '${value.get('categoryName')}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(
                () {
                  // debugPrint('Selected Category: $value');
                  // Selected value will be stored
                  _categoryName = value;
                  // Default dropdown value won't be displayed anymore
                  setDefaultCategory = false;
                },
              );
            },
          );
        },
      ),
    );
  }

  /* Widget _categoryDropDown() {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton
        <String>(
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
          },
          hint: Text('Select a category'),
          items: [
            DropdownMenuItem(
              child: Text('Assesories'),
              value: 'Assesories',
            ),
            DropdownMenuItem(
              child: Text('Powerbank'),
              value: 'Powerbank',
            ),
            DropdownMenuItem(
              child: Text('Others'),
              value: 'Others',
            ),
          ],
        ),
      ),
    );
  }  */

  Widget _chooseImage({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 100,
            ),
            SizedBox(
              height: 2,
            ),
            TextButton(
              onPressed: () {
                _pickImage();
              },
              child: TextWidget(
                text: 'Choose an image',
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseImage2({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 100,
            ),
            SizedBox(
              height: 2,
            ),
            TextButton(
              onPressed: () {
                _pickImage2();
              },
              child: TextWidget(
                text: 'Choose an image',
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseImage3({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 100,
            ),
            SizedBox(
              height: 2,
            ),
            TextButton(
              onPressed: () {
                _pickImage3();
              },
              child: TextWidget(
                text: 'Choose an image',
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseImage4({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 100,
            ),
            SizedBox(
              height: 2,
            ),
            TextButton(
              onPressed: () {
                _pickImage4();
              },
              child: TextWidget(
                text: 'Choose an image',
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
