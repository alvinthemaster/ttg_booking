import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/resort_provider.dart';
import '../models/resort.dart';
import '../widgets/resort_card.dart';
import 'resort_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Resorts'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              if (favoriteProvider.favoriteResortIds.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () => _showClearAllDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer2<FavoriteProvider, ResortProvider>(
        builder: (context, favoriteProvider, resortProvider, child) {
          final favoriteIds = favoriteProvider.favoriteResortIds;
          
          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Favorites Yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Start adding resorts to your favorites by tapping the heart icon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to home tab
                      Navigator.of(context).pop();
                    },
                    child: const Text('Explore Resorts'),
                  ),
                ],
              ),
            );
          }

          final favoriteResorts = favoriteIds
              .map((id) => resortProvider.getResortById(id))
              .where((resort) => resort != null)
              .cast<Resort>()
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteResorts.length,
            itemBuilder: (context, index) {
              final resort = favoriteResorts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ResortCard(
                  resort: resort,
                  onTap: () => _navigateToResortDetail(context, resort),
                  showRemoveButton: true,
                  onRemove: () => favoriteProvider.removeFavorite(resort.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToResortDetail(BuildContext context, Resort resort) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResortDetailScreen(resort: resort),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Favorites'),
          content: const Text('Are you sure you want to remove all resorts from your favorites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<FavoriteProvider>().clearFavorites();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}