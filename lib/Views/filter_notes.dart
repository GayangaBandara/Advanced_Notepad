import 'package:flutter/material.dart';

class FilterNotesPage extends StatefulWidget {
  final Function(String sortBy, bool descending, bool favoritesOnTop) onApplyFilter;

  FilterNotesPage({required this.onApplyFilter});

  @override
  _FilterNotesPageState createState() => _FilterNotesPageState();
}

class _FilterNotesPageState extends State<FilterNotesPage> {
  String _sortBy = 'modification_date';
  bool _descending = true;
  bool _favoritesOnTop = false;

  void _applyFilter() {
    widget.onApplyFilter(_sortBy, _descending, _favoritesOnTop);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort Notes'),
        actions: [
          TextButton(
            onPressed: _applyFilter,
            child: Text(
              'APPLY',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Modification date'),
              leading: Radio<String>(
                value: 'modification_date',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Creation date'),
              leading: Radio<String>(
                value: 'creation_date',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Reminder date'),
              leading: Radio<String>(
                value: 'reminder_date',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Alphabetically'),
              leading: Radio<String>(
                value: 'alphabetical',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
              ),
            ),
            SwitchListTile(
              title: Text('Favorites on top'),
              value: _favoritesOnTop,
              onChanged: (value) {
                setState(() {
                  _favoritesOnTop = value;
                });
              },
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text('Descending'),
                    Switch(
                      value: _descending,
                      onChanged: (value) {
                        setState(() {
                          _descending = value;
                        });
                      },
                    ),
                    Text('Ascending'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
