import 'package:flutter/material.dart';
import '../type/collection_status.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final CollectionStatus status;

  const StatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    switch (status) {
      case CollectionStatus.reading:
        return AppTheme.accentColor;
      case CollectionStatus.completed:
        return AppTheme.successColor;
      case CollectionStatus.planToRead:
        return AppTheme.warningColor;
      case CollectionStatus.dropped:
        return AppTheme.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(), width: 1),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
