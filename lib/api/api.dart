import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_photos/model/album.dart';
import 'package:infinite_photos/model/constants.dart';
import 'package:infinite_photos/model/photo.dart';

final _dio = Dio();

Future<int> fetchAlbumCount() async {
  debugPrint('Fetching album count');
  const url = 'https://jsonplaceholder.typicode.com/albums';
  final params = {'_limit': 1};
  final response = await _dio.get(url, queryParameters: params);
  return int.parse(response.headers.value('x-total-count')!);
}

Future<List<Album>> fetchAlbums(int page) async {
  debugPrint('Fetching albums for page $page');
  const url = 'https://jsonplaceholder.typicode.com/albums';
  final params = {
    '_page': page,
    '_per_page': pageSize,
  };
  final response = await _dio.get(url, queryParameters: params);
  return (response.data as List<dynamic>).map((json) => Album.fromJson(json)).toList();
}

Future<int> fetchPhotoCount(int albumId) async {
  debugPrint('Fetching photo count for album $albumId');
  const url = 'https://jsonplaceholder.typicode.com/photos';
  final params = {
    'albumId': albumId,
    '_limit': 1,
  };
  final response = await _dio.get(url, queryParameters: params);
  return int.parse(response.headers.value('x-total-count')!);
}

Future<List<Photo>> fetchPhotos(int albumId, int page) async {
  debugPrint('Fetching photos for album $albumId, page $page');
  const url = 'https://jsonplaceholder.typicode.com/photos';
  final params = {
    'albumId': albumId,
    '_page': page,
    '_per_page': pageSize,
  };
  final response = await _dio.get(url, queryParameters: params);
  return (response.data as List<dynamic>).map((json) => Photo.fromJson(json)).toList();
}

Future<Uint8List> fetchPhotoData(String url) async {
  debugPrint('Fetching photo data for $url');
  final response = await _dio.get<Uint8List>(url, options: Options(responseType: ResponseType.bytes));
  return response.data!;
}
