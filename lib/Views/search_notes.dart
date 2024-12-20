import 'package:flutter/material.dart';

class SearchNotesPage extends StatefulWidget {
  final List<String> notes;

  SearchNotesPage({required this.notes});

  @override
  _SearchNotesPageState createState() => _SearchNotesPageState();
}

class _SearchNotesPageState extends State<SearchNotesPage> {
  List<String> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredNotes = widget.notes; // Initialize with all notes
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = widget.notes
          .where((note) => note.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: 'Search note topic...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
                    child: Text('No matching notes found.'),
                  )
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredNotes[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
