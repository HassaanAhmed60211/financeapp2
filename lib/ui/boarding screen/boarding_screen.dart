import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:onboarding/onboarding.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  State<BoardingScreen> createState() => _MyAppState();
}

class _MyAppState extends State<BoardingScreen> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff201937)),
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/svg/onboarding_two.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/pngegg.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff201937)),
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/svg/onboarding_three.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/pngegg.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: ColorConstraint.secondaryColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 1;
            setIndex(1);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get _loginInButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: ColorConstraint.secondaryColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          Get.to(() => LoginView());
        },
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Log In',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Onboarding(
              pages: onboardingPagesList,
              onPageChange: (int pageIndex) {
                index = pageIndex;
              },
              startPageIndex: 0,
              footerBuilder: (context, dragDistance, pagesLength, setIndex) {
                return DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorConstraint.secondaryColor,
                      border: Border.all(
                        width: 0.0,
                        color: ColorConstraint.secondaryColor,
                      ),
                    ),
                    child: ColoredBox(
                      color: const Color.fromARGB(255, 104, 79, 114),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: CustomIndicator(
                                  netDragPercent: dragDistance,
                                  pagesLength: pagesLength,
                                  indicator: Indicator(
                                    indicatorDesign: IndicatorDesign.polygon(
                                      polygonDesign: PolygonDesign(
                                        polygon: DesignType.polygon_circle,
                                      ),
                                    ),
                                  )),
                            ),
                            index == pagesLength - 1
                                ? _loginInButton
                                : _skipButton(setIndex: setIndex)
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
