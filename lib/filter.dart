import 'package:flutter/material.dart';

void showFilterDialog(BuildContext context, String currentFilter, Function(String) onFilterSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Filter Notes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('All'),
              value: 'All',
              groupValue: currentFilter,
              onChanged: (value) {
                Navigator.of(context).pop();
                onFilterSelected(value!);
              },
            ),
            RadioListTile<String>(
              title: Text('Starred'),
              value: 'Starred',
              groupValue: currentFilter,
              onChanged: (value) {
                Navigator.of(context).pop();
                onFilterSelected(value!);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
