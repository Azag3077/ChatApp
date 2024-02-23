import 'package:flutter/material.dart';

import '../controllers/get_started.dart';
import '../widgets/buttons.dart';

class GetStarted extends StatelessWidget with GetStartedController {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50.0),
              const Text(
                'Create an account to join the ChatRoom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 50.0),
              Image.asset('assets/images/get_started_img.png'),
              const Spacer(),
              CustomElevatedButton(
                onPressed: () => onGetStarted(context),
                text: 'Get Started',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
