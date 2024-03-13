import 'package:infinite_photos/api/api.dart';
import 'package:infinite_photos/model/photo.dart';
import 'package:riverpod/riverpod.dart';

final photoCountProvider = FutureProvider.autoDispose.family<int, int>(
  (ref, albumId) async => fetchPhotoCount(albumId),
);

final photoProvider = FutureProvider.family<List<Photo>, (int, int)>((ref, arg) async {
  final (albumId, index) = arg;
  final page = index + 1;
  final photos = await fetchPhotos(albumId, page);
  return photos;
});

final currentPhotoProvider = Provider.autoDispose<AsyncValue<Photo>>((ref) {
  // Overridden in PhotosPage
  throw UnimplementedError();
});
