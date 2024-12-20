import 'package:flutter/material.dart';

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
  bool isDarkMode = false;

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

  void _toggleTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: NotesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        _toggleTheme(value);
                      },
                    ),
                    SizedBox(width: 8),
                    Text(isDarkMode ? "Dark Mode" : "Light Mode"),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Text("Settings"),
              ),
            ],
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note, // Replace with your preferred icon
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
