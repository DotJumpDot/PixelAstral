enum CollectionType {
  manga,
  novel,
  manhwa,
}

extension CollectionTypeExtension on CollectionType {
  String get displayName {
    switch (this) {
      case CollectionType.manga:
        return 'Manga';
      case CollectionType.novel:
        return 'Novel';
      case CollectionType.manhwa:
        return 'Manhwa';
    }
  }

  String toValue() {
    switch (this) {
      case CollectionType.manga:
        return 'manga';
      case CollectionType.novel:
        return 'novel';
      case CollectionType.manhwa:
        return 'manhwa';
    }
  }

  static CollectionType fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'manga':
        return CollectionType.manga;
      case 'novel':
        return CollectionType.novel;
      case 'manhwa':
        return CollectionType.manhwa;
      default:
        return CollectionType.novel;
    }
  }
}
