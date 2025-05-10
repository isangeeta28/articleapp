import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/article/article_bloc.dart';
import '../blocs/article/article_event.dart';
import '../blocs/article/article_state.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Articles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ArticleBloc>(context),
                  child: const FavoritesScreen(),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => context.read<ArticleBloc>().add(SearchArticles(val)),
              decoration: InputDecoration(
                hintText: 'Search for articles...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleError) {
            return Center(child: Text(state.message));
          } else if (state is ArticleLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<ArticleBloc>().add(RefreshArticles()),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: state.articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final article = state.articles[i];
                  final isFavorite = state.favorites.contains(article.id);

                  return ArticleCard(
                    article: article,
                    isFavorite: isFavorite,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(article: article),
                      ),
                    ),
                    onFavoriteToggle: () => context.read<ArticleBloc>().add(ToggleFavorite(article.id)),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}