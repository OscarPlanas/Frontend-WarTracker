import 'package:flutter/material.dart';

class TournamentsPlace {
  final String title;
  final String description;
  final String image;
  final String date;
  final String time;
  final String location;
  final String prize;
  final String entryFee;
  final String rules;
  final String owner;

  TournamentsPlace({
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.time,
    required this.location,
    required this.prize,
    required this.entryFee,
    required this.rules,
    required this.owner,
  });
}

List<TournamentsPlace> tournamentsList = [
  TournamentsPlace(
    title: 'Tournament 1',
    description: 'Description 1',
    image: 'https://picsum.photos/250?image=9',
    date: '2021-09-01',
    time: '12:00',
    location: 'Location 1',
    prize: 'Prize 1',
    entryFee: 'Entry Fee 1',
    rules: 'Rules 1',
    owner: 'Owner 1',
  ),
  TournamentsPlace(
    title: 'Tournament 2',
    description: 'Description 2',
    image:
        'https://static.wikia.nocookie.net/esstarwars/images/7/72/BabyYoda-Alzmann.png/revision/latest?cb=20191201014443',
    date: '2023-10-21',
    time: '09:00',
    location: 'Location 2',
    prize: 'Prize 2',
    entryFee: 'Entry Fee 2',
    rules: 'Rules 2',
    owner: 'Owner 2',
  ),
  TournamentsPlace(
    title: 'Tournament 3',
    description: 'Description 3',
    image:
        'https://static.wikia.nocookie.net/esstarwars/images/7/72/BabyYoda-Alzmann.png/revision/latest?cb=20191201014443',
    date: '2023-10-21',
    time: '09:00',
    location: 'Location 3',
    prize: 'Prize 3',
    entryFee: 'Entry Fee 3',
    rules: 'Rules 3',
    owner: 'Owner 3',
  ),
];
