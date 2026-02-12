enum CollectionStatus {
  reading,
  completed,
  planToRead,
  dropped,
}

extension CollectionStatusExtension on CollectionStatus {
  String get displayName {
    switch (this) {
      case CollectionStatus.reading:
        return 'Reading';
      case CollectionStatus.completed:
        return 'Completed';
      case CollectionStatus.planToRead:
        return 'Plan to Read';
      case CollectionStatus.dropped:
        return 'Dropped';
    }
  }

  String toValue() {
    switch (this) {
      case CollectionStatus.reading:
        return 'reading';
      case CollectionStatus.completed:
        return 'completed';
      case CollectionStatus.planToRead:
        return 'plan_to_read';
      case CollectionStatus.dropped:
        return 'dropped';
    }
  }

  static CollectionStatus fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'reading':
        return CollectionStatus.reading;
      case 'completed':
        return CollectionStatus.completed;
      case 'plan_to_read':
        return CollectionStatus.planToRead;
      case 'dropped':
        return CollectionStatus.dropped;
      default:
        return CollectionStatus.planToRead;
    }
  }
}
