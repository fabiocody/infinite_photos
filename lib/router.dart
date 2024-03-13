import 'package:go_router/go_router.dart';
import 'package:infinite_photos/views/albums_page.dart';
import 'package:infinite_photos/views/photos_page.dart';

final router = GoRouter(
  initialLocation: '/albums',
  routes: [
    GoRoute(
      path: '/albums',
      builder: (context, state) => const AlbumsPage(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => PhotosPage(
            albumId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    ),
  ],
);
