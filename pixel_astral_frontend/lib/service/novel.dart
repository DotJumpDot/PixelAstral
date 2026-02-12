import 'dart:convert';
import '../type/novel.dart';
import '../type/collection_type.dart';
import '../type/collection_status.dart';
import 'http.dart';

class NovelService {
  static const String _endpoint = '/api/novels';

  static Future<List<NovelModel>> getNovels() async {
    final response = await HttpService.get(_endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NovelModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
  }

  static Future<List<NovelModel>> getNovelsByType(CollectionType type) async {
    final response = await HttpService.get('$_endpoint?type=${type.toValue()}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NovelModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels by type');
    }
  }

  static Future<NovelModel> getNovelById(String id) async {
    final response = await HttpService.get('$_endpoint/$id');

    if (response.statusCode == 200) {
      return NovelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load novel');
    }
  }

  static Future<NovelModel> createNovel({
    required String title,
    required String url,
    required int chapter,
    required int page,
    required CollectionStatus status,
    required CollectionType type,
  }) async {
    final response = await HttpService.post(
      _endpoint,
      body: {
        'title': title,
        'url': url,
        'chapter': chapter,
        'page': page,
        'status': status.toValue(),
        'type': type.toValue(),
      },
    );

    if (response.statusCode == 201) {
      return NovelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create novel');
    }
  }

  static Future<NovelModel> updateNovel({
    required String id,
    String? title,
    String? url,
    int? chapter,
    int? page,
    CollectionStatus? status,
    CollectionType? type,
  }) async {
    final body = <String, dynamic>{};

    if (title != null) body['title'] = title;
    if (url != null) body['url'] = url;
    if (chapter != null) body['chapter'] = chapter;
    if (page != null) body['page'] = page;
    if (status != null) body['status'] = status.toValue();
    if (type != null) body['type'] = type.toValue();

    final response = await HttpService.put(
      '$_endpoint/$id',
      body: body,
    );

    if (response.statusCode == 200) {
      return NovelModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update novel');
    }
  }

  static Future<void> deleteNovel(String id) async {
    final response = await HttpService.delete('$_endpoint/$id');

    if (response.statusCode != 204) {
      throw Exception('Failed to delete novel');
    }
  }
}
