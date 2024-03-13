import 'package:infinite_photos/api/api.dart';
import 'package:infinite_photos/model/album.dart';
import 'package:riverpod/riverpod.dart';

final albumCountProvider = FutureProvider.autoDispose<int>((ref) => fetchAlbumCount());

final albumProvider = FutureProvider.family<List<Album>, int>((ref, index) async {
  final page = index + 1;
  final albums = await fetchAlbums(page);
  return albums;
});

final currentAlbumProvider = Provider.autoDispose<AsyncValue<Album>>((ref) {
  // Overridden in AlbumsPage
  throw UnimplementedError();
});
