import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/src/screens/loading_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Stream<AsyncSnapshot<User?>> userAuth = Auth().authChanges;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _subscription = userAuth.listen((event) {
        if (event.connectionState == ConnectionState.active) {
          if (event.hasData) {
            context.go('/logged');
          } else {
            context.go('/start');
          }
        }
      });
    });

    return const LoadingPage();
  }
}
