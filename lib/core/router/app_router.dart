import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../view/home/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    // TODO: Ajouter autres routes
  ],
);
