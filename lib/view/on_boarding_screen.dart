import 'package:dima2022/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/routes.dart';
import '../utils/size_config.dart';
import './custom_theme.dart';

class OnBoarding extends StatefulWidget {
  static const routeName = '/on_boarding';

  const OnBoarding({Key? key}) : super(key: key);

  @override
  OnBoardingState createState() => OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  late int index;

  List<PageModel> get onBoardingPagesList {
    return [
      PageModel(
        widget: Flexible(
          child: Container(
            color: CustomTheme.backgroundColor,
            child: Center(
              child: Column(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Image(
                        image: AssetImage('assets/images/onboarding3.png')),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(
                                      CustomTheme.bigPadding)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Search or scan a product',
                                  style: CustomTheme.headingStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(
                                    CustomTheme.bigPadding),
                                vertical: getProportionateScreenHeight(
                                    CustomTheme.bigPadding),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Use the QR Code scanner or search your favorite product in the list to add it into your cart.',
                                  style: CustomTheme.bodyStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            )
                          ])),
                ],
              ),
            ),
          ),
        ),
      ),
      PageModel(
        widget: Flexible(
          child: Container(
            color: CustomTheme.backgroundColor,
            child: Center(
              child: Column(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Image(
                        image: AssetImage('assets/images/onboarding1.png')),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(
                                      CustomTheme.bigPadding)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Seamless shopping experience',
                                  style: CustomTheme.headingStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(
                                    CustomTheme.bigPadding),
                                vertical: getProportionateScreenHeight(
                                    CustomTheme.bigPadding),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Checkout directly from the app to skip the queue at the counter, receive the product home or pickup in store.',
                                  style: CustomTheme.bodyStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            )
                          ])),
                ],
              ),
            ),
          ),
        ),
      ),
      PageModel(
        widget: Flexible(
          child: Container(
            color: CustomTheme.backgroundColor,
            child: Center(
              child: Column(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Image(
                        image: AssetImage('assets/images/onboarding2.png')),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(
                                      CustomTheme.bigPadding)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Easy try on',
                                  style: CustomTheme.headingStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(
                                    CustomTheme.bigPadding),
                                vertical: getProportionateScreenHeight(
                                    CustomTheme.bigPadding),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Communicate with the shopping assistant while trying on your clothes in the dressing room and ask them to bring you a different size!',
                                  style: CustomTheme.bodyStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            )
                          ])),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  ElevatedButton _skipButton({void Function(int)? setIndex}) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleOutline,
      onPressed: () {
        if (setIndex != null) {
          index = 2;
          setIndex(2);
        }
      },
      child: const Text('Skip'),
    );
  }

  ElevatedButton _nextButton({void Function(int)? setIndex}) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleFill,
      onPressed: () {
        if (setIndex != null) {
          setIndex(++index);
        }
      },
      child: const Text('Next'),
    );
  }

  ElevatedButton get _signupButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleFill,
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('onboarding_seen', true);
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      },
      child: const Text('Homepage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Onboarding(
        pages: onBoardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return Padding(
            padding: EdgeInsets.all(
                getProportionateScreenWidth(CustomTheme.spacePadding)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(
                          CustomTheme.smallPadding),
                      right: getProportionateScreenWidth(
                          context.layout.breakpoint < LayoutBreakpoint.md
                              ? CustomTheme.bigPadding
                              : CustomTheme.smallPadding)),
                  child: CustomIndicator(
                    netDragPercent: dragDistance,
                    pagesLength: pagesLength,
                    indicator: Indicator(
                      closedIndicator:
                          ClosedIndicator(color: CustomTheme.secondaryColor),
                      indicatorDesign: IndicatorDesign.polygon(
                        polygonDesign: PolygonDesign(
                          polygon: DesignType.polygon_circle,
                        ),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(getProportionateScreenWidth(
                              CustomTheme.spacePadding)),
                          child: index != pagesLength - 1
                              ? _skipButton(setIndex: setIndex)
                              : const SizedBox(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(getProportionateScreenWidth(
                              CustomTheme.spacePadding)),
                          child: index != pagesLength - 1
                              ? _nextButton(setIndex: setIndex)
                              : _signupButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
