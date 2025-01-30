import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  late List<Map<String, String>> _recipes;
  bool _isLoading = true;

  final Map<String, String> _recipeVideoIds = {
    'Vegetable Stir Fry': 'deoawaSi5Xs',
    'Fruit Smoothie': '4wX3iSmD5cI',
    'Quinoa Salad': 'QwE4UZ2vukE',
    'Lentil Soup': 'oi-dcSkR-FQ',
    'Baked Salmon': '2uYoqclu6so',
    'Vegetarian Chili': 'oy1u49dLgaE',
    'Greek Yogurt Parfait': '6rglgwP-r50',
    'Spinach and Mushroom Omelette': 'FLwB5r68iO8',
    'Roasted Vegetable Medley': 'GTqZg-JIhA4',
    'Whole Grain Pasta Primavera': 'j1hAAcPay1w',
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _recipes = _generateRecipes();
      _isLoading = false;
    });
  }

  List<Map<String, String>> _generateRecipes() {
    return _recipeVideoIds.keys
        .map((name) => {'name': name, 'videoId': _recipeVideoIds[name]!})
        .toList();
  }

  Widget _buildRecipesGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          String title = _recipes[index]['name']!;
          String videoId = _recipes[index]['videoId']!;
          String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeVideoScreen(
                    title: title,
                    videoId: videoId,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildRecipesGrid(),
    );
  }
}

class RecipeVideoScreen extends StatelessWidget {
  final String title;
  final String videoId;

  const RecipeVideoScreen(
      {Key? key, required this.title, required this.videoId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
