
import 'package:chat_app_udemy/pages/chat_page.dart';
import 'package:chat_app_udemy/pages/loading_page.dart';
import 'package:chat_app_udemy/pages/login_page.dart';
import 'package:chat_app_udemy/pages/register_page.dart';
import 'package:chat_app_udemy/pages/usuarios_page.dart';
import 'package:flutter/material.dart';


final Map<String, Widget Function(BuildContext)> appRoutes = {

  'usuarios' : (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login' : (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),

};
