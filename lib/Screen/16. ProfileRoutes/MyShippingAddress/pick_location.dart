import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/string.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Providers/user_provider.dart';
import 'package:furniture_shop/Screen/4.%20SupplierHomeScreen/Screen/Components/DashboardScreen.dart';
import 'package:furniture_shop/Widgets/action_button.dart';
import 'package:furniture_shop/Widgets/default_app_bar.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:furniture_shop/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PickLocation extends StatefulWidget {
  PickLocation();

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation>
    with TickerProviderStateMixin {
  MapboxMap? mapboxMap;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;
  int styleIndex = 1;

  ScreenCoordinate? currentCoordinate;
  String? currentLocation;

  late AnimationController animationController;

  ScreenCoordinate? chosenCoordinate;
  String? chosenLocation;

  Location location = new Location();
  LocationData? _locationData;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    initializeLocationAndSave();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void initializeLocationAndSave() async {
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    LocationData _locationData = await _location.getLocation();
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
    currentCoordinate = ScreenCoordinate(
        x: _locationData.longitude!, y: _locationData.latitude!);
    currentLocation = await _reverseGeocoding(currentCoordinate!);
    setState(() {});
  }

  _onMapCreated(MapboxMap controller) async {
    controller.setBounds(CameraBoundsOptions(maxZoom: 20, minZoom: 5));
    controller.location.updateSettings(
        LocationComponentSettings(enabled: true, pulsingEnabled: true));
    controller.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
    });
    this.mapboxMap = controller;
  }

  _moveToCurrentLocation() async {
    final zoom = await mapboxMap?.getCameraState().then((value) => value.zoom);
    mapboxMap?.flyTo(
        CameraOptions(
          zoom: (zoom! < 12) ? 12 : null,
          center: Point(
                  coordinates: Position(
                      sharedPreferences.getDouble('longitude') ?? 0,
                      sharedPreferences.getDouble('latitude') ?? 0))
              .toJson(),
        ),
        MapAnimationOptions(duration: 1, startDelay: 0));
  }

  _onStyleLoadedCallback() async {}

  ///Place a circle annotation onTap and set Chosen location to tapped location
  _onTap(ScreenCoordinate coordinate) async {
    //Somehow coordinate long and lat is reverse?
    chosenCoordinate = ScreenCoordinate(x: coordinate.y, y: coordinate.x);
    //Deleting all existing annotations
    circleAnnotationManager?.deleteAll();
    //Create two overlapping circle annotations showing the tapped location
    circleAnnotationManager?.create(CircleAnnotationOptions(
        geometry: Point(
                coordinates: Position(chosenCoordinate!.x, chosenCoordinate!.y))
            .toJson(),
        circleColor: Colors.white.value,
        circleRadius: 10));
    circleAnnotationManager?.create(CircleAnnotationOptions(
        geometry: Point(
                coordinates: Position(chosenCoordinate!.x, chosenCoordinate!.y))
            .toJson(),
        circleColor: Colors.green.value,
        circleRadius: 6));

    chosenLocation = await _reverseGeocoding(chosenCoordinate!);
    setState(() {});
  }

  Timer? _debounce;

  _onSearchChanged(String query) {
    print(query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      addressSearchResult = await _forwardGeocoding(query);
      setState(() {});
      print('LENGTH: ${addressSearchResult.length}');
    });
  }

  List<Map<String, dynamic>> addressSearchResult = [];

  Future<List<Map<String, dynamic>>> _forwardGeocoding(String query) async {
    final code = AppLocalization.of(context).locale.languageCode;
    print(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${mapBoxSecretToken}&language=${code}'));
    final reponse = await http.get(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${mapBoxSecretToken}&language=${code}'));
    return json.decode(reponse.body)['features'];
  }

  Future<String> _reverseGeocoding(ScreenCoordinate coordinate) async {
    final code = AppLocalization.of(context).locale.languageCode;
    print(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinate.x},${coordinate.y}.json?access_token=${mapBoxSecretToken}&language=${code}'));
    final reponse = await http.get(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinate.x},${coordinate.y}.json?access_token=${mapBoxSecretToken}&language=${code}'));
    return json.decode(reponse.body)['features'][0]['place_name'];
  }

  final SearchController controller = SearchController();
  @override
  Widget build(BuildContext context) {
    final wMQ = MediaQuery.of(context).size.width;
    final hMQ = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar(
            context: context,
            title: context.localize('mapbox_app_bar_title'),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))]),
        body: Stack(children: [
          Column(children: [
            SizedBox(
              width: double.infinity,
              height: hMQ - 400,
              child: MapWidget(
                resourceOptions: ResourceOptions(
                  accessToken: mapBoxSecretToken,
                ),
                onMapCreated: (controller) => _onMapCreated(controller),
                cameraOptions: CameraOptions(
                    center: Point(
                            coordinates: Position(
                                sharedPreferences.getDouble('longitude') ?? 0,
                                sharedPreferences.getDouble('latitude') ?? 0))
                        .toJson(),
                    zoom: 12),
                onTapListener: _onTap,
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.localize('title_current_location')}:\n',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black),
                      ),
                      const Spacer(),
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.topRight),
                          onPressed: () {
                            circleAnnotationManager?.deleteAll();
                            setState(() {
                              chosenCoordinate = currentCoordinate;
                              chosenLocation = currentLocation;
                            });
                          },
                          child: Text(context
                              .localize('label_choose_current_location'))),
                    ],
                  ),
                  Text(
                    currentLocation ?? '',
                    style: GoogleFonts.nunitoSans(
                        color: AppColor.text_secondary, fontSize: 14),
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Text(
                    '${context.localize('title_chosen_location')}:\n',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black),
                  ),
                  Text(
                    chosenLocation ?? '',
                    style: GoogleFonts.nunitoSans(
                        color: AppColor.text_secondary, fontSize: 14),
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                  ),
                  const Spacer(),
                  ActionButton(
                      boxShadow: [],
                      content: Text(
                        context.localize('label_choose_as_delivery_address'),
                        style: AppStyle.text_style_on_black_button,
                      ),
                      color: AppColor.black,
                      onPressed: () {
                        if (chosenLocation != null)
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text(context.localize(
                                        'alert_box_title_choose_as_delivery_address')),
                                    content: Text(chosenLocation!),
                                    actions: [
                                      CupertinoDialogAction(
                                          child: Text(
                                        'Yes',
                                        style: TextStyle(color: AppColor.blue),
                                      )),
                                      CupertinoDialogAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: AppColor.blue),
                                          )),
                                    ],
                                  ));
                        else
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text(context.localize(
                                        'alert_box_title_address_not_chosen')),
                                    actions: [
                                      CupertinoDialogAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'OK',
                                            style:
                                                TextStyle(color: AppColor.blue),
                                          )),
                                    ],
                                  ));
                      })
                ],
              ),
            ))
          ]),
          Positioned(
            bottom: 315,
            right: 15,
            child: FloatingActionButton(
              tooltip: context.localize('label_move_to_current_location'),
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.black,
              onPressed: _moveToCurrentLocation,
              child: Icon(Icons.my_location),
            ),
          ),
          Positioned(
              top: 5,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5)),
                ),
                width: wMQ * 0.65,
                height: 40,
                child: SearchAnchor(
                  searchController: controller,
                  isFullScreen: true,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                        controller: controller,
                        onTap: () {
                          print('onSubmitted called with query: ');
                          controller.openView();
                        },
                        onSubmitted: (query) {
                          print(
                              'onSubmitted called with query: ${controller.text}');
                        },
                        onChanged: _onSearchChanged,
                        leading: Icon(Icons.search),
                        hintText: context.localize('hint_text_address_search'));
                  },
                  suggestionsBuilder: (context, controller) {
                    _listItem(Map<String, dynamic> result) {
                      return ListTile(
                        title: Text('Some text'),
                        onTap: () => setState(() {
                          controller.closeView('Some text');
                        }),
                      );
                    }

                    return addressSearchResult.map((e) => _listItem(e));
                  },
                ),
              ))
        ]));
  }
}
