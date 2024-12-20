import 'package:flutter/material.dart';
import 'Views/filter_notes.dart'; // Import the filter_notes.dart file
import 'Views/search_notes.dart'; // Import the search_notes.dart file (optional if you already have it)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> notes = [];
  String _sortBy = 'modification_date';
  bool _descending = true;
  bool _favoritesOnTop = false;

  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _textController = TextEditingController();
        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'Enter your note Topic'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    notes.add(_textController.text);
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchNotesPage(notes: notes),
      ),
    );
  }

  void _navigateToFilter() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilterNotesPage(
          onApplyFilter: (String sortBy, bool descending, bool favoritesOnTop) {
            setState(() {
              _sortBy = sortBy;
              _descending = descending;
              _favoritesOnTop = favoritesOnTop;
              _applySorting();
            });
          },
        ),
      ),
    );
  }

  void _applySorting() {
    // Example sorting logic
    if (_favoritesOnTop) {
      // Move "favorite" notes to the top (implement favorite logic as needed)
    }

    if (_sortBy == 'alphabetical') {
      notes.sort((a, b) => a.compareTo(b));
    }

    if (_descending) {
      notes = notes.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _navigateToSearch,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _navigateToFilter,
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No notes',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addNote,
                    child: Text('Add first note'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
