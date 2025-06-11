import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/friendships.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/data/requests.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/src/screens/error_page.dart';
import 'package:route_mates/src/screens/groups_subpages/create_group_screen.dart';
import 'package:route_mates/src/screens/groups_subpages/edit_group_screen.dart';
import 'package:route_mates/src/screens/groups_subpages/members_screen.dart';
import 'package:route_mates/src/screens/onBoarding/create_profile.dart';
import 'package:route_mates/src/screens/onBoarding/first_friends.dart';
import 'package:route_mates/src/screens/onBoarding/first_vehicle.dart';
import 'package:route_mates/src/screens/start/key_page.dart';
import 'package:route_mates/src/screens/start/login_page.dart';
import 'package:route_mates/src/screens/start/register_page.dart';
import 'package:route_mates/src/screens/start/start_page.dart';
import 'package:route_mates/src/screens/profile_subpages/edit_profile_screen.dart';
import 'package:route_mates/src/screens/home_subpages/notifications_screen.dart';
import 'package:route_mates/src/screens/settings_screen.dart';
import 'package:route_mates/src/screens/users_preview/user_screen.dart';
import 'package:route_mates/src/tree/init_view.dart';
import 'package:route_mates/src/tree/logged_view.dart';
import 'package:route_mates/src/tree/logout_view.dart';
import 'package:route_mates/src/tree/main_view.dart';
import 'package:route_mates/utils/alerts/alert_delay.dart';
import 'package:route_mates/utils/map/background_sharing_service.dart';

final GlobalKey<NavigatorState> providerKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/key',
      builder: (context, state) {
        return const KeyPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const InitPage();
      },
    ),
    // Onboarding
    GoRoute(
      path: '/start',
      builder: (context, state) => const StartPage(),
      routes: [
        GoRoute(
          name: "LOGIN",
          path: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: "REGISTER",
          path: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    ),
    GoRoute(
      name: "CREATE",
      path: '/create',
      builder: (context, state) => const CreateProfilePage(),
    ),
    GoRoute(
      path: '/signout',
      builder: (context, state) {
        return const LogOutPage();
      },
    ),

    ShellRoute(
        builder: (context, state, child) {
          return MultiProvider(
            providers: [
              StreamProvider<AsyncSnapshot<UserStore?>>.value(
                value: Store().userStream,
                initialData: const AsyncSnapshot.waiting(),
                catchError: (context, error) {
                  return const AsyncSnapshot.nothing();
                },
                updateShouldNotify: (before, after) {
                  if (before != after) {
                    return true;
                  }
                  return false;
                },
              ),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/logged',
            builder: (context, state) => const LoggedWidgetTree(),
          ),
          // Provider for logged in users
          ShellRoute(
            builder: (context, state, child) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<BackgroundSharingService>(
                      create: (_) => BackgroundSharingService()),
                  ChangeNotifierProvider<AlertDelay>(
                      create: (_) => AlertDelay()),
                ],
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const SettingsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideTransition(
                              position: animation.drive(
                                Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeIn)),
                              ),
                              child: child),
                ),
              ),
              GoRoute(
                path: '/edit_profile',
                builder: (context, state) => const EditProfilePage(),
              ),
              GoRoute(
                path: '/edit_group',
                builder: (context, state) =>
                    EditGroupPage(group: state.extra as AsyncSnapshot<Group?>),
              ),
              GoRoute(
                path: '/groupMembers',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: MembersPage(
                    group: state.extra as AsyncSnapshot<Group?>,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).chain(
                        CurveTween(curve: Curves.easeIn),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
              GoRoute(
                path: '/createGroup',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CreateGroupPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeIn)),
                    ),
                    child: child,
                  ),
                ),
              ),
              ShellRoute(
                navigatorKey: providerKey,
                builder: (context, state, child) {
                  return MultiProvider(
                    providers: [
                      StreamProvider<List<GotRequest>>.value(
                        value: Store().gotFriendshipsRequestsStream,
                        initialData: const [],
                        catchError: (context, error) {
                          return [];
                        },
                        updateShouldNotify: (before, after) {
                          if (before != after) {
                            return true;
                          }
                          return false;
                        },
                      ),
                      StreamProvider<List<SendRequest>>.value(
                        value: Store().sendFriendshipsRequestsStream,
                        initialData: const [],
                        catchError: (context, error) {
                          return [];
                        },
                        updateShouldNotify: (before, after) {
                          if (before != after) {
                            return true;
                          }
                          return false;
                        },
                      ),
                      StreamProvider<List<Vehicle>>.value(
                        value: Store().garageStream,
                        initialData: const [],
                        catchError: (context, error) {
                          return [];
                        },
                        updateShouldNotify: (before, after) {
                          if (before != after) {
                            return true;
                          }
                          return false;
                        },
                      ),
                      StreamProvider<List<Friend>>.value(
                        value: Store().friendsStream,
                        initialData: const [],
                        catchError: (context, error) {
                          return [];
                        },
                        updateShouldNotify: (before, after) {
                          if (before != after) {
                            return true;
                          }
                          return false;
                        },
                      ),
                    ],
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: '/main',
                    builder: (context, state) =>
                        MainView(page: state.extra as int?),
                  ),
                  GoRoute(
                    path: '/first_friends',
                    builder: (context, state) => const FirstFriends(),
                  ),
                  GoRoute(
                    path: '/first_vehicle',
                    builder: (context, state) => const FirstVehicle(),
                  ),
                  GoRoute(
                    path: '/users/:userId',
                    builder: (context, state) =>
                        UserScreen(id: state.pathParameters['userId']),
                  ),
                  GoRoute(
                    path: '/notifications',
                    name: "NOTIFICATIONS",
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const NotificationsScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).chain(CurveTween(curve: Curves.easeIn)),
                            ),
                            child: child,
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ]),
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);
