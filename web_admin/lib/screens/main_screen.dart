import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_admin/screens/Auth_Sc/login_sc.dart';
import 'package:web_admin/screens/side_bar_sc/Withdraw_sc.dart';
import 'package:web_admin/screens/side_bar_sc/categories_sc.dart';
import 'package:web_admin/screens/side_bar_sc/dashboard_sc.dart';
import 'package:web_admin/screens/side_bar_sc/orders_sc.dart';
import 'package:web_admin/screens/side_bar_sc/products_sc.dart';
import 'package:web_admin/screens/side_bar_sc/uploadbanner_sc.dart';
import 'package:web_admin/screens/side_bar_sc/users_sc.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/text_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
  static const routeName = '/mainSc';
}

class _MainScreenState extends State<MainScreen> {
  Future logOut() async {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginSc()));
    Fluttertoast.showToast(msg: "Sucessfully Logout");
  }

  final user = FirebaseAuth.instance.currentUser!;
  Widget _selectedItem = DashboardSc();

  screenSelector(item) {
    switch (item.route) {
      case DashboardSc.routeName:
        setState(() {
          _selectedItem = DashboardSc();
        });

        break;
      case Userssc.routeName:
        setState(() {
          _selectedItem = Userssc();
        });

        break;
      case WithdrawalSc.routeName:
        setState(() {
          _selectedItem = WithdrawalSc();
        });

        break;
      case OrdersSc.routeName:
        setState(() {
          _selectedItem = OrdersSc();
        });

        break;
      case CategoriesSc.routeName:
        setState(() {
          _selectedItem = CategoriesSc();
        });

        break;
      case ProductsSc.routeName:
        setState(() {
          _selectedItem = ProductsSc();
        });

        break;
      case UploadbannerSc.routeName:
        setState(() {
          _selectedItem = UploadbannerSc();
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Utils(context).getTheme;
    //final themeState = Provider.of<DarkThemeProvider>(context);
    //  final color = Utils(context).color;
    // final themeState = Provider.of<DarkThemeProvider>(context);
    // final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return SafeArea(
      child: AdminScaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          backgroundColor: Colors.purple.shade800,
          title: const Text(
            'Management',
            style: TextStyle(
                fontFamily: 'InterTight',
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
        sideBar: SideBar(
          backgroundColor: Colors.purple.shade500,
          activeBackgroundColor: Colors.black26,
          activeIconColor: Colors.black45,
          borderColor: Colors.purpleAccent,
          iconColor: Colors.white60,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          activeTextStyle: TextStyle(
            fontFamily: 'InterTight',
            color: Colors.grey[400],
            fontSize: 18,
          ),
          items: const [
            AdminMenuItem(
                title: 'Dashboard',
                icon: Icons.dashboard_rounded,
                route: DashboardSc.routeName),
            AdminMenuItem(
                title: 'Users',
                icon: CupertinoIcons.person_3,
                route: Userssc.routeName),
            /*AdminMenuItem(
                title: 'Withdrawal',
                icon: CupertinoIcons.money_dollar_circle,
                route: WithdrawalSc.routeName),*/
            AdminMenuItem(
                title: 'Orders',
                icon: CupertinoIcons.shopping_cart,
                route: OrdersSc.routeName),
            AdminMenuItem(
                title: 'Categories',
                icon: Icons.category,
                route: CategoriesSc.routeName),
            AdminMenuItem(
                title: 'Products',
                icon: Icons.shop_two_rounded,
                route: ProductsSc.routeName),
            AdminMenuItem(
                title: 'Upload Banners',
                icon: CupertinoIcons.add,
                route: UploadbannerSc.routeName),
          ],
          selectedRoute: '/',
          onSelected: (item) {
            screenSelector(item);
          },
          header: Container(
            height: 80,
            width: double.infinity,
            color: Colors.purple.shade600,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'One Store Telco Admin:\t' + user.email!,
                  style: TextStyle(
                    fontFamily: 'InterTight',
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          footer: Container(
            height: 50,
            width: double.infinity,
            color: Colors.purple.shade600,
            child: MaterialButton(
              onPressed: () {
                logOut();
              },
              color: Colors.purple.shade600,
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontFamily: 'InterTight',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          /*Container(
              height: 50,
              width: double.infinity,
              color: const Color(0xff444444),
              child: const Center(
                child: Text(
                  '@copyright of Telco Systems',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),*/
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.topLeft,
            child: _selectedItem,
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
        ),
        title: TextWidget(
          text: title,
          color: color,
        ));
  }
}
