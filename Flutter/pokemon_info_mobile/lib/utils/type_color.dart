import 'package:flutter/material.dart';

typeColor(String type) {
  switch (type) {
    case 'bug':
      return Color(0xFF91A119);
    case 'dark':
      return Color(0xFF624D4E);
    case 'dragon':
      return Color(0xFF5060E1);
    case 'electric':
      return Color(0xFFFAC000);
    case 'fairy':
      return Color(0xFFEF70EF);
    case 'fighting':
      return Color(0xFFA65300);
    case 'fire':
      return Color(0xFFE62829);
    case 'flying':
      return Color(0xFF81B9EF);
    case 'ghost':
      return Color(0xFF704170);
    case 'grass':
      return Color(0xFF3FA129);
    case 'ground':
      return Color(0xFF915121);
    case 'ice':
      return Color(0xFF3DCEF3);
    case 'normal':
      return Color(0xFF9FA19F);
    case 'poison':
      return Color(0xFF9141CB);
    case 'psychic':
      return Color(0xFFEF4179);
    case 'rock':
      return Color(0xFFAFA981);
    case 'steel':
      return Color(0xFF60A1B8);
    case 'water':
      return Color(0xFF2980EF);
    default:
      return Color(0xFFFFFFFF); // Default white if no type matches
  }
}
