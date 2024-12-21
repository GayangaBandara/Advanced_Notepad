import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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

class Note {
  String title;
  String description;
  bool isStarred;

  Note({
    required this.title,
    required this.description,
    this.isStarred = false,
  });
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  String searchQuery = "";
  String filterBy = 'All';

  void _addOrEditNote({Note? existingNote}) {
    final TextEditingController titleController =
        TextEditingController(text: existingNote?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: existingNote?.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(existingNote == null ? 'Add Note' : 'Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Enter title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Enter description'),
                maxLines: 3,
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (existingNote == null) {
                    notes.add(Note(
                      title: titleController.text,
                      description: descriptionController.text,
                    ));
                  } else {
                    existingNote.title = titleController.text;
                    existingNote.description = descriptionController.text;
                  }
                  _applyFilters();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(Note note) {
    setState(() {
      notes.remove(note);
      _applyFilters();
    });
  }

  void _toggleStar(Note note) {
    setState(() {
      note.isStarred = !note.isStarred;
      _applyFilters();
    });
  }

  void _shareNote(Note note) {
    Share.share('${note.title}\n\n${note.description}');
  }

  void _applyFilters() {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              (filterBy == 'All' || (filterBy == 'Starred' && note.isStarred)) &&
              (searchQuery.isEmpty ||
                  note.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  note.description
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())))
          .toList();
    });
  }

  void _showNoteOptions(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                _addOrEditNote(existingNote: note);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                _deleteNote(note);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Navigator.of(context).pop();
                _shareNote(note);
              },
            ),
            ListTile(
              leading: Icon(note.isStarred ? Icons.star : Icons.star_border),
              title: Text(note.isStarred ? 'Unstar' : 'Star'),
              onTap: () {
                Navigator.of(context).pop();
                _toggleStar(note);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Notes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                leading: Radio(
                  value: 'All',
                  groupValue: filterBy,
                  onChanged: (value) {
                    setState(() {
                      filterBy = value!;
                      _applyFilters();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('Starred'),
                leading: Radio(
                  value: 'Starred',
                  groupValue: filterBy,
                  onChanged: (value) {
                    setState(() {
                      filterBy = value!;
                      _applyFilters();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotesSearchDelegate(
                  notes: notes,
                  onSearch: (query) {
                    setState(() {
                      searchQuery = query;
                      _applyFilters();
                    });
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: filteredNotes.isEmpty
          ? Center(
              child: Text('No notes available.'),
            )
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.description),
                  trailing: Icon(
                    note.isStarred ? Icons.star : Icons.star_border,
                    color: note.isStarred ? Colors.amber : null,
                  ),
                  onTap: () => _showNoteOptions(note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class NotesSearchDelegate extends SearchDelegate {
  final List<Note> notes;
  final Function(String) onSearch;

  NotesSearchDelegate({required this.notes, required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
          onTap: () {
            close(context, null);
          },
        );
      },
    );
  }
}
