import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:your_project_name/PageLogin/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText.length > 11) {
      // Limit the input to 11 digits
      newText = newText.substring(0, 11);
    }

    // Add dots and a hyphen for formatting
    if (newText.length > 9) {
      newText =
          "${newText.substring(0, 3)}.${newText.substring(3, 6)}.${newText.substring(6, 9)}-${newText.substring(9)}";
    } else if (newText.length > 6) {
      newText =
          "${newText.substring(0, 3)}.${newText.substring(3, 6)}.${newText.substring(6)}";
    } else if (newText.length > 3) {
      newText = "${newText.substring(0, 3)}.${newText.substring(3)}";
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CustomCpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText.length >= 2) {
      newText = newText.substring(0, 2).toUpperCase() + newText.substring(2);
    }

    if (newText.length > 29) {
      newText = newText.substring(0, 29);
    }

    if (newText.length > 2 && newText[2] != '/') {
      newText = "${newText.substring(0, 2)}/" + newText.substring(2);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
