import 'package:chat_app_udemy/models/usuarios_response.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app_udemy/services/auth_service.dart';
import 'package:chat_app_udemy/global/environment.dart';
import 'package:chat_app_udemy/models/usuario.dart';


class UsuariosService {
  Future<List<Usuario>> getUsuario() async {
    
    try{

      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );
      
      final usuariosResponse = usuariosResponseFromJson( resp.body );

      return usuariosResponse.usuarios;

    }catch (e){
      return [];
    }

  }
}