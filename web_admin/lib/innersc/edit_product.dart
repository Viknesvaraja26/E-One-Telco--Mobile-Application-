import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:web_admin/services/global_method.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/addprod_header.dart';
import 'package:web_admin/widgets/buttons.dart';
import 'package:web_admin/widgets/text_widget.dart';

class editProducts extends StatefulWidget {
  //static const routeName = '/editProducts';
  editProducts({
    Key? key,
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.discountedPrice,
    required this.productCat,
    required this.isDiscounted,
    required this.description,
  }) : super(key: key);

  final String id, title, price, description, productCat, stock;

  final bool isDiscounted;
  final double discountedPrice;

  @override
  _editProductsState createState() => _editProductsState();
}

class _editProductsState extends State<editProducts> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var _categoryName;
  var setDefaultCategory = false;
  late double _discountPrice;
  late bool _isDiscounted;
  String? _discountPercent;
  late String percToShow;

  String? fileName;

  late final TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _stockController;

  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _stockController = TextEditingController(text: widget.stock);
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    // Set the variables
    _discountPrice = widget.discountedPrice;
    _categoryName = widget.productCat;
    _isDiscounted = widget.isDiscounted;
    // Calculate the percentage
    percToShow = (100 -
                (_discountPrice * 100) /
                    double.parse(
                        widget.price)) // WIll be the price instead of 1.88
            .round()
            .toStringAsFixed(1) +
        '%';
    super.initState();
  }

  @override
  void dispose() {
    _stockController.dispose();
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          EasyLoading.show();
        });
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': _titleController.text,
          'stock': _stockController.text,
          'price': _priceController.text,
          'discountPrice': _discountPrice,
          'productCategoryName': _categoryName,
          'productDescription': _descriptionController.text,
          'isDiscounted': _isDiscounted,
          'createdAt': Timestamp.now(),
        });
        await EasyLoading.showSuccess('Product has been updated');
        EasyLoading.dismiss();
        Navigator.pop(context);
        await Fluttertoast.showToast(
          msg: "Product has been updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}',
            context: context,
            vicon: Icon(Icons.error_outline));
        setState(() {
          EasyLoading.dismiss();
        });
      } catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '$error',
            context: context,
            vicon: Icon(Icons.error_outline));
        setState(() {
          EasyLoading.dismiss();
        });
      } finally {
        setState(() {
          EasyLoading.dismiss();
        });
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
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _isDiscounted,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isDiscounted = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text: 'Discounted',
                                color: color,
                                isTitle: true,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            child: !_isDiscounted
                                ? Container()
                                : Row(
                                    children: [
                                      TextWidget(
                                          text: "\RM " +
                                              _discountPrice.toStringAsFixed(2),
                                          color: color),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      discountPercentageDropDownWidget(color),
                                    ],
                                  ),
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
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonsWidget(
                                  onPressed: () async {
                                    GlobalMethods.warningDialog(
                                        title: 'Delete?',
                                        subtitle: 'Press okay to confirm',
                                        fct: () async {
                                          await EasyLoading.show();
                                          await FirebaseFirestore.instance
                                              .collection('products')
                                              .doc(widget.id)
                                              .delete();
                                          await EasyLoading.showSuccess(
                                              'Product Deleted Succesfully');
                                          await EasyLoading.dismiss();
                                          await Fluttertoast.showToast(
                                            msg: "Product has been deleted",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                          );
                                          while (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        context: context);
                                  },
                                  text: 'Delete',
                                  icon: IconlyBold.delete,
                                  backgroundColor: Colors.red.shade300,
                                ),
                                ButtonsWidget(
                                  onPressed: () {
                                    _updateProduct();
                                  },
                                  text: 'Update',
                                  icon: IconlyBold.setting,
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
            //debugPrint('setDefaultCategory: $_categoryName');
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
                  debugPrint('Selected Category: $value');
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

  DropdownButtonHideUnderline discountPercentageDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text('10%'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('15%'),
            value: '15',
          ),
          DropdownMenuItem<String>(
            child: Text('25%'),
            value: '25',
          ),
          DropdownMenuItem<String>(
            child: Text('50%'),
            value: '50',
          ),
          DropdownMenuItem<String>(
            child: Text('75%'),
            value: '75',
          ),
          DropdownMenuItem<String>(
            child: Text('0%'),
            value: '0',
          ),
        ],
        onChanged: (value) {
          if (value == '0') {
            return;
          } else {
            setState(() {
              _discountPercent = value;
              _discountPrice = double.parse(widget.price) -
                  (double.parse(value!) * double.parse(widget.price) / 100);
            });
          }
        },
        hint: Text(_discountPercent ?? percToShow),
        value: _discountPercent,
      ),
    );
  }
}
