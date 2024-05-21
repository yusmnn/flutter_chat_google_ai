import 'package:flutter/material.dart';
import 'package:flutter_chat_google_ai/ui/pages/chat_page.dart';

const apiKey = 'AIzaSyAi802gSfvPOMm7SIHW_Oe2jS--pkicA3U';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemini AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChatPage(),
    );
  }
}
