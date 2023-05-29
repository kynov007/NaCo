import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_sampah/app_color.dart';
import 'package:project_sampah/custom_widget.dart';
import 'package:project_sampah/utility.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constant.dart';
import '../routes.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final pageIntroController = PageController();
  bool showOkButton = false;

  @override
  void dispose() {
    pageIntroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          child: Stack(children: [
            PageView(
              onPageChanged: (currentIndex) {
                setState(() {
                  showOkButton = currentIndex == 2;
                });
              },
              controller: pageIntroController,
              children: [
                buildScreen(
                    imgLocation: 'assets/tanah.json',
                    teks: 'Buanglah Sampah Pada Tempatnya'),
                buildScreen(
                    imgLocation: 'assets/mobile.json',
                    teks: 'Dirancang untuk mobile'),
                buildScreen(
                    imgLocation: 'assets/bumi.json', teks: 'Jaga Bumi kita')
              ],
            ),

            /// ********************* dot indicator ********************** ///
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 100),
                height: double.maxFinite,
                // decoration: BoxDecoration(
                // border: Border.all(color: Colors.red)
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SmoothPageIndicator(
                      count: 3,
                      controller: pageIntroController,
                      effect: const WormEffect(spacing: 20),
                    ),
                  ],
                ),
              ),
            ),

            /// ********************* OK button ********************** ///
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 30),
                height: double.maxFinite,
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.red)
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: showOkButton,
                          child: TextButton(
                              onPressed: () {
                                Utility.isShowIntro = false;
                                Utility.preferences
                                    .setBool(Constant.isShowIntroKey, false);
                                Navigator.pushNamed(context, Routes.routeHome);
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              )),
                        ),
                        const SizedBox(
                          width: 50,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  buildScreen({required String imgLocation, String? teks}) {
    return Container(
      padding: EdgeInsets.all(15),
      color: lightBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LottieBuilder.asset(imgLocation),
          CustomWidget.customText(
            teks: teks ?? 'unset',
            color: blackColor,
          ),
        ],
      ),
    );
  }
}
