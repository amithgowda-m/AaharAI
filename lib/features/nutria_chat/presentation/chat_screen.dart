import 'package:flutter/material.dart';

class NutiraChatScreen extends StatefulWidget {
  const NutiraChatScreen({super.key});

  @override
  _NutiraChatScreenState createState() => _NutiraChatScreenState();
}

class _NutiraChatScreenState extends State<NutiraChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Welcome message
    messages.add(ChatMessage(
      text: "Hi! I'm Nutira 🌱 Ask me anything about nutrition or your meal patterns!",
      isUser: false,
    ));
  }
  
  Future<void> _sendMessage() async {
    final query = _controller.text;
    if (query.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: query, isUser: true));
    });
    _controller.clear();
    
    // Show typing indicator
    setState(() {
      messages.add(ChatMessage(text: '...', isUser: false, isTyping: true));
    });
    
    // Simulate AI response for now since NutiraRagService is missing or undefined
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        messages.removeLast(); // Remove typing indicator
        messages.add(ChatMessage(
          text: "I'm currently being updated to provide better nutrition advice! Stay tuned.", 
          isUser: false
        ));
      });
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
                decoration: InputDecoration(
                  hintText: 'Type your question...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
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
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF2E7D32) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

