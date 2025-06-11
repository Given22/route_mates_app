import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class CustomPage extends StatefulWidget {
  final List<Widget> children;
  const CustomPage({super.key, required this.children});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: darkBg,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                darkBg2,
                darkBg,
              ],
            ),
          ),
          padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...widget.children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
