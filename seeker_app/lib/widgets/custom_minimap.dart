import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MiniMap extends StatelessWidget {
  final LatLng position;
  final double zoom;

  MiniMap({Key? key, required this.position, this.zoom = 13.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: position,
        initialZoom: zoom,
        interactiveFlags:
            InteractiveFlag.none, // Disable map interactions if needed
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 30.0,
              height: 30.0,
              point: position,
              child: Icon(Icons.location_on, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
