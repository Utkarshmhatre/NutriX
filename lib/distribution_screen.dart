import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DistributionScreen extends StatefulWidget {
  const DistributionScreen({Key? key}) : super(key: key);

  @override
  State<DistributionScreen> createState() => _DistributionScreenState();
}

class _DistributionScreenState extends State<DistributionScreen> {
  final MapController _mapController = MapController();
  final LatLng _center = LatLng(45.521563, -122.677433);
  List<LatLng> _routePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribution Network'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _center,
          zoom: 11.0,
          onTap: _handleMapTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _routePoints
                .map((point) => Marker(
                      width: 80.0,
                      height: 80.0,
                      point: point,
                      builder: (ctx) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child:
                            const Icon(Icons.location_on, color: Colors.white),
                      ),
                    ))
                .toList(),
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 4.0,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _optimizeRoute,
            child: const Icon(Icons.route),
            heroTag: 'optimize',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _clearRoute,
            child: const Icon(Icons.clear),
            heroTag: 'clear',
          ),
        ],
      ),
    );
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _routePoints.add(point);
    });
  }

  void _optimizeRoute() {
    if (_routePoints.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Add at least two points to optimize the route')),
      );
      return;
    }

    // This is a simple optimization that just orders the points
    // In a real app, you'd use a more sophisticated algorithm
    setState(() {
      _routePoints.sort((a, b) => a.latitude.compareTo(b.latitude));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route optimized!')),
    );
  }

  void _clearRoute() {
    setState(() {
      _routePoints.clear();
    });
  }
}
