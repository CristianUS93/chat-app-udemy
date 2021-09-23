import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_udemy/pages/login_page.dart';
import 'package:chat_app_udemy/pages/usuarios_page.dart';
import 'package:chat_app_udemy/services/auth_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, AsyncSnapshot snapshot){
          return Center(
            child: Text("Autenticando..."),
          );
        }
      ),
    );
  }


  Future checkLoginState(BuildContext context)async{

    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if(autenticado){
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuariosPage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    }else{
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    }

  }

}
