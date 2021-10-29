import 'dart:io';

import 'package:chat_app_udemy/models/mensajes_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_udemy/services/chat_service.dart';
import 'package:chat_app_udemy/services/auth_service.dart';
import 'package:chat_app_udemy/services/socket_service.dart';

import 'package:chat_app_udemy/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService!.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService!.usuarioPara!.uid);

  }

  void _cargarHistorial(String usuarioID) async {
    
    List<Mensaje> chat = await this.chatService!.getChat(usuarioID);
    final history = chat.map((e) => ChatMessage(
      text: e.mensaje,
      uid: e.de,
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje (dynamic payload){
    ChatMessage message = ChatMessage(
      text: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }


  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService!.usuarioPara;

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
              child: Text(usuarioPara!.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
            ),
            SizedBox(height: 3,),
            Text(usuarioPara.nombre, style: TextStyle(color: Colors.black87, fontSize: 12),),
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
      uid: authService!.usuario!.uid,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {_estaEscribiendo = false;});

    this.socketService!.emit('mensaje-personal', {
      'de': this.authService!.usuario!.uid,
      'para': this.chatService!.usuarioPara!.uid,
      'mensaje': text
    });
  }


  @override
  void dispose() {
    
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    this.socketService!.socket.off('mensaje-personal');
    super.dispose();
  }

}
