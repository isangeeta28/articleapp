import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/article/article_bloc.dart';
import '../blocs/article/article_event.dart';
import '../blocs/article/article_state.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoaded) {
            final favArticles = state.articles.where((a) => state.favorites.contains(a.id)).toList();

            if (favArticles.isEmpty) {
              return const Center(child: Text('No favorites yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favArticles.length,
              itemBuilder: (_, i) => ArticleCard(
                article: favArticles[i],
                isFavorite: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(article: favArticles[i]),
                  ),
                ),
                onFavoriteToggle: () => context.read<ArticleBloc>().add(ToggleFavorite(favArticles[i].id)),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
