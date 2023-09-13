// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print, file_names, depend_on_referenced_packages, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:your_project_name/PageLogin/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:your_project_name/pagUser/classes.dart';
import 'package:your_project_name/pagUser/page_user_functions.dart';
import 'page_user_functions.dart';

class PageUser extends StatefulWidget {
  @override
  _PageUserState createState() => _PageUserState();
}

class _PageUserState extends State<PageUser> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _ticketsStream;
  final TextEditingController _setorController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _chipController = TextEditingController();
  final primaryColor = Color(0xFF1E293B);
  final iconsColor = Colors.white;
  final iconsC = Colors.amber;
  static const double fontSizeCon = 15.0;
  static const double sizeAdd = 13;

  String selectedTicketId = '';
  String userMessage = '';
  String div = '';
  late String userUID;
  bool isLoading = false;
  bool isLoadingTickets = true;
  bool hasCreatedTicket = false;

  bool mostrartitulo = true;
  bool mostrarsub = true;

  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUID = user.uid; // Atribui o valor ao userUID
      _assignUserMessage(userUID);
    }

    /* if (true) {
      userUID = 'User Teste'; // Atribui o valor ao userUID
      _assignUserMessage(userUID);
    }*/
  }

  void _assignUserMessage(String uid) {
    if (uid == '5BRMjdlDy7h65UjaiyZyjO5jruM2') {
      // ALVORADA
      userMessage = 'Olá, GD Alvorada!';
      div = '  Alvorada    ';
    } else if (uid == '9JY6iNzulmZ60HOhvqLUGTwNUx93') {
      // FLOR SERTÃO
      userMessage = 'Olá, GD Flor do Sertão!';
      div = 'Flor do Sertão';
    } else if (uid == '') {
      // BANDEIRANTES
      userMessage = 'Olá, GD Bandeirantes';
      div = ' Bandeirantes ';
    } else if (uid == '') {
      // MARAJOARA
      userMessage = 'Olá, GD Marajoara!';
      div = '  Marajoara   ';
    } else if (uid == 'h1WDDrhtrhfWbEU0WH7W6JThIFg2') {
      // Default message if the UID doesn't match any of the above
      userMessage = 'Olá, usuário!';
      div = '   User Test  '; // Set appropriate default value
    }
  }

  void _openNewTicketDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Novo Chamado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nome Completo'),
                controller: _nomeController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cpf'),
                controller: _cpfController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Setor'),
                controller: _setorController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(labelText: 'UF / Cidade'),
                controller: _ufController,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      32), // Limita o tamanho total a 32 caracteres
                  CustomCpfInputFormatter(), // Utiliza a formatação personalizada
                ],
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Gerar Protocolo Chip?'),
                controller: _chipController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ],
          ),
          actions: [
            if (isLoading)
              CircularProgressIndicator() // Show spinner while loading
            else
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    Navigator.of(context).pop();
                    // isLoading = true; // Start loading
                  });
                  final String subject = _setorController.text;
                  final String description = _ufController.text;
                  final String nome = _nomeController.text;
                  final String cpf = _cpfController.text;
                  final String chip = _chipController.text;
                  _createTicket(subject, description, nome, cpf, chip);
                  setState(() {
                    _setorController.clear();
                    _ufController.clear();
                    _nomeController.clear();
                    _cpfController.clear();
                    _chipController.clear();
                  });
                },
                child: Text('Criar Solicitação'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _createTicket(String subject, String description, String nome,
      String cpf, String chip) async {
    // Obter o usuário atual
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Retorna se o usuário não estiver autenticado
    }

    // Obter o UID do usuário

    // Referência ao documento de chamados usando o UID do usuário
    DocumentReference ticketRef = FirebaseFirestore.instance
        .collection('tickets')
        .doc(userUID)
        .collection('user_tickets')
        .doc();

    // Dados do chamado a serem salvos
    Map<String, dynamic> ticketData = {
      'subject': subject,
      'description': description,
      'nome': nome,
      'cpf': cpf,
      'chip': chip,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Salvar o chamado no Firestore
    await ticketRef.set(ticketData);
    setState(() {
      hasCreatedTicket = true;
      String idTicket = ticketRef.id;
    });

    // Mostrar uma mensagem de sucesso ou realizar outras ações
    print('Chamado criado com sucesso!');

    // Fechar o diálogo
  }

  void _editTicketDialog(String subject, String description, String nome,
      String cpf, String chip, String idTicket) {
    DocumentReference ticketRef = FirebaseFirestore.instance
        .collection('tickets')
        .doc(userUID)
        .collection('user_tickets')
        .doc();

    _setorController.text = subject;
    _ufController.text = description;
    _nomeController.text = nome;
    _cpfController.text = cpf;
    _chipController.text = chip;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Chamado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nome Completo'),
                controller: _nomeController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cpf'),
                controller: _cpfController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      14), // 11 digits + 2 dots + 1 hyphen
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(), // Custom formatter for CPF
                ],
              ),
              TextField(
                controller: _setorController,
                decoration: InputDecoration(labelText: 'Setor'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _ufController,
                decoration: InputDecoration(labelText: 'UF / Cidade'),
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(32),
                  CustomCpfInputFormatter(),
                ],
              ),
              TextField(
                controller: _chipController,
                decoration: InputDecoration(labelText: 'Gerar Protocolo Chip?'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String updateSetor = _setorController.text;
                final String updatedDescription = _ufController.text;
                final String updateNome = _nomeController.text;
                final String updatecpf = _cpfController.text;
                final String updatechip = _chipController.text;
                _updateTicket(updateSetor, updatedDescription, updateNome,
                    updatecpf, updatechip, idTicket);
                setState(() {
                  hasCreatedTicket = false;
                  _setorController.clear();
                  _ufController.clear();
                  _nomeController.clear();
                  _cpfController.clear();
                  _chipController.clear();
                });
                Navigator.of(context).pop();
                // Fecha o diálogo
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearControllers();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _clearControllers() {
    setState(() {
      _setorController.clear();
      _ufController.clear();
      _nomeController.clear();
      _cpfController.clear();
      _chipController.clear();
    });
  }

  void _updateTicket(
      String updateSetor,
      String updatedDescription,
      String updateNome,
      String updatecpf,
      String updatechip,
      String idTicket) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Return if the user is not authenticated
    }

    // Get the reference to the ticket document using the user's UID and the document ID
    DocumentReference ticketRef = FirebaseFirestore.instance
        .collection('tickets')
        .doc(userUID)
        .collection('user_tickets')
        .doc(idTicket); // Use the document ID here

    // Update the ticket data in Firestore
    Map<String, dynamic> updatedTicketData = {
      'subject': updateSetor,
      'description': updatedDescription,
      'nome': updateNome,
      'cpf': updatecpf,
      'chip': updatechip,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Perform the update in Firestore
    await ticketRef.update(updatedTicketData);

    print('Se printou foi pq deu certo essa caralha!');

    // Update the user interface by calling setState
    setState(() {
      selectedTicketId = ''; // Clear the selected ticket ID
      _ticketsStream = FirebaseFirestore.instance
          .collection('tickets')
          .doc(userUID)
          .collection('user_tickets')
          .orderBy('timestamp', descending: true)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(userMessage),
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
                      image: AssetImage('assets/img/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/img/backg.png'),
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
                        color: iconsC,
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
                    setState(() {
                      mostrarsub = !mostrarsub;
                    });
                  },
                ),
                !mostrarsub
                    ? ListTile(
                        contentPadding: EdgeInsets.only(
                            left:
                                25), // Remove o espaçamento padrão do ListTile
                        title: Row(
                          children: [
                            Icon(Icons.check, color: Colors.green),
                            SizedBox(
                                width:
                                    5), // Adiciona um espaço entre o ícone e o texto
                            Text(
                              'Chamados abertos',
                              style: TextStyle(
                                  color: iconsColor, fontSize: sizeAdd),
                            ),
                          ],
                        ),
                        onTap: () {},
                      )
                    : Container(),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 15), // Remove o espaçamento padrão do ListTile
                  title: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: iconsC,
                      ),
                      SizedBox(
                          width:
                              8), // Adiciona um espaço entre o ícone e o texto
                      Text(
                        'Configuração',
                        style: TextStyle(color: iconsColor),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      mostrartitulo = !mostrartitulo;
                    });
                  },
                ),
                !mostrartitulo
                    ? ListTile(
                        contentPadding: EdgeInsets.only(
                            left:
                                25), // Remove o espaçamento padrão do ListTile
                        title: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: iconsC,
                            ),
                            SizedBox(
                                width:
                                    5), // Adiciona um espaço entre o ícone e o texto
                            Text(
                              'Sair',
                              style: TextStyle(
                                  color: iconsColor, fontSize: sizeAdd),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                      )
                    : Container()
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
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
                        onTap:
                            _openNewTicketDialog, // Chamando a função ao clicar
                        child: Container(
                          width: 135,
                          height: 38,
                          margin: EdgeInsets.only(
                              right: 18.0, top: 5.0), // Margem para espaçamento
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.amber, // Cor de fundo do container
                            borderRadius: BorderRadius.circular(
                                10.0), // Borda arredondada
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: iconsColor,
                              ), // Ícone de mensagem
                              SizedBox(width: 4.0),
                              Text(
                                'Novo chamado', // Sua mensagem personalizada aqui
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: iconsColor,
                                ),
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
                          fontSize: fontSizeCon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 147,
                      ),
                      Text(
                        'Setor',
                        style: TextStyle(
                          fontSize: fontSizeCon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 173,
                      ),
                      Text(
                        'Divisão',
                        style: TextStyle(
                          fontSize: fontSizeCon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 173,
                      ), // Adiciona espaço flexível proporcional
                      Text(
                        'Data',
                        style: TextStyle(
                          fontSize: fontSizeCon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 195,
                      ), // Adiciona espaço flexível proporcional
                      Text(
                        'Nome',
                        style: TextStyle(
                          fontSize: fontSizeCon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*  SizedBox(
                        width: 160,
                      ), // Adiciona espaço flexível proporcional*/
                      Spacer(),
                      Text(
                        'Editar',
                        style: TextStyle(
                          fontSize: fontSizeCon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tickets')
                        .doc(userUID)
                        .collection('user_tickets')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Text('No data available'),
                        );
                      }

                      List<Widget> ticketWidgets = [];

                      snapshot.data!.docs.forEach((document) {
                        String subject = document['subject'];
                        String description = document['description'];
                        Timestamp? timestamp =
                            document['timestamp'] as Timestamp?;
                        String nome = document['nome'];
                        String cpf = document['cpf'];
                        String chip = document['chip'];

                        if (timestamp != null) {
                          DateTime dateTime = timestamp.toDate();
                          String formattedDate =
                              DateFormat('dd MMM. yyyy').format(dateTime);

                          String documentId =
                              document.id; // Get the document ID

                          Widget ticketWidget = GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTicketId =
                                    documentId; // Set the selected ticket ID
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 18.0, right: 18.0, bottom: 1),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Text(
                                    'Setor $subject',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Text(
                                    '$div',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Text(
                                    '$formattedDate',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Text(
                                    '$nome',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _editTicketDialog(subject, description,
                                          nome, cpf, chip, documentId);
                                    },
                                    child: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ),
                          );

                          ticketWidgets.add(ticketWidget);
                        }
                      });

                      if (ticketWidgets.isEmpty && !hasCreatedTicket) {
                        return Center(
                          child: Text('Não há chamados'),
                        );
                      } else {
                        return ListView(
                          children: ticketWidgets,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
