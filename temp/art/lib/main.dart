import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

Future<List<Book>> fetchBooks() async {
  final querySnapshot = await db.collection("books").get();
  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    return Book(id: data['id'] ?? 0, name: data['name'] ?? '');
  }).toList();
}

class Book {
  final int id;
  final String name;

  const Book({required this.id, required this.name});

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'name': String name} => Book(id: id, name: name),
      _ => throw const FormatException('Failed to load book.'),
    };
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Book>> futureBook;

  @override
  void initState() {
    super.initState();
    futureBook = fetchBooks();
  }

  final Stream<QuerySnapshot> _booksStream = FirebaseFirestore.instance
      .collection('books')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Fetch Data Example')),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: futureBook,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].name),
                          subtitle: Text('ID: ${snapshot.data![index].id}'),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _booksStream,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No books found'));
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((
                          DocumentSnapshot document,
                        ) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['name']),
                            subtitle: Text(data['name']),
                          );
                        }).toList(),
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
