import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';

class ChatView extends StatefulWidget {
  final String adminId;
  final String adminName;

  ChatView({required this.adminId, required this.adminName});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController _chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();
  String currentUserId = "your_current_user_id_here"; // fetch from auth

  @override
  void initState() {
    super.initState();
    _chatController.startChatStream(currentUserId, widget.adminId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.adminName}")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: _chatController.messages.length,
              itemBuilder: (context, index) {
                var message = _chatController.messages[index];
                bool isMe = message['senderId'] == currentUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message['message']),
                  ),
                );
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.trim().isNotEmpty) {
                      await _chatController.sendMessage(
                        currentUserId,
                        widget.adminId,
                        _messageController.text.trim(),
                      );
                      _messageController.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
