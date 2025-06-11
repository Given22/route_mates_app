import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: darkGrey2,
        centerTitle: true,
        title: CustomText(
          text: "Page not found",
          color: grey,
          size: 20,
          weight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go("/"),
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(orange)),
          child: const CustomText(
            text: "Go home",
            weight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
