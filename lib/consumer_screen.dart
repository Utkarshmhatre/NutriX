import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ConsumerScreen extends StatefulWidget {
  const ConsumerScreen({Key? key}) : super(key: key);

  @override
  _ConsumerScreenState createState() => _ConsumerScreenState();
}

class _ConsumerScreenState extends State<ConsumerScreen> {
  late List<Map<String, String>> _recipes;
  late List<Map<String, String>> _sustainabilityTips;
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
    setState(() {
      _recipes = _generateRecipes();
      _sustainabilityTips = _generateSustainabilityTips();
      _isLoading = false;
    });
  }

  List<Map<String, String>> _generateRecipes() {
    return _recipeVideoIds.keys
        .map((name) => {'name': name, 'videoId': _recipeVideoIds[name]!})
        .toList();
  }

  List<Map<String, String>> _generateSustainabilityTips() {
    return [
      {
        'title': 'Reduce Food Waste',
        'description':
            'Plan meals, use leftovers creatively, and compost scraps'
      },
      {
        'title': 'Choose Seasonal Produce',
        'description':
            'Buy fruits and vegetables that are in season for better taste and lower environmental impact'
      },
      {
        'title': 'Eat More Plant-Based Meals',
        'description':
            'Incorporate more vegetables, fruits, and whole grains into your diet'
      },
      {
        "title": "Use Reusable Bags",
        "description": "Carry reusable shopping bags to reduce plastic waste"
      },
      {
        "title": "Opt for Sustainable Seafood",
        "description":
            "Choose seafood certified by organizations like the MSC or ASC"
      },
      {
        "title": "Reduce Single-Use Plastics",
        "description":
            "Use reusable bottles, cutlery, and straws to minimize plastic waste"
      },
      {
        "title": "Buy in Bulk",
        "description":
            "Purchase food and household items in bulk to reduce packaging waste"
      },
      {
        "title": "Support Local Farmers",
        "description":
            "Buy from farmers' markets to support local agriculture and reduce transportation emissions"
      },
      {
        "title": "Compost Organic Waste",
        "description":
            "Turn food scraps and yard waste into nutrient-rich compost"
      },
      {
        "title": "Conserve Water",
        "description":
            "Fix leaks, take shorter showers, and use water-efficient appliances"
      },
      {
        "title": "Switch to LED Bulbs",
        "description":
            "Use energy-efficient lighting to reduce electricity consumption"
      },
      {
        "title": "Unplug Devices",
        "description": "Turn off electronics when not in use to save energy"
      },
      {
        "title": "Choose Renewable Energy",
        "description": "Switch to solar or wind power if possible"
      },
      {
        "title": "Use Public Transport",
        "description":
            "Reduce carbon emissions by taking buses, trains, or carpooling"
      },
      {
        "title": "Walk or Bike More",
        "description":
            "Use walking or cycling for short trips instead of driving"
      },
      {
        "title": "Repair Instead of Replacing",
        "description": "Fix broken items instead of throwing them away"
      },
      {
        "title": "Recycle Properly",
        "description":
            "Sort and dispose of recyclables according to local guidelines"
      },
      {
        "title": "Avoid Fast Fashion",
        "description":
            "Choose quality, sustainable clothing over cheap, disposable fashion"
      },
      {
        "title": "Wash Clothes in Cold Water",
        "description": "Save energy by using cold water when doing laundry"
      },
      {
        "title": "Air-Dry Clothes",
        "description":
            "Reduce electricity use by drying clothes on a line or rack"
      },
      {
        "title": "Use Eco-Friendly Cleaning Products",
        "description": "Choose non-toxic, biodegradable cleaners"
      },
      {
        "title": "Switch to a Refillable Water Bottle",
        "description":
            "Avoid single-use plastic bottles by using a reusable one"
      },
      {
        "title": "Grow Your Own Food",
        "description":
            "Plant a home garden to reduce reliance on store-bought produce"
      },
      {
        "title": "Support Ethical Brands",
        "description":
            "Buy from companies that prioritize sustainability and fair labor practices"
      },
      {
        "title": "Use Cloth Napkins",
        "description":
            "Replace disposable paper napkins with reusable fabric ones"
      },
      {
        "title": "Donate Unused Items",
        "description":
            "Give clothes, electronics, and furniture a second life by donating them"
      },
      {
        "title": "Use a Programmable Thermostat",
        "description": "Optimize heating and cooling to save energy"
      },
      {
        "title": "Install Low-Flow Fixtures",
        "description": "Reduce water use with low-flow showerheads and faucets"
      },
      {
        "title": "Reduce Paper Use",
        "description": "Go paperless with bills and digital documents"
      },
      {
        "title": "Choose Bamboo Products",
        "description":
            "Opt for bamboo over plastic or wood for a more sustainable choice"
      },
      {
        "title": "Cook at Home More Often",
        "description":
            "Reduce packaging waste and food miles by preparing meals at home"
      },
      {
        "title": "Use a Reusable Coffee Cup",
        "description": "Bring your own cup to coffee shops to cut down on waste"
      },
      {
        "title": "Avoid Microplastics",
        "description":
            "Choose personal care products without plastic microbeads"
      },
      {
        "title": "Eat Less Processed Food",
        "description":
            "Reduce packaging and energy use by consuming whole foods"
      },
      {
        "title": "Opt for Digital Receipts",
        "description":
            "Say no to paper receipts to cut down on unnecessary waste"
      },
      {
        "title": "Use a Rain Barrel",
        "description": "Collect rainwater for gardening and outdoor use"
      },
      {
        "title": "Switch to Bar Soap",
        "description":
            "Reduce plastic waste by using bar soap instead of bottled body wash"
      },
      {
        "title": "Buy Second-Hand",
        "description":
            "Shop for used clothing, furniture, and electronics to reduce waste"
      },
      {
        "title": "Adopt a Minimalist Lifestyle",
        "description":
            "Buy only what you need and focus on quality over quantity"
      },
      {
        "title": "Make Your Own Cleaning Supplies",
        "description":
            "Use vinegar, baking soda, and lemon to create natural cleaners"
      },
      {
        "title": "Use Solar-Powered Devices",
        "description": "Charge gadgets with solar energy when possible"
      },
      {
        "title": "Avoid Palm Oil",
        "description":
            "Check labels to ensure products don't contribute to deforestation"
      },
      {
        "title": "Use Cloth Diapers",
        "description": "Reduce waste by using reusable diapers for babies"
      },
      {
        "title": "Buy Fair Trade Products",
        "description": "Support ethical labor practices and sustainable farming"
      },
      {
        "title": "Take the Stairs",
        "description": "Save energy by using stairs instead of elevators"
      },
      {
        "title": "Use Eco-Friendly Toilet Paper",
        "description": "Choose recycled or bamboo toilet paper to save trees"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Consumer Engagement'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.food_bank), text: 'Storage Guide'),
              Tab(icon: Icon(Icons.restaurant), text: 'Recipes'),
              Tab(icon: Icon(Icons.eco), text: 'Sustainability'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildStorageGuide(),
                  _buildRecipesGrid(),
                  _buildSustainabilityTips(),
                ],
              ),
      ),
    );
  }

  String _getImageUrl(String category) {
    // In a real app, you would replace these with actual image URLs
    // Currently using placeholder images with different dimensions for each category
    switch (category.toLowerCase()) {
      case 'fruits':
        return 'https://nurserylive.com/cdn/shop/articles/assortment-of-colorful-ripe-tropical-fruits-top-royalty-free-image-995518546-1564092355-816049.jpg?v=1679747958';
      case 'vegetables':
        return 'https://cdn.britannica.com/17/196817-159-9E487F15/vegetables.jpg';
      case 'root vegetables':
        return 'https://cdn-prod.medicalnewstoday.com/content/images/articles/280/280579/potatoes-can-be-healthful.jpg';
      case 'bread':
        return 'https://static01.nyt.com/images/2024/10/08/multimedia/13EATrex-LD-briocherex-blfk/13EATrex-LD-briocherex-blfk-jumbo.jpg';
      case 'dairy':
        return 'https://www.dairyfoods.com/ext/resources/DF/2024/Nov/GettyImages-2150650373.jpg?1734040205';
      case 'meat':
        return 'https://packagingguruji.com/wp-content/uploads/2022/09/Old-Non-Veg-Logo.png';
      case 'eggs':
        return 'https://i0.wp.com/post.healthline.com/wp-content/uploads/2020/05/eggs-counter-1296x728-header.jpg?w=1155&h=1528';
      default:
        return 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg';
    }
  }

  Widget _buildStorageGuide() {
    final List<Map<String, String>> storageData = [
      {
        'category': 'Fruits',
        'type': 'Apples, Berries, Citrus',
        'storage': 'Store most fruits in the refrigerator',
        'expiry': '1-2 weeks'
      },
      {
        'category': 'Vegetables',
        'type': 'Carrots, Broccoli, Peppers',
        'storage': 'Keep in the fridge crisper drawer',
        'expiry': '1-2 weeks'
      },
      {
        'category': 'Root Vegetables',
        'type': 'Potatoes, Onions, Garlic',
        'storage': 'Keep in a cool, dark place with ventilation',
        'expiry': '1-2 months'
      },
      {
        'category': 'Bread',
        'type': 'Whole wheat, Sourdough, White',
        'storage': 'Store in a bread box or paper bag at room temperature',
        'expiry': '3-7 days'
      },
      {
        'category': 'Dairy',
        'type': 'Milk, Cheese, Yogurt',
        'storage': 'Keep in the coldest part of the refrigerator',
        'expiry': 'Milk: 1 week, Cheese: 3 weeks'
      },
      {
        'category': 'Meat',
        'type': 'Chicken, Beef, Fish',
        'storage': 'Store on the bottom shelf of the fridge',
        'expiry': '1-3 days (fresh), up to 6 months (frozen)'
      },
      {
        'category': 'Eggs',
        'type': 'Chicken, Duck',
        'storage': 'Keep in the main fridge compartment',
        'expiry': '3-5 weeks'
      }
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // Made cards taller to accommodate images
          ),
          itemCount: storageData.length,
          itemBuilder: (context, index) {
            final item = storageData[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      _getImageUrl(item['category']!),
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Content section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['category']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "🛒 ${item['type']!}",
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "📦 ${item['storage']!}",
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "⏳ Expiry: ${item['expiry']!}",
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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

  Widget _buildSustainabilityTips() {
    return ListView.builder(
      itemCount: _sustainabilityTips.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.eco, color: Colors.green[500]),
            title: Text(_sustainabilityTips[index]['title']!),
            subtitle: Text(_sustainabilityTips[index]['description']!),
          ),
        );
      },
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
