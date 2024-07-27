import 'package:flutter/material.dart';
import 'package:flutter_carousel_intro/flutter_carousel_intro.dart';
import 'package:flutter_carousel_intro/slider_item_model.dart';
import 'package:flutter_carousel_intro/utils/enums.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/introduction/login_or_register_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
    controller.addListener(() {
      pageIndex.value = controller.page?.round() ?? 2;
    });
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background_image11.png',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _SlideShow(controller: controller),
              const SizedBox(height: 10),
              _IntroButtons(controller: controller, pageIndex: pageIndex),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ));
  }
}

class _SlideShow extends StatelessWidget {
  const _SlideShow({required this.controller});
  final PageController controller;

  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(27, 95, 193, 1), // Changed color to blue
  );

  static const TextStyle subTitleStyle =
      TextStyle(fontSize: 16, overflow: TextOverflow.fade);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlutterCarouselIntro(
        controller: controller,
        scale: true,
        animatedOpacity: false,
        primaryColor: Colors.blue.shade500,
        secondaryColor: Colors.grey.shade400,
        scrollDirection: Axis.horizontal,
        indicatorAlign: IndicatorAlign.bottom,
        showIndicators: true,
        slides: [
          SliderItem(
            title: 'CAPTURE',
            titleTextStyle: titleStyle,
            subtitle: const Text(
              "Snap a photo of your wound with our \n app.",
              textAlign: TextAlign.center,
              style: subTitleStyle,
            ),
            widget: Image.asset("assets/interview_image.png"),
          ),
          SliderItem(
            title: 'ANALYSE',
            titleTextStyle: titleStyle,
            subtitle: const Text(
              'Our AI algorithm assesses texture, size, \n moisture, and more.',
              textAlign: TextAlign.center,
              style: subTitleStyle,
            ),
            widget: Image.asset("assets/interview_image1.png"),
          ),
          SliderItem(
            title: 'HEAL',
            titleTextStyle: titleStyle,
            subtitle: const Text(
              'Receive personalized care recommendations \n for faster healing.',
              textAlign: TextAlign.center,
              style: subTitleStyle,
            ),
            widget: Image.asset("assets/interview_image2.png"),
          ),
        ],
      ),
    );
  }
}

class _IntroButtons extends StatelessWidget {
  const _IntroButtons({required this.controller, required this.pageIndex});
  final PageController controller;
  final ValueNotifier<int> pageIndex;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: pageIndex,
      builder: (context, value, child) {
        final bool isLastPage = value == 2;
        return Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () {
              if (isLastPage) {
                StorageServices.setIntroLaunchComplete();
                _navigateToAuthScreen(context);
              } else {
                controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              }
            },
            style: TextButton.styleFrom(
              elevation: 0,
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 0, width: 0),
                Text(
                  isLastPage ? 'Get Started' : 'Next',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToAuthScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrRegisterScreen(),
      ),
    );
  }
}
