import 'package:flutter/material.dart';

class UserPlace {
  final String name;
  final String username;
  final String email;

  UserPlace({
    required this.name,
    required this.username,
    required this.email,
  });
}

List<UserPlace> userList = [
  UserPlace(
    username: 'Flutter',
    name: 'Flutter1',
    email: 'flutter@gmail.com',
  ),
  UserPlace(
    username: 'Alfredo1',
    name: 'Alfredo',
    email: 'alfredo@gmail.com',
  ),
  UserPlace(
    username: 'Óscar1',
    name: 'Óscar',
    email: 'oscar@gmail.com',
  ),
  UserPlace(
    username: 'Flutter2',
    name: 'Flutter',
    email: 'flutter2@gmail.com',
  ),
  UserPlace(
    username: 'Mario1',
    name: 'Mario',
    email: 'mario@gmail.com',
  ),
  UserPlace(
    username: 'Franlin1',
    name: 'Franlin',
    email: 'franlin@gmail.com',
  ),
  UserPlace(
    username: 'Esther1',
    name: 'Esther',
    email: 'esther@gmail.com',
  ),
  UserPlace(
    username: 'Flutter3',
    name: 'Flutter',
    email: 'flutter3@gmail.com',
  ),
];
