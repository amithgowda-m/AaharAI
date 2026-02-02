// lib/features/nutria_chat/presentation/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // IMPORT THIS
import '../../../services/nutria_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  final NutriaService _nutriaService = NutriaService();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController(); // Added scroll controller

  @override
  void initState() {
    super.initState();
    // Welcome message
    messages.add(ChatMessage(
      text: "Hi! I'm Nutira 🌱 Ask me anything about nutrition or your meal patterns!",
      isUser: false,
    ));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  Future<void> _sendMessage() async {
    final query = _controller.text;
    if (query.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: query, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();
    
    // Show typing indicator
    setState(() {
      messages.add(ChatMessage(text: '...', isUser: false, isTyping: true));
    });
    _scrollToBottom();
    
    // Prepare history for API
    List<Map<String, String>> history = messages
        .where((m) => !m.isTyping)
        .map((m) => {
              'role': m.isUser ? 'user' : 'assistant',
              'content': m.text,
            })
        .toList();

    // Get response from service
    final response = await _nutriaService.getChatResponse(
      message: query,
      history: history,
    );
    
    if (mounted) {
      setState(() {
        messages.removeLast(); // Remove typing indicator
        messages.add(ChatMessage(
          text: response, 
          isUser: false
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF2E7D32),
              child: const Text('N', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            const Text(
              'Nutira AI',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach controller
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: 8,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Type your question...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF2E7D32),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isTyping = false,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Define text color based on sender
    final textColor = message.isUser ? Colors.white : Colors.black87;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // Max width to ensure markdown doesn't stretch weirdly
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF2E7D32) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
        ),
        // Use MarkdownBody instead of Text
        child: MarkdownBody(
          data: message.text,
          selectable: true, // Allows user to copy text
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: textColor, 
              fontSize: 15,
              height: 1.4, // Better line height for reading
            ),
            strong: TextStyle(
              color: textColor, 
              fontWeight: FontWeight.bold
            ), // This fixes the **bold** issue
            listBullet: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}