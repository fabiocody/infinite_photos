import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_photos/model/constants.dart';
import 'package:infinite_photos/service/photo_provider.dart';
import 'package:infinite_photos/views/skeleton_tile.dart';

class PhotosPage extends ConsumerStatefulWidget {
  final int albumId;

  const PhotosPage({super.key, required this.albumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhotosPageState();
}

class _PhotosPageState extends ConsumerState<PhotosPage> {
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
    // ref.invalidate(photoProvider);
  }

  @override
  Widget build(BuildContext context) {
    final photoCount = ref.watch(photoCountProvider(widget.albumId));
    return Scaffold(
      appBar: AppBar(title: Text('Album ${widget.albumId}')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(photoProvider),
        child: photoCount.when(
          data: (count) => ListView.builder(
            controller: _scrollController,
            itemCount: count,
            itemBuilder: (context, index) {
              final photo = ref
                  .watch(photoProvider((widget.albumId, index ~/ pageSize)))
                  .whenData((photos) => photos[index % pageSize]);
              return ProviderScope(
                overrides: [currentPhotoProvider.overrideWithValue(photo)],
                child: const PhotoTile(),
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

class PhotoTile extends ConsumerWidget {
  const PhotoTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPhoto = ref.watch(currentPhotoProvider);
    return asyncPhoto.when(
      data: (photo) => ListTile(
        leading: CircleAvatar(child: Text(photo.id.toString())),
        title: Text(photo.title),
        trailing: Image.network(
          photo.thumbnailUrl,
          errorBuilder: (context, err, stack) => const SizedBox.shrink(),
        ),
      ),
      error: (err, stack) => const ListTile(
        leading: Icon(Icons.error),
        title: Text('Error'),
      ),
      loading: () => const SkeletonTile(),
    );
  }
}
