import 'package:flutter/material.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTile extends StatelessWidget {
  const LinkTile({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          foregroundColor: grey2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              color: grey,
              fontFamily: Fonts().secondary,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: grey,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
