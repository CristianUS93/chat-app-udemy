import 'dart:io';

import 'package:chat_app_udemy/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  List<ChatMessage> _messages = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text("Te", style: TextStyle(fontSize: 12),),
            ),
            SizedBox(height: 3,),
            Text("Melissa Flores", style: TextStyle(color: Colors.black87, fontSize: 12),),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i]
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              height: 50,
              child: _intupChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _intupChat (){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (text){
                  setState(() {
                    if(text.trim().length > 0){
                      _estaEscribiendo = true;
                    }else{
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: "Enviar mensaje"),
                focusNode: _focusNode,
              ), 
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text("Enviar", style: TextStyle(
                  color: _estaEscribiendo ? Colors.blue : Colors.grey
                ),),
                onPressed: () => _estaEscribiendo
                  ? _handleSubmit(_textController.text.trim())
                  : null,
              )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(
                    color: _estaEscribiendo ? Colors.blue[400] : Colors.grey,
                  ),
                  child: IconButton(
                    onPressed: () => _estaEscribiendo
                      ? _handleSubmit(_textController.text.trim())
                      : null, 
                    icon: Icon(Icons.send),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text){
    if(text.length == 0) return;

    print(text);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text, 
      uid: "123",
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
  }


  @override
  void dispose() {
    // TODO: Off del socket
    
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    super.dispose();
  }

}
