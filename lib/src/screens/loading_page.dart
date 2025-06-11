import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/loading_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularLoadingIndicator(
            size: 48,
          ),
          SizedBox(
            height: 52,
            child: Center(
              child: LongLogo(
                size: 0.325,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
