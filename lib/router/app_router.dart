import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/browse/browse_screen.dart';
import '../screens/report/report_screen.dart';
import '../screens/detail/detail_screen.dart';

/// App route names
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String browse = '/browse';
  static const String reportLost = '/report/lost';
  static const String reportFound = '/report/found';
  static const String detail = '/item/:id';

  static String detailPath(String id) => '/item/$id';
}

/// Top-level router instance
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => _buildPage(
        state,
        const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.browse,
      name: 'browse',
      pageBuilder: (context, state) => _buildPage(
        state,
        const BrowseScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.reportLost,
      name: 'reportLost',
      pageBuilder: (context, state) => _buildPage(
        state,
        const ReportScreen(isLost: true),
      ),
    ),
    GoRoute(
      path: AppRoutes.reportFound,
      name: 'reportFound',
      pageBuilder: (context, state) => _buildPage(
        state,
        const ReportScreen(isLost: false),
      ),
    ),
    GoRoute(
      path: AppRoutes.detail,
      name: 'detail',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return _buildPage(state, DetailScreen(itemId: id));
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

CustomTransitionPage<void> _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
