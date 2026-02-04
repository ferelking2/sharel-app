import 'package:go_router/go_router.dart';
import '../../view/home/home_page.dart';
import '../../screens/sender/sender_page.dart';
import '../../screens/transfer/preparation_screen.dart';
import '../../screens/transfer/receiver_preparation_screen.dart';
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

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/sender',
      builder: (context, state) => const SenderPage(),
    ),
    GoRoute(
      path: '/transfer/preparation',
      builder: (context, state) => const PreparationScreen(),
    ),
    GoRoute(
      path: '/transfer/host',
      builder: (context, state) => const RoomHostScreen(),
    ),
    GoRoute(
      path: '/transfer/join',
      builder: (context, state) => const JoinRoomScreen(),
    ),
    GoRoute(
      path: '/transfer/scan',
      builder: (context, state) => const QRScanScreen(),
    ),
    GoRoute(
      path: '/transfer/client',
      builder: (context, state) => const RoomClientScreen(),
    ),
    GoRoute(
      path: '/receive/preparation',
      builder: (context, state) => const ReceiverPreparationScreen(),
    ),
    GoRoute(
      path: '/transfer/discovery',
      builder: (context, state) => const DiscoveryScreen(),
    ),
    GoRoute(
      path: '/receiver',
      builder: (context, state) => const ReceiverPage(),
    ),
    GoRoute(
      path: '/files',
      builder: (context, state) => const FilesPage(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationCenterPage(),
    ),
    GoRoute(
      path: '/me',
      builder: (context, state) => const MePage(),
    ),
    GoRoute(
      path: '/discovery',
      builder: (context, state) => const DiscoveryPage(),
    ),
  ],
);
