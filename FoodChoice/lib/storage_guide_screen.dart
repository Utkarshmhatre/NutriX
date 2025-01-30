import 'package:flutter/material.dart';

class StorageGuideScreen extends StatefulWidget {
  const StorageGuideScreen({Key? key}) : super(key: key);

  @override
  _StorageGuideScreenState createState() => _StorageGuideScreenState();
}

class _StorageGuideScreenState extends State<StorageGuideScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getImageUrl(String category) {
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
        return 'https://via.placeholder.com/150';
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
            childAspectRatio: 0.7,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Guide')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildStorageGuide(),
    );
  }
}