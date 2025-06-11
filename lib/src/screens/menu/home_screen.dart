// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:route_mates/data/user.dart';
// import 'package:route_mates/fire/config.dart';
// import 'package:route_mates/src/components/home/alpha_welcome_banner.dart';
// import 'package:route_mates/src/components/home/group_preview.dart';
// import 'package:route_mates/src/components/profile_hello.dart';
// import 'package:route_mates/src/const.dart';
// import 'package:route_mates/src/screens/developing_page.dart';
// import 'package:route_mates/src/widgets/loading_widgets.dart';
// import 'package:route_mates/src/widgets/widgets.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key, required this.setActiveIndex});

//   final void Function(int) setActiveIndex;

//   @override
//   Widget build(BuildContext context) {
//     bool work = Config().getBool("home_page");
//     if (!work) {
//       return const DevelopingPage();
//     }

//     var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             darkBg2,
//             darkBg,
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 8, top: 4, right: 4),
//             child: Column(
//               children: [
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       height: 52,
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: LongLogo(
//                           size: 0.4,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 48,
//                 ),
//                 if (user.hasData)
//                   ProfileBox(
//                       pictureSrc: user.data!.uid, name: user.data!.displayName),
//                 if (!user.hasData)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24),
//                     child: LoadingIndicator(),
//                   ),
//                 const SizedBox(
//                   height: 48,
//                 ),
//                 const AlphaWelcomeBanner(),
//                 const SizedBox(
//                   height: 32,
//                 ),
//                 GroupPreview(setActiveIndex: setActiveIndex),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
