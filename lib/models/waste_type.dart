import 'package:flutter/material.dart';

enum WasteType {
  mixed('ZMIESZANE', Colors.black),
  paper('PAPIER', Color.fromRGBO(0, 86, 157, 1)),
  glass('SZKŁO', Color.fromRGBO(70, 180, 11, 1)),
  metal('METALE I TWORZYWA SZTUCZNE', Color.fromRGBO(251, 174, 23, 1)),
  bio('BIO', Color.fromRGBO(162, 118, 78, 1)),
  ash('POPIÓŁ', Color.fromRGBO(128, 128, 128, 1)),
  bulky('GABARYTY', Color.fromRGBO(128, 0, 128, 1)),
  green('ODPADY ZIELONE', Color.fromRGBO(34, 139, 34, 1)),
  elektro('ELEKTRO', Color.fromRGBO(0, 100, 200, 1)),
  opony('OPONY', Color.fromRGBO(139, 69, 19, 1));

  const WasteType(this.displayName, this.color);

  final String displayName;
  final Color color;
}
