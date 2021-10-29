import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_udemy/routes.dart';
import 'package:chat_app_udemy/services/auth_service.dart';
import 'package:chat_app_udemy/services/socket_service.dart';
import 'package:chat_app_udemy/services/chat_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
