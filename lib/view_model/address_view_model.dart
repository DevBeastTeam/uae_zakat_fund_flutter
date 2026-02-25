import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/utils.dart';

class AddressViewModel extends GetxController {

  final streetName = TextEditingController();
  final buildingName = TextEditingController();
  final nearestLandMark = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final Completer<GoogleMapController> completer = Completer();
  final RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  final Rx<CameraPosition> cameraPosition = const CameraPosition(
    target: LatLng(25.2048, 55.2708),
    zoom: 14.0,
  ).obs;

  LatLng currentLatLng = const LatLng(25.2048, 55.2708);
  Timer? _debounceTimer;

  int markerIdCounter = 0;
  late int userId;
  Address? updatedAddress;

  LatLng currentLtLng = LatLng(25.2048, 55.2708);

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {

    final user = userBox.isNotEmpty ? userBox.getAt(0) : null;
    userId = user?.id ?? 0;
    updateMarker();
    getCurrentLocation();
  }

  setData(Address address) {
    updatedAddress = address;
    currentLtLng = LatLng(address.latitude, address.longitude);
    streetName.text = address.street;
    buildingName.text = address.building;
    nearestLandMark.text = address.landmark;
    updateMarker(fromSet: true);
  }

  String markerIdVal({bool increment = false}) {
    String val = 'marker_id_$markerIdCounter';
    if (increment) markerIdCounter++;
    return val;
  }

  void onMapCreated(GoogleMapController controller) => completer.complete(controller);

  void onCameraMove(CameraPosition position) {
    if (markers.isNotEmpty) {
      MarkerId markerId = MarkerId(markerIdVal());
      Marker? marker = markers[markerId];
      Marker updatedMarker = marker!.copyWith(
        positionParam: position.target,
      );
      markers[markerId] = updatedMarker;
      markers.refresh();
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        currentLtLng = position.target;
        getAddressFromLatLng();
      });
    }
  }

  getAddressFromLatLng() async {
    await placemarkFromCoordinates(
            currentLtLng.latitude, currentLtLng.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks.first;
      String address = "${place.street}";
      streetName.text = address;
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Utils.showGlobalSnackBar(
          message: 'Location services are disabled. Please enable the services');
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utils.showGlobalSnackBar(message: 'Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Utils.showGlobalSnackBar(
          message: 'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    currentLtLng = LatLng(position.latitude, position.longitude);
    if (updatedAddress != null) updateMarker();
  }

  updateMarker({bool fromSet = false}) async {
    MarkerId markerId = MarkerId(markerIdVal());
    Marker marker = Marker(
      markerId: markerId,
      position: currentLtLng,
      draggable: false,
    );
    markers[markerId] = marker;
    markers.refresh();
    GoogleMapController controller = await completer.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLtLng,
          zoom: 14.0,
        ),
      ),
    );
    if (!fromSet) getAddressFromLatLng();
  }

  addAddress() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    Address address = Address(
        userId: userId,
        id: updatedAddress != null ? updatedAddress!.id : 0,
        addressType: updatedAddress != null ? updatedAddress!.addressType : 0,
        street: streetName.text,
        building: buildingName.text,
        landmark: nearestLandMark.text,
        isDefault: updatedAddress != null ? updatedAddress!.isDefault : false,
        latitude: currentLtLng.latitude,
        longitude: currentLtLng.longitude);
    Get.back(result: address);
  }

  @override
  void onClose() {
    streetName.dispose();
    buildingName.dispose();
    nearestLandMark.dispose();

    _debounceTimer?.cancel();

    markers.close();
    cameraPosition.close();

    super.onClose();
  }

}
