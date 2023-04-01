import 'package:flutter/material.dart';

class Blog {
  final String title;
  final String description;
  final String image;
  final String url;
  final String shortoverview;

  Blog(
      {required this.title,
      required this.description,
      required this.image,
      required this.url,
      required this.shortoverview});
}

List<Blog> blogList = [
  Blog(
      title: 'Flutter',
      shortoverview:
          'Flutter is an open-source UI software development kit created by Google.',
      description:
          'Flutter is an open-source UI software development kit created by Google. It is used to develop applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia, and the web from a single codebase. AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://flutter.dev/'),
  Blog(
      title: 'Dart',
      shortoverview:
          'Dart is a client-optimized programming language for apps on multiple platforms.',
      description:
          'Dart is a client-optimized programming language for apps on multiple platforms. It is developed by Google and is used to build mobile, desktop, server, and web applications. Dart is an object-oriented, class-based, garbage-collected language with C-style syntax. Dart can compile to either native code or JavaScript.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://dart.dev/'),
  Blog(
      title: 'Firebase',
      shortoverview:
          'Firebase is a Backend-as-a-Service (BaaS) app development platform developed by Firebase, Inc. in 2011, then acquired by Google in 2014.',
      description:
          'Firebase is a Backend-as-a-Service (BaaS) app development platform developed by Firebase, Inc. in 2011, then acquired by Google in 2014. It provides developers with a set of tools and services to develop their app, grow their user base, and earn money.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://firebase.google.com/'),
  Blog(
      title: 'GetX',
      shortoverview:
          'GetX is an extra-light and powerful solution for Flutter.',
      description:
          'GetX is an extra-light and powerful solution for Flutter. It combines high performance state management, intelligent dependency injection, and route management in a quick and practical way.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://pub.dev/packages/get'),
  Blog(
      title: 'Provider',
      shortoverview:
          'Provider is a wrapper around InheritedWidget to make them easier to use and more reusable.',
      description:
          'Provider is a wrapper around InheritedWidget to make them easier to use and more reusable. It is used for state management in Flutter. It is a wrapper around InheritedWidget to make them easier to use and more reusable. It is used for state management in Flutter.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://pub.dev/packages/provider'),
  Blog(
      title: 'Bloc',
      shortoverview:
          'Bloc is a predictable state management library that helps implement the BLoC design pattern.',
      description:
          'Bloc is a predictable state management library that helps implement the BLoC design pattern. It is used for state management in Flutter. It is a wrapper around InheritedWidget to make them easier to use and more reusable. It is used for state management in Flutter.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://pub.dev/packages/flutter_bloc'),
  Blog(
      title: 'MobX',
      shortoverview:
          'MobX is a state management library that makes it simple to connect the reactive data of your application to the UI.',
      description:
          'MobX is a state management library that makes it simple to connect the reactive data of your application to the UI. It is used for state management in Flutter. It is a wrapper around InheritedWidget to make them easier to use and more reusable. It is used for state management in Flutter.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://pub.dev/packages/mobx'),
  Blog(
      title: 'Riverpod',
      shortoverview:
          'Riverpod is a state management library that makes it simple to connect the reactive data of your application to the UI.',
      description:
          'Riverpod is a state management library that makes it simple to connect the reactive data of your application to the UI. It is used for state management in Flutter. It is a wrapper around InheritedWidget to make them easier to use and more reusable. It is used for state management in Flutter.',
      image: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
      url: 'https://pub.dev/packages/riverpod'),
];
