import 'package:tea_talks/screens/dashboard_screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:tea_talks/utility/ui_constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 70),
          Image.asset("assets/images/welcome_image.png"),
          const SizedBox(height: 150),
          Text(
            "Welcome to our \nmessaging app",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          FittedBox(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 60,
                    color: Colors.white,
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: kImperialOrange,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
