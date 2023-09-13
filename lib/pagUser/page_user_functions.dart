import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:your_project_name/pagUser/classes.dart';

void _openNewTicketDialog(
    BuildContext context,
    TextEditingController _nomeController,
    TextEditingController _cpfController,
    TextEditingController _setorController,
    TextEditingController _ufController,
    TextEditingController _chipController,
    Function setStateCallback,
    bool isLoading,
    Function createTicketCallback) {
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
                setStateCallback(() {
                  // <-- Use the setStateCallback here
                  Navigator.of(context).pop();
                  // isLoading = true; // Start loading
                });
                final String subject = _setorController.text;
                final String description = _ufController.text;
                final String nome = _nomeController.text;
                final String cpf = _cpfController.text;
                final String chip = _chipController.text;
                // _createTicket(subject, description, nome, cpf, chip); <- you can replace this with createTicketCallback
                setStateCallback(() {
                  // <-- Use the setStateCallback again here
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
