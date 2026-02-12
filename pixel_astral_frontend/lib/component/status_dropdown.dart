import 'package:flutter/material.dart';
import '../type/collection_status.dart';

class StatusDropdown extends StatelessWidget {
  final CollectionStatus? value;
  final ValueChanged<CollectionStatus?> onChanged;

  const StatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CollectionStatus>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Status'),
      items: CollectionStatus.values.map((status) {
        return DropdownMenuItem<CollectionStatus>(
          value: status,
          child: Text(status.displayName),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
