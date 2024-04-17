import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:seeker_app/services/map/map_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seeker_app/views/map/marker_detail_screen.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final MapController _mapController = MapController();
  final MapService _markerService = MapService();
  LatLng _currentPosition = LatLng(0, 0);
  List<Marker> userMarkers = [];
  Marker? _tempMarker;
  LatLng? _tempMarkerPosition;

  @override
  void initState() {
    super.initState();
    _fetchUserMarkers();
    _getLocation();
  }

  void _fetchUserMarkers() async {
    var markers = await _markerService.fetchUserMarkers();
    setState(() {
      userMarkers.addAll(markers);
    });
  }

  Future<void> _getLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Les permissions de localisation sont définitivement refusées');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _handleTap(TapPosition position, LatLng latlng) {
    setState(() {
      _tempMarkerPosition = latlng;
      _tempMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        child: Container(
          child: Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      );
    });
  }

  void _addMarkerPermanently() {
    if (_tempMarker != null) {
      setState(() {
        userMarkers.add(
            _tempMarker!); // Ajouter le marqueur temporaire à la liste des marqueurs permanents
        _tempMarker = null; // Réinitialiser le marqueur temporaire
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _tempMarkerPosition != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MarkerDetailScreen(position: _tempMarkerPosition!),
                  ),
                )
                    .then((_) {
                  _addMarkerPermanently(); // Ajoutez le marqueur après le retour de la page de détails
                });
              },
              child: Icon(Icons.edit),
            )
          : null,
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 13.0,
          onTap: _handleTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: userMarkers),
          if (_tempMarker != null) MarkerLayer(markers: [_tempMarker!])
        ],
      ),
    );
  }
}
