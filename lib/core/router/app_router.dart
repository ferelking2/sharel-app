import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../view/home/home_page.dart';
import '../../screens/sender/sender_page.dart';
import '../../screens/transfer/preparation_screen.dart';
import '../../screens/transfer/discovery_screen.dart';
import '../../screens/transfer/room_host_screen.dart';
import '../../screens/transfer/join_room_screen.dart';
import '../../screens/transfer/qr_scan_screen.dart';
import '../../screens/transfer/room_client_screen.dart';
import '../../screens/receiver/receiver_page.dart';
import '../../screens/files/files_page.dart';
import '../../screens/notification/notification_center_page.dart';
import '../../screens/me/me_page.dart';
import '../../screens/discovery/discovery_page.dart';
import '../../screens/onboarding/welcome_page.dart';
import '../../widgets/app_shell.dart';
import '../../providers/role_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.error}')),
  ),
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/files',
          builder: (context, state) => const FilesPage(),
        ),
        GoRoute(
          path: '/discovery',
          builder: (context, state) => const DiscoveryPage(),
        ),
        GoRoute(
          path: '/me',
          builder: (context, state) => const MePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/sender',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SenderPage(),
    ),
    GoRoute(
      path: '/transfer/preparation',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final role = state.extra as TransferRole? ?? TransferRole.sender;
        return PreparationScreen(role: role);
      },
    ),
    GoRoute(
      path: '/transfer/host',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RoomHostScreen(),
    ),
    GoRoute(
      path: '/transfer/join',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const JoinRoomScreen(),
    ),
    GoRoute(
      path: '/transfer/scan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const QRScanScreen(),
    ),
    GoRoute(
      path: '/transfer/client',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RoomClientScreen(),
    ),
    GoRoute(
      path: '/transfer/discovery',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DiscoveryScreen(),
    ),
    GoRoute(
      path: '/receiver',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReceiverPage(),
    ),
    GoRoute(
      path: '/notification',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationCenterPage(),
    ),
  ],
);

