import 'package:flutter/material.dart';

class SustainabilityScreen extends StatefulWidget {
  const SustainabilityScreen({Key? key}) : super(key: key);

  @override
  _SustainabilityScreenState createState() => _SustainabilityScreenState();
}

class _SustainabilityScreenState extends State<SustainabilityScreen> {
  late List<Map<String, String>> _sustainabilityTips;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      _sustainabilityTips = _generateSustainabilityTips();
      _isLoading = false;
    });
  }

  List<Map<String, String>> _generateSustainabilityTips() {
    return [
      {
        'title': 'Reduce Food Waste',
        'description': 'Plan meals, use leftovers creatively, and compost scraps'
      },
      {
        'title': 'Choose Seasonal Produce',
        'description': 'Buy fruits and vegetables that are in season for better taste and lower environmental impact'
      },
      {
        'title': 'Eat More Plant-Based Meals',
        'description': 'Incorporate more vegetables, fruits, and whole grains into your diet'
      },
      {
        "title": "Use Reusable Bags",
        "description": "Carry reusable shopping bags to reduce plastic waste"
      },
      {
        "title": "Opt for Sustainable Seafood",
        "description": "Choose seafood certified by organizations like the MSC or ASC"
      },
      {
        "title": "Reduce Single-Use Plastics",
        "description": "Use reusable bottles, cutlery, and straws to minimize plastic waste"
      },
      {
        "title": "Buy in Bulk",
        "description": "Purchase food and household items in bulk to reduce packaging waste"
      },
      {
        "title": "Support Local Farmers",
        "description": "Buy from farmers' markets to support local agriculture and reduce transportation emissions"
      },
      {
        "title": "Compost Organic Waste",
        "description": "Turn food scraps and yard waste into nutrient-rich compost"
      },
      {
        "title": "Conserve Water",
        "description": "Fix leaks, take shorter showers, and use water-efficient appliances"
      },
      {
        "title": "Switch to LED Bulbs",
        "description": "Use energy-efficient lighting to reduce electricity consumption"
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
        "description": "Reduce carbon emissions by taking buses, trains, or carpooling"
      },
      {
        "title": "Walk or Bike More",
        "description": "Use walking or cycling for short trips instead of driving"
      },
      {
        "title": "Repair Instead of Replacing",
        "description": "Fix broken items instead of throwing them away"
      },
      {
        "title": "Recycle Properly",
        "description": "Sort and dispose of recyclables according to local guidelines"
      },
      {
        "title": "Avoid Fast Fashion",
        "description": "Choose quality, sustainable clothing over cheap, disposable fashion"
      },
      {
        "title": "Wash Clothes in Cold Water",
        "description": "Save energy by using cold water when doing laundry"
      },
      {
        "title": "Air-Dry Clothes",
        "description": "Reduce electricity use by drying clothes on a line or rack"
      },
      {
        "title": "Use Eco-Friendly Cleaning Products",
        "description": "Choose non-toxic, biodegradable cleaners"
      },
      {
        "title": "Switch to a Refillable Water Bottle",
        "description": "Avoid single-use plastic bottles by using a reusable one"
      },
      {
        "title": "Grow Your Own Food",
        "description": "Plant a home garden to reduce reliance on store-bought produce"
      },
      {
        "title": "Support Ethical Brands",
        "description": "Buy from companies that prioritize sustainability and fair labor practices"
      },
      {
        "title": "Use Cloth Napkins",
        "description": "Replace disposable paper napkins with reusable fabric ones"
      },
      {
        "title": "Donate Unused Items",
        "description": "Give clothes, electronics, and furniture a second life by donating them"
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
        "description": "Opt for bamboo over plastic or wood for a more sustainable choice"
      },
      {
        "title": "Bring Your Own Cup",
        "description": "Bring your own cup to coffee shops to cut down on waste"
      },
      {
        "title": "Collect Rainwater",
        "description": "Collect rainwater for gardening and outdoor use"
      },
      {
        "title": "Charge with Solar Energy",
        "description": "Charge gadgets with solar energy when possible"
      },
      {
        "title": "Use Reusable Diapers",
        "description": "Reduce waste by using reusable diapers for babies"
      },
      {
        "title": "Support Ethical Farming",
        "description": "Support ethical labor practices and sustainable farming"
      },
      {
        "title": "Use Stairs",
        "description": "Save energy by using stairs instead of elevators"
      },
      {
        "title": "Choose Recycled Toilet Paper",
        "description": "Choose recycled or bamboo toilet paper to save trees"
      },
    ];
  }

  Widget _buildSustainabilityTips() {
    return ListView.builder(
      itemCount: _sustainabilityTips.length,
      itemBuilder: (context, index) {
        final tip = _sustainabilityTips[index];
        return ListTile(
          leading: const Icon(Icons.eco),
          title: Text(tip['title']!),
          subtitle: Text(tip['description']!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sustainability')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSustainabilityTips(),
    );
  }
}