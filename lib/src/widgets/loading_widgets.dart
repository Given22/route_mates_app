import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';

class CircularLoadingIndicator extends StatelessWidget {
  const CircularLoadingIndicator({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? orange,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearProgressIndicator(
        color: orange,
        backgroundColor: blueLink,
      ),
    );
  }
}
