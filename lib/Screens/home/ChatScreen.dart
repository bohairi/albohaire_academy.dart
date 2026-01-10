import 'package:flutter/material.dart';

import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ChatMessagesController();
  final _currentUser = ChatUser(id: 'user', firstName: 'User');
  final _aiUser = ChatUser(id: 'ai', firstName: 'AI Assistant');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat Scalable')),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _controller,
        onSendMessage: _handleSendMessage,
        
        // Optional parameters
        loadingConfig: LoadingConfig(isLoading: _isLoading),
        inputOptions: InputOptions(
          //  : 'Ask me anything...',
          sendOnEnter: true,
        ),
        welcomeMessageConfig: WelcomeMessageConfig(
          title: 'Welcome to AI Chat',
          questionsSectionTitle: 'Try asking me:',
        ),
        exampleQuestions: [
          ExampleQuestion(question: "What can you help me with?"),
          ExampleQuestion(question: "Tell me about your features"),
        ],
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    
    try {
      // Your AI service logic here
      await Future.delayed(Duration(seconds: 1)); // Simulating API call
      
      // Add AI response
      _controller.addMessage(ChatMessage(
        text: "This is a response to: ${message.text}",
        user: _aiUser,
        createdAt: DateTime.now(),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}