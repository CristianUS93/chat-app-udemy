import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_udemy/widgets/custom_input.dart';
import 'package:chat_app_udemy/widgets/logo_widget.dart';
import 'package:chat_app_udemy/widgets/labels_widget.dart';
import 'package:chat_app_udemy/widgets/boton_widget.dart';
import 'package:chat_app_udemy/services/auth_service.dart';
import 'package:chat_app_udemy/helpers/mostrar_alerta.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: _size.height > _size.width ? _size.height * 0.9 : _size.width * 0.9,
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  text: '¿No tienes cuenta?',
                  textButtonTitle: 'Crea una ahora!',
                  route: 'register',
                ),
                const Text('Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeHolder: 'Email',
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          ButtonWidget(
            title: "Ingresar",
            onPressed: authService.autenticando ? null : ()async {
              
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
              
              if(loginOk == true){
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                mostrarAlerta(context, 'Login incorrecto', loginOk);
              }

            },
          ),
        ],
      ),
    );
  }
}
