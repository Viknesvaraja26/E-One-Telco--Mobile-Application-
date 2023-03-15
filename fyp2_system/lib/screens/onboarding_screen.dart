import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2_system/fetch_data.dart';
import 'package:fyp2_system/auth/login_sc.dart';
import 'package:get_storage/get_storage.dart';

// ignore: camel_case_types
class onboardSc extends StatefulWidget {
  const onboardSc({Key? key}) : super(key: key);

  @override
  State<onboardSc> createState() => _onboardScState();
}

// ignore: camel_case_types
class _onboardScState extends State<onboardSc> {
  final controller = PageController();
  double scrollerPoint = 0;
  final save = GetStorage();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  onButtonPressed(context) {
    save.write('onboarding', true);
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return fetchSc();
    }));

    //wont show splash screen second time and direct launch app
    //will auto saved in device
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]); //stop landscape mode

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (val) {
              setState(() {
                scrollerPoint = val.toDouble();
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: FittedBox(
                  child: OnboardPage(
                    bdColumn: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('lib/assets/images/1.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: FittedBox(
                  child: OnboardPage(
                    bdColumn: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('lib/assets/images/2.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: FittedBox(
                  child: OnboardPage(
                    bdColumn: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('lib/assets/images/3.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: FittedBox(
                  child: OnboardPage(
                    bdColumn: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('lib/assets/images/4.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DotsIndicator(
                    dotsCount: 4,
                    position: scrollerPoint,
                    decorator: const DotsDecorator(
                        activeColor: Color.fromARGB(255, 224, 50, 255)),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                scrollerPoint == 3
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 1),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 164, 54, 255))),
                          child: const Text(
                            'Lets Go!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            onButtonPressed(context);
                            //log out put in
                            //final prefs = await SharedPreferences.getInstance();
                            //prefs.setBool('showHome', false);
                            // Navigator.of(context).pushReplacement(
                            // MaterialPageRoute(builder: (context) => onboardSc()
                            //)
                            //  )
                          },
                        ),
                      )
                    : Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          child: const Text(
                            'SKIP >',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () => controller.jumpToPage(3),
                        ),
                      ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Registered?',
                        style: TextStyle(
                            color: Color.fromARGB(155, 255, 255, 255)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginSc();
                          }));
                          ;
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(32, 32),
                            alignment: Alignment.center),
                        child: const Text(
                          ' Login here!!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 52,
                  width: 5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final Column? bdColumn;
  const OnboardPage({Key? key, this.bdColumn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: const Color.fromARGB(255, 155, 57, 247),
            child: Center(child: bdColumn)),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            // width: MediaQuery.of(context).size.width,
            height: 90,
            width: 160,
            decoration: const BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(48),
                topRight: Radius.circular(2),
              ),
            ),
          ),
        )
      ],
    );
  }
}
