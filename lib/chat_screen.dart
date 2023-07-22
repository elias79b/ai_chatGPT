import 'package:ai/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatGPT _chatGPT =
      ChatGPT('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');
  final TextEditingController chatController = TextEditingController();
  List<ChatGptModel> chatList = [];
   bool isLoading = false;

  void send(String message) async {

    chatController.clear();
    setState(() {
      isLoading =true;
      chatList.add(ChatGptModel(message: message, sender: 'User'));
    });

    final response = await _chatGPT.sendMassage(message);

    setState(() {
      isLoading =false;
      chatList.add(ChatGptModel(message: response, sender: 'Bot'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
        title: const Text("ChatGPT"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              chatList.clear();
            });
          },
          icon: const Icon(Icons.clear_all),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child:
        chatList.isEmpty ? Center(child:Icon(CupertinoIcons.chat_bubble_2_fill,size: 40,)) :
              ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text: chatList[index].message.trim(),
                        )).then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content:Text("Copied"))));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: chatList[index].sender == "User"
                                ? Colors.grey.shade900
                                : Colors.purple),
                        child: ListTile(
                          leading: chatList[index].sender == "User"
                              ? const Icon(Icons.person)
                              : const Icon(Icons.bolt_rounded),
                          title: SelectableText(chatList[index].message.trim()),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: chatController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon:
                     isLoading == true ?
                     CupertinoActivityIndicator():
                       Icon(Icons.send),
                      onPressed: () {
                        send(chatController.text);
                      },
                    ),
                    hintText: "Type your message here..."),
              ),
            )
          ],
        ),
      ),
    );
  }
}
