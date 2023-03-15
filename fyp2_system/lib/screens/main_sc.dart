import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/screens/Home_Sc.dart';
import 'package:fyp2_system/screens/account_sc.dart';
import 'package:fyp2_system/screens/cart/cart_sc.dart';
import 'package:fyp2_system/screens/categories_sc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'package:fyp2_system/providers/dark_theme_provider.dart';

class MainSc extends StatefulWidget {
  const MainSc({Key? key}) : super(key: key);

  @override
  State<MainSc> createState() => _MainScState();
}

class _MainScState extends State<MainSc> {
  // final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    setState(() {});
    super.initState();
  }
/*  _signOut() async {
    await _firebaseAuth.signOut();

    return AuthSc();
  }*/

  int _selectedIndex = 0;
  //static const TextStyle optionStyle =
  //  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Map<String, dynamic>> _widgetOptions = [
    {'page': HomeSc(), 'title': 'One Store Telco'},
    // {'page': const MessageSc(), 'title': 'Messages'},
    {'page': const CategoriesSc(), 'title': 'Categories'},
    {'page': const CartSc(), 'title': 'Cart'},
    {'page': const AccountSc(), 'title': 'Account'},

    //HomeSc(),
    //const MessageSc(),
    //const CategoriesSc(),
    // const CartSc(),
    //const AccountSc(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      /* appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: themeState.getDarkTheme
              ? Theme.of(context).cardColor
              : Colors.purple[400],
          elevation: 0,
          centerTitle: true,
          leading: const Icon(Icons.menu),
          foregroundColor: Colors.grey.shade200,
          title: Text(_widgetOptions[_selectedIndex]['title']),
          actions: [
            IconButton(
              icon: const Icon(IconlyLight.buy),
              //  color: Colors.grey.shade400,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(IconlyBold.logout),
              //   color: Colors.grey.shade400,
              onPressed: _signOut,
            ),
          ],
        ),
      ),*/
      body: _widgetOptions[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeState.getDarkTheme
            ? Theme.of(context).cardColor
            : Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 4,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: 'Home',
            // backgroundColor: Color.fromARGB(204, 255, 255, 255),
          ),
          /*BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 1 ? IconlyBold.chat : IconlyLight.chat),
            label: 'Messages',
            // backgroundColor: Color.fromARGB(204, 255, 255, 255),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2
                ? IconlyBold.category
                : IconlyLight.category),
            label: 'Categories',
            // backgroundColor: Color.fromARGB(204, 255, 255, 255),
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: -10, end: -12),
                showBadge: true,
                ignorePointer: false,
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.purple),
                onTap: () {},
                badgeContent: FittedBox(
                  child: Text(
                    myCart.getCartItems.length.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
                badgeAnimation: badges.BadgeAnimation.rotation(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                child: Icon(_selectedIndex == 3
                    ? CupertinoIcons.cart_fill
                    : CupertinoIcons.cart),
              );
            }),
            // backgroundColor: Color.fromARGB(204, 255, 255, 255)
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 4 ? IconlyBold.profile : IconlyLight.profile),
            label: 'Account',
            // backgroundColor: Color.fromARGB(204, 255, 255, 255),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(204, 110, 2, 252),
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey[400],
        // unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }
}
