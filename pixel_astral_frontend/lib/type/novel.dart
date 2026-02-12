import 'collection_type.dart';
import 'collection_status.dart';

abstract class Novel {
  String get id;
  String get title;
  String get url;
  int get chapter;
  int get page;
  CollectionStatus get status;
  CollectionType get type;
  DateTime get createdAt;
  DateTime? get updatedAt;
}

class NovelModel implements Novel {
  @override
  final String id;
  @override
  final String title;
  @override
  final String url;
  @override
  final int chapter;
  @override
  final int page;
  @override
  final CollectionStatus status;
  @override
  final CollectionType type;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  NovelModel({
    required this.id,
    required this.title,
    required this.url,
    this.chapter = 0,
    this.page = 0,
    required this.status,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });

  factory NovelModel.fromJson(Map<String, dynamic> json) {
    return NovelModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      chapter: json['chapter'] ?? 0,
      page: json['page'] ?? 0,
      status: CollectionStatusExtension.fromValue(json['status'] ?? 'plan_to_read'),
      type: CollectionTypeExtension.fromValue(json['type'] ?? 'novel'),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'chapter': chapter,
      'page': page,
      'status': status.toValue(),
      'type': type.toValue(),
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  NovelModel copyWith({
    String? id,
    String? title,
    String? url,
    int? chapter,
    int? page,
    CollectionStatus? status,
    CollectionType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NovelModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      chapter: chapter ?? this.chapter,
      page: page ?? this.page,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
