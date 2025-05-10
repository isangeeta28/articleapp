import 'package:articleapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/article/article_bloc.dart';
import 'blocs/article/article_event.dart';
import 'repositories/article_repository.dart';

void main() {
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ArticleRepository repository = ArticleRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles App',
      home: BlocProvider(
        create: (_) => ArticleBloc(repository)..add(FetchArticles()),
        child: HomeScreen(),
      ),
    );
  }
}

