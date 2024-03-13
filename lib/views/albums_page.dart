import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_photos/model/constants.dart';
import 'package:infinite_photos/router.dart';
import 'package:infinite_photos/service/album_provider.dart';
import 'package:infinite_photos/views/skeleton_tile.dart';

class AlbumsPage extends ConsumerStatefulWidget {
  const AlbumsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends ConsumerState<AlbumsPage> {
  late final _scrollController = ScrollController();
  bool _showGoToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => setState(() => _showGoToTopButton = _scrollController.offset >= 160));
  }

  @override
  void dispose() {
    super.dispose();
    ref.invalidate(albumProvider);
  }

  @override
  Widget build(BuildContext context) {
    final albumCount = ref.watch(albumCountProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(albumProvider),
        child: albumCount.when(
          data: (count) => ListView.builder(
            controller: _scrollController,
            itemCount: count,
            itemBuilder: (context, index) {
              final album = ref.watch(albumProvider(index ~/ pageSize)).whenData((albums) => albums[index % pageSize]);
              return ProviderScope(
                overrides: [currentAlbumProvider.overrideWithValue(album)],
                child: const AlbumTile(),
              );
            },
          ),
          error: (err, stack) => const Center(child: Icon(Icons.error)),
          loading: () => ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => const SkeletonTile(),
          ),
        ),
      ),
      floatingActionButton: _showGoToTopButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}

class AlbumTile extends ConsumerWidget {
  const AlbumTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbum = ref.watch(currentAlbumProvider);
    return asyncAlbum.when(
      data: (album) => ListTile(
        leading: CircleAvatar(child: Text(album.id.toString())),
        title: Text(album.title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => router.go('/albums/${album.id}'),
        //.then((_) => Future.delayed(const Duration(milliseconds: 500), () => ref.invalidate(photoProvider))),
      ),
      error: (err, stack) => const ListTile(
        leading: Icon(Icons.error),
        title: Text('Error'),
      ),
      loading: () => const SkeletonTile(),
    );
  }
}
