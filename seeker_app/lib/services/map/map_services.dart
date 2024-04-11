import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  final Location location = Location();

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Vérifie si le service de localisation est activé.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Demande l'activation du service de localisation.
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Vérifie si les permissions de localisation sont accordées.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // Demande la permission de localisation.
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // Obtient la localisation actuelle de l'utilisateur.
    locationData = await location.getLocation();
    return LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
  }
}
