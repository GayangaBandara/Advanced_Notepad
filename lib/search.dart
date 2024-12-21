import 'package:flutter/material.dart';
import 'main.dart';

class NotesSearchDelegate extends SearchDelegate {
  final List<Note> notes;
  final Function(String) onSearch;

  NotesSearchDelegate({
    required this.notes,
    required this.onSearch,
  });

  @override
  String get searchFieldLabel => 'Search notes';

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
    final results = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
          onTap: () {
            close(context, note);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
          onTap: () {
            query = note.title;
            showResults(context);
          },
        );
      },
    );
  }
}
