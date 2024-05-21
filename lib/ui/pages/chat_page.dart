import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../const/apikey.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  late List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo, saya Gemini AI. Ada yang bisa saya bantu?',
      photoUrl: 'assets/profile.png',
      type: BubbleType.alone,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage('assets/profile.png'),
          ),
        ),
        title: const Text('Gemini AI', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              reverse: true,
              padding: const EdgeInsets.all(12),
              children: chatBubbles.reversed.toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        color: Color(0xFF5D6679),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFF5D6679)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFF1570EF)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send_rounded),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final content = [
                            Content.text(messageController.text)
                          ];
                          final GenerateContentResponse response =
                              await model.generateContent(content);
                          debugPrint(response.text);
                          setState(() {
                            chatBubbles = [
                              ...chatBubbles,
                              ChatBubble(
                                direction: Direction.right,
                                message: messageController.text,
                                photoUrl: null,
                                type: BubbleType.alone,
                              )
                            ];
                            chatBubbles = [
                              ...chatBubbles,
                              ChatBubble(
                                direction: Direction.left,
                                message: response.text ??
                                    'Maaf, saya tidak mengerti',
                                photoUrl: 'assets/profile.png',
                                type: BubbleType.alone,
                              )
                            ];

                            messageController.clear();
                            isLoading = false;
                          });
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
