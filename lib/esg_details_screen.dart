import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ESGDetailsScreen extends StatefulWidget {
  const ESGDetailsScreen({Key? key}) : super(key: key);

  @override
  _ESGDetailsScreenState createState() => _ESGDetailsScreenState();
}

class _ESGDetailsScreenState extends State<ESGDetailsScreen> {
  List<Map<String, dynamic>> _esgData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchESGData();
  }

  Future<void> _fetchESGData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _esgData = data.map((user) {
            // Simulating ESG scores using the user data
            return {
              'name': user['company']['name'],
              'environmental_score': (user['id'] * 7 % 100).toString(),
              'social_score': (user['id'] * 5 % 100).toString(),
              'governance_score': (user['id'] * 3 % 100).toString(),
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load ESG data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESG Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchESGData,
              child: _esgData.isEmpty
                  ? const Center(child: Text('No ESG data available'))
                  : ListView.builder(
                      itemCount: _esgData.length,
                      itemBuilder: (context, index) {
                        final item = _esgData[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(
                              item['name'] ?? 'N/A',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildScoreRow('Environmental',
                                    item['environmental_score']),
                                _buildScoreRow('Social', item['social_score']),
                                _buildScoreRow(
                                    'Governance', item['governance_score']),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildScoreRow(String label, String? score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label Score: ',
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(score ?? 'N/A'),
        ],
      ),
    );
  }
}
