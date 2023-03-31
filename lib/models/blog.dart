import 'package:flutter/material.dart';

class Blog {
  final String title;
  final String description;
  final String image;
  final String url;

  Blog(
      {required this.title,
      required this.description,
      required this.image,
      required this.url});
}

List<Blog> blogList = [
  Blog(
      title: 'Flutter',
      description:
          'Flutter is an open-source UI software development kit created by Google. It is used to develop applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia, and the web from a single codebase.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://flutter.dev/'),
  Blog(
      title: 'Dart',
      description:
          'Dart is a client-optimized programming language for apps on multiple platforms. It is developed by Google and is used to build mobile, desktop, server, and web applications. Dart is an object-oriented, class-based, garbage-collected language with C-style syntax. Dart can compile to either native code or JavaScript.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://dart.dev/'),
  Blog(
      title: 'Firebase',
      description:
          'Firebase is a Backend-as-a-Service (BaaS) app development platform developed by Firebase, Inc. in 2011, then acquired by Google in 2014. It provides developers with a set of tools and services to develop their app, grow their user base, and earn money.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://firebase.google.com/'),
];
