import 'package:dima2022/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import './custom_theme.dart';

class OnBoarding extends StatefulWidget {
  static const routeName = '/on_boarding';
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late int index;

  final onBoardingPagesList = [
    PageModel(
      widget: Flexible(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: CustomTheme.bigPadding,
                    vertical: CustomTheme.bigPadding,
                  ),
                  child: const Image(image: AssetImage('assets/images/onboarding3.png')),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CustomTheme.bigPadding),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'FIRST PAGE',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CustomTheme.bigPadding, vertical: CustomTheme.spacePadding),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'First page description',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PageModel(
      widget: Flexible(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 45.0,
                    vertical: 90.0,
                  ),
                  child: Image(image: AssetImage('assets/images/onboarding1.png')),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SECOND PAGE',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Second page description',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PageModel(
      widget: Flexible(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45.0,
                    vertical: 90.0,
                  ),
                  child: Image.asset('assets/images/onboarding2.png'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'THIRD PAGE',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Third page description',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ];

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
      onPressed: () =>
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName),
      child: const Text('Homepage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Onboarding(
            pages: onBoardingPagesList,
            onPageChange: (int pageIndex) {
              index = pageIndex;
            },
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return Padding(
                padding: EdgeInsets.all(CustomTheme.spacePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: CustomTheme.spacePadding),
                      child: CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          indicatorDesign: IndicatorDesign.polygon(
                            polygonDesign: PolygonDesign(
                              polygon: DesignType.polygon_circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: index != pagesLength - 1
                                    ? _skipButton(setIndex: setIndex)
                                    : const SizedBox())),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: index != pagesLength - 1
                                ? _nextButton(setIndex: setIndex)
                                : _signupButton,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
