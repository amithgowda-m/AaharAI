// lib/features/nutira_chat/presentation/chat_screen.dart
class NutiraChatScreen extends StatefulWidget {
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
    setState(() {
      messages.add(ChatMessage(text: query, isUser: true));
    });
    _controller.clear();
    
    // Show typing indicator
    setState(() {
      messages.add(ChatMessage(text: '...', isUser: false, isTyping: true));
    });
    
    // Get AI response
    final response = await NutiraRagService().generateResponse(query);
    
    setState(() {
      messages.removeLast(); // Remove typing indicator
      messages.add(ChatMessage(text: response, isUser: false));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(child: Text('N')),
            SizedBox(width: 8),
            Text('Nutira'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          ChatInputField(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
