// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Use an existing MaterialColor
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false;

  Future<void> _fetchJokeAndNavigate(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://official-joke-api.appspot.com/random_joke'),
      );

      if (response.statusCode == 200) {
        final jokeData = json.decode(response.body);
        final joke = "${jokeData['setup']} - ${jokeData['punchline']}";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JokePage(joke: joke),
          ),
        );
      } else {
        _showError(context, 'Failed to load joke');
      }
    } catch (e) {
      _showError(context, 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke App'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sincerely-media-aUPLLA6o_3I-unsplash.jpg'),
            fit: BoxFit.cover, // Make the image cover the entire background
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _fetchJokeAndNavigate(context),
                  child: const Text('Click here !!! To Get A Joke'),
                ),
        ),
      ),
    );
  }
}

class JokePage extends StatelessWidget {
  final String joke;

  const JokePage({super.key, required this.joke});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke'),
      ),
      body: Stack(
        children: [
          // Background color or decoration
          Container(
            decoration: BoxDecoration(
              color: Colors.pink[50], // Background color
            ),
          ),
          // Top-right image
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding from the edges
              child: Image.asset(
                'assets/360_F_92137539_gPPBRue6NZnlovQP52d9P9vN3ByUPMKw.jpg',
                width: 500, // Adjust the size as needed
                height: 700, // Adjust the size as needed
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Left-aligned joke text with adjusted padding
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 20.0, top: 300.0),
            child: Text(
              joke,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 101, 8, 111),
              ),
              textAlign: TextAlign.left, // Align text to the left
            ),
          ),
        ],
      ),
    );
  }
}
