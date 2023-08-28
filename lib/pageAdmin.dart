// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print, unused_import, file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:your_project_name/PageLogin/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPagetate createState() => _AdminPagetate();
}

class _AdminPagetate extends State<AdminPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final primaryColor = Color(0xFF1E293B);
  final iconsColor = Colors.white;

  String userMessage = '';

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userUID = user.uid;
      _assignUserMessage(userUID);
    }
  }

  void _submitTicket() {
    // Simulate submitting the ticket
    final subject = _subjectController.text;
    final description = _descriptionController.text;

    print('Ticket submitted: Subject: $subject, Description: $description');
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _assignUserMessage(String uid) {
    // Associe mensagens com base no UID do usuário
    if (uid == 'ZHpDhdUILLeVCiwgDrAvKSyTFu72') {
      userMessage = 'Olá, Admin!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(userMessage),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Column for Photo and Settings
          Container(
            width: 200,
            color:
                primaryColor, // Defina a cor de fundo da parte direita do Container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/backg2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/img/backg2.jpg'),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 15), // Remove o espaçamento padrão do ListTile
                  title: Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: iconsColor,
                      ),
                      SizedBox(
                          width:
                              8), // Adiciona um espaço entre o ícone e o texto
                      Text(
                        'Chamados',
                        style: TextStyle(color: iconsColor),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle settings tap
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 15), // Remove o espaçamento padrão do ListTile
                  title: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: iconsColor,
                      ),
                      SizedBox(
                          width:
                              8), // Adiciona um espaço entre o ícone e o texto
                      Text(
                        'Settings',
                        style: TextStyle(color: iconsColor),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle settings tap
                  },
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                padding: EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Cor de fundo do container
                  borderRadius:
                      BorderRadius.circular(10.0), // Borda arredondada
                ),
                child: Row(
                  children: [
                    Icon(Icons.message), // Ícone de mensagem
                    SizedBox(width: 8.0),
                    Text(
                      'Chamados', // Sua mensagem personalizada aqui
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: null, // Chamando a função ao clicar
                      child: Container(
                        width: 88,
                        height: 33,
                        margin: EdgeInsets.only(
                            right: 18.0, top: 5.0), // Margem para espaçamento
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.green, // Cor de fundo do container
                          borderRadius:
                              BorderRadius.circular(10.0), // Borda arredondada
                        ),
                        child: Row(
                          children: [
                            // Ícone de mensagem
                            SizedBox(width: 5.0),
                            Text(
                              'Buscar', // Sua mensagem personalizada aqui
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: iconsColor,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.search,
                              color: iconsColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // Outros widgets do seu layout
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    Text(
                      'Setor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 137,
                    ),
                    Text(
                      'Divisão',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 142,
                    ), // Adiciona espaço flexível proporcional
                    Text(
                      'Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 175,
                    ), // Adiciona espaço flexível proporcional
                    Text(
                      'Nome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                    ), // Adiciona espaço flexível proporcional
                    Text(
                      'Editar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
