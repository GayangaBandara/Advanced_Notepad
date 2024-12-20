import 'package:flutter/material.dart';

void main() {
  runApp(const NotepadApp());
}

class NotepadApp extends StatelessWidget {
  const NotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotepadMainScreen(),
    );
  }
}

class NotepadMainScreen extends StatelessWidget {
  const NotepadMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notepad',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // Align the title to the center
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          maxLines: null, // Allows multiple lines
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Start typing your notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding or saving a note
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note action executed!')),
          );
        },
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        child: const Icon(Icons.save),
      ),
    );
  }
}
