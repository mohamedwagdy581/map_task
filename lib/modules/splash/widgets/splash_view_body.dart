import 'package:flutter/material.dart';
import 'package:google_maps/home_layout/home_layout.dart';

import 'sliding_text.dart';

class SplashViewbody extends StatefulWidget {
  const SplashViewbody({Key? key}) : super(key: key);

  @override
  State<SplashViewbody> createState() => _SplashViewbodyState();
}

class _SplashViewbodyState extends State<SplashViewbody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();

    navigateToHome();
  }

// Dispose the animation controller when the view is destroyed.
  @override
  void dispose() {
    super.dispose();

    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/images/googleLogo.png'),
        const SizedBox(
          height: 4,
        ),
        SlidingText(slidingAnimation: slidingAnimation),
      ],
    );
  }

// Initialize the SlidingText animation.
  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
            .animate(animationController);

    animationController.forward();
  }

// Navigation to HomeView
  void navigateToHome() {
    Future.delayed(
      const Duration(seconds: 3),
          () {
        // Get.to(
        //   () => const HomeView(),
        //   transition: Transition.fade,
        //   duration: kTranstionDuration,
        // );

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeLayout()));
      },
    );
  }
}