import 'package:flutter/material.dart';
import 'package:litebook/api/momox_backend.dart';
import 'package:litebook/api/rebuy_backend.dart';
import 'package:litebook/screens/onboarding/page_welcome.dart';
import 'package:litebook/widgets/account_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:litebook/main.dart' as main;

class Onboarding extends StatefulWidget {
  final VoidCallback onOnboardingComplete;
  const Onboarding({Key? key, required this.onOnboardingComplete})
      : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _controller = PageController();

  final rebuyU = TextEditingController();
  final rebuyP = TextEditingController();

  final momoxU = TextEditingController();
  final momoxP = TextEditingController();

  bool isLastPage = false;
  bool isFirstPage = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          onPageChanged: (value) => setState(() {
            isLastPage = value == 2;
            isFirstPage = value == 0;
          }),
          children: [
            const WelcomePage(),
            Container(
              color: const Color(0xFF4a4a4a),
              child: AccountWidget(
                title: 'Rebuy',
                usernameController: rebuyU,
                passwordController: rebuyP,
              ),
            ),
            Container(
              color: const Color(0xFF0069b4),
              child: AccountWidget(
                title: 'Momox',
                usernameController: momoxU,
                passwordController: momoxP,
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isFirstPage
                ? const SizedBox(
                    width: 65,
                  )
                : TextButton(
                    onPressed: () {
                      _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: const Text("Back")),
            Center(
                child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
            )),
            TextButton(
                onPressed: () async {
                  if (_controller.page == 0) {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  } else if (_controller.page == 1) {
                    if ((await Rebuy(
                                username: rebuyU.text, password: rebuyP.text)
                            .login()) ==
                        false) {
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Error"),
                          content: const Text(
                              "The Rebuy Login was not successful. Please try again."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Ok"))
                          ],
                        ),
                      );
                    } else {
                      main.box.put("rebuyU", rebuyU.text);
                      main.box.put("rebuyP", rebuyP.text);
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }
                  } else if (_controller.page == 2) {
                    if ((await Momox(
                                username: momoxU.text, password: momoxP.text)
                            .login()) ==
                        false) {
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Error"),
                          content: const Text(
                              "The Momox Login was not successful. Please try again."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Ok"))
                          ],
                        ),
                      );
                    } else {
                      main.box.put("momoxU", momoxU.text);
                      main.box.put("momoxP", momoxP.text);
                      widget.onOnboardingComplete();
                    }
                  }
                },
                child: isLastPage ? const Text("Finish") : const Text("Next")),
          ],
        ),
      ),
    ));
  }
}
