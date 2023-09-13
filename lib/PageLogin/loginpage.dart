// ignore_for_file: use_build_context_synchronously, unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_project_name/PageLogin/anima%C3%A7%C3%A3o.dart';
import 'package:your_project_name/pageAdmin.dart';
import 'package:your_project_name/pagUser/pageUser.dart';

final GlobalKey<_LoginPageState> loginPageKey = GlobalKey<_LoginPageState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<_LoginPageState> loginPageKey = GlobalKey<_LoginPageState>();

  // Constants
  Color primaryColor = Color(0xFF1E293B);
  Color letters = Colors.white;

  // Controllers
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final paddingLogin = EdgeInsets.fromLTRB(12, 12, 12, 12);

  // State variables
  String _backgroundImage = 'assets/img/background.jpg';

  @override
  void initState() {
    super.initState();
  }

  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      if (userCredential.user != null) {
        // Get the user's UID
        String userUID = userCredential.user!.uid;

        // Check the user's UID and navigate accordingly
        if (userUID == "ZHpDhdUILLeVCiwgDrAvKSyTFu72") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PageUser()),
          );
        }
      } else {
        showErrorPopup(context);
        _usernameController.clear();
        _passwordController.clear();
      }
    } catch (e) {
      // Handle authentication error
      print("Authentication Error: $e");
      showErrorPopup(context);
      _usernameController.clear();
      _passwordController.clear();
    }
  }
  /*void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (true) {
      // Salvar a credencial usando CredentialUtils após autenticação bem-sucedida.
      // await CredentialUtils.saveCredential(result);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageUser()),
      );
    }
  }*/

  void showErrorPopup(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro ao enviar solicitação'),
          content: Text('Usuário e/ou senha inválidos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _imageDragged() {
    // Alternando entre as imagens e solicitando que a tela seja reconstruída
    setState(() {
      if (_backgroundImage == 'assets/img/background3.png') {
        _backgroundImage = 'assets/img/lanche.png';
      } else {
        _backgroundImage = 'assets/img/background3.png';
      }

      if (primaryColor == Color(0xFF1E293B)) {
        primaryColor = Color.fromARGB(255, 53, 187, 189);
      } else {
        primaryColor = Color(0xFF1E293B);
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: letters,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50), // Adicione espaço acima do Column
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Alterado para MainAxisAlignment.start
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                    1.5,
                    Image.asset('assets/img/logo.png'),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.7,
                    Container(
                      width: 500, // Adjust the width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: letters.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: paddingLogin,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 18),
                                hintText: "E-mail",
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: paddingLogin,
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 18),
                                hintText: "Senha",
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeAnimation(
                    1.7,
                    Text(
                      "Esqueceu a senha?",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 216, 198, 198),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.9,
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 216, 198, 198),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.all(0),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
