import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RecyclingCentersMap extends StatefulWidget {
  @override
  _RecyclingCentersMapState createState() => _RecyclingCentersMapState();
}

class _RecyclingCentersMapState extends State<RecyclingCentersMap> {
  late GoogleMapController mapController;
  List<Map<String, dynamic>> recyclingCenters = [];
  bool isLoading = true;
  String errorMessage = '';

  final LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Center of India
  final String googleApiKey = "AIzaSyDHGQdZDvI6PgUFChmZnss-Qp5wMaPOPyY"; // Replace with your Google API key

  List<String> cities = [
    // Metro Cities
    "Mumbai",
  ];


  @override
  void initState() {
    super.initState();
    fetchRecyclingCenters();
  }

  Future<void> fetchRecyclingCenters() async {
    setState(() {
      isLoading = true;
      recyclingCenters = [];
      errorMessage = '';
    });

    try {
      List<Map<String, dynamic>> allCenters = [];

      for (String city in cities) {
        final Uri placesUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=e-waste+recycling+center+in+$city&key=$googleApiKey",
        );

        final response = await http.get(placesUrl);
        print("API Response for $city: ${response.body}");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data["results"] != null && data["results"].isNotEmpty) {
            final List places = data["results"];
            allCenters.addAll(places.map((place) {
              final location = place["geometry"]["location"];
              return {
                "name": place["name"] ?? "Unknown Recycling Center",
                "latLng": LatLng(location["lat"], location["lng"]),
                "address": place["formatted_address"] ?? "No Address Available",
                "isOpen": place["opening_hours"]?["open_now"] ?? false,
              };
            }).toList());
          }
        } else {
          throw Exception("Failed to load data for $city: ${response.statusCode}");
        }
      }

      setState(() {
        recyclingCenters = allCenters;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        errorMessage = "Failed to load data. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Waste Recycling Centers in India'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchRecyclingCenters,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition:
              CameraPosition(target: _initialPosition, zoom: 5),
              markers: recyclingCenters.map((center) {
                return Marker(
                  markerId: MarkerId(center['name']),
                  position: center['latLng'],
                  infoWindow: InfoWindow(
                    title: center['name'],
                    snippet: center['address'],
                  ),
                );
              }).toSet(),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: recyclingCenters.length,
              itemBuilder: (context, index) {
                final center = recyclingCenters[index];
                return buildRecyclingCenterCard(
                  name: center['name'],
                  address: center['address'],
                  isOpen: center['isOpen'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecyclingCenterCard({
    required String name,
    required String address,
    required bool isOpen,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(address, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOpen ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isOpen ? 'Open' : 'Closed',
                style: TextStyle(
                  color: isOpen ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
