import 'package:geolocator/geolocator.dart';


class LocationHelper {

  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {

      return false;
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }



  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }


    bool granted = await requestPermission();
    if (!granted) {
      throw Exception('Location permission not granted');
    }


    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
