import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/string.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/address.dart';
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
  final ValueChanged<Address> onSubmit;
  PickLocation({required this.onSubmit});

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation>
    with TickerProviderStateMixin {
  MapboxMap? mapboxMap;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;
  int styleIndex = 1;

  Address? selectedAddress;
  Address? currentAddress;

  ScreenCoordinate? currentCoordinate;
  String? currentLocation;

  late AnimationController animationController;

  ScreenCoordinate? chosenCoordinate;
  String? chosenLocation;
  final searchController = SearchController();

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
    final Map<String, dynamic> thisResult =
        (await _reverseGeocoding(currentCoordinate!))[0];

    final double latitude = thisResult['geometry']['coordinates'][1];
    final double longitude = thisResult['geometry']['coordinates'][0];

    final String street = thisResult['text'];
    final List<dynamic> context = thisResult['context'];
    String? zipCode;
    String? place;
    String? district;
    String? region;
    String? country;
    context.forEach((element) {
      if ((element['id'] as String).contains('place')) {
        place = element['text'];
      }
      if ((element['id'] as String).contains('district')) {
        district = element['text'];
      }
      if ((element['id'] as String).contains('region')) {
        region = element['text'];
      }
      if ((element['id'] as String).contains('country')) {
        country = element['text'];
      }
      if ((element['id'] as String).contains('postcode')) {
        zipCode = element['text'];
      }
    });

    currentLocation = thisResult['place_name'];
    currentAddress = Address(
        name: '',
        street: street,
        place: place,
        district: district,
        city: region,
        zipCode: zipCode,
        country: country,
        latitude: latitude,
        longitude: longitude);
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
    await _moveToLocation(ScreenCoordinate(
      x: sharedPreferences.getDouble('longitude') ?? 0,
      y: sharedPreferences.getDouble('latitude') ?? 0,
    ));
  }

  _moveToLocation(ScreenCoordinate screenCoordinate) async {
    final zoom = await mapboxMap?.getCameraState().then((value) => value.zoom);
    mapboxMap?.flyTo(
        CameraOptions(
          zoom: (zoom! < 12) ? 12 : null,
          center: Point(
              coordinates: Position(
            screenCoordinate.x,
            screenCoordinate.y,
          )).toJson(),
        ),
        MapAnimationOptions(duration: 1, startDelay: 0));
  }

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
    final Map<String, dynamic> thisResult =
        (await _reverseGeocoding(chosenCoordinate!))[0];

    final double latitude = thisResult['geometry']['coordinates'][1];
    final double longitude = thisResult['geometry']['coordinates'][0];

    final String street = thisResult['text'];
    final List<dynamic> context = thisResult['context'];
    String? zipCode;
    String? place;
    String? district;
    String? region;
    String? country;
    context.forEach((element) {
      if ((element['id'] as String).contains('place')) {
        place = element['text'];
      }
      if ((element['id'] as String).contains('district')) {
        district = element['text'];
      }
      if ((element['id'] as String).contains('region')) {
        region = element['text'];
      }
      if ((element['id'] as String).contains('country')) {
        country = element['text'];
      }
      if ((element['id'] as String).contains('postcode')) {
        zipCode = element['text'];
      }
    });

    chosenLocation = thisResult['place_name'];
    selectedAddress = Address(
        name: '',
        street: street,
        place: place,
        district: district,
        city: region,
        zipCode: zipCode,
        country: country,
        latitude: latitude,
        longitude: longitude);
    setState(() {});
  }

  Future<List<dynamic>> _reverseGeocoding(ScreenCoordinate coordinate) async {
    final code = AppLocalization.of(context).locale.languageCode;
    print(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinate.x},${coordinate.y}.json?access_token=${mapBoxSecretToken}&language=${code}'));
    final reponse = await http.get(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinate.x},${coordinate.y}.json?access_token=${mapBoxSecretToken}&language=${code}'));
    return json.decode(reponse.body)['features'];
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
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: AddressSearchDelegate(
                              context: context,
                              hintText:
                                  context.localize('hint_text_address_search'),
                              onSelected: (address) async {
                                selectedAddress = address;
                                final coordinate = ScreenCoordinate(
                                    x: address.longitude!,
                                    y: address.latitude!);
                                await _onTap(ScreenCoordinate(
                                    x: address.latitude!,
                                    y: address.longitude!));
                                _moveToLocation(coordinate);
                              },
                            ));
                      },
                      icon: Icon(Icons.search))),
            ]),
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
                                          onPressed: () {
                                            widget.onSubmit
                                                .call(selectedAddress!);
                                            Navigator.of(context)
                                              ..pop()
                                              ..pop();
                                          },
                                          child: Text(
                                            'Yes',
                                            style:
                                                TextStyle(color: AppColor.blue),
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
        ]));
  }
}

class AddressSearchDelegate extends SearchDelegate {
  final ValueChanged<Address> onSelected;
  final String hintText;
  final BuildContext context;
  AddressSearchDelegate(
      {required this.hintText,
      required this.context,
      required this.onSelected});

  @override
  String? get searchFieldLabel => hintText;

  Timer? _debounce;
  Future<List<dynamic>> _onSearchChanged(String query) async {
    Completer<List<dynamic>> completer = Completer();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final addressSearchResult = await _forwardGeocoding(query);

      completer.complete(addressSearchResult);
    });
    return completer.future;
  }

  Future<List<dynamic>> _onSearchSubmit(String query) async {
    Completer<List<dynamic>> completer = Completer();

    final addressSearchResult = await _forwardGeocoding(query);
    completer.complete(addressSearchResult);

    return completer.future;
  }

  List<Map<String, dynamic>> addressSearchResult = [];

  ///Return type: List<Map<String, dynamic>>
  Future<List<dynamic>> _forwardGeocoding(String query) async {
    final code = AppLocalization.of(context).locale.languageCode;
    print(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${mapBoxSecretToken}&language=${code}'));
    final reponse = await http.get(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${mapBoxSecretToken}&language=${code}'));
    return json.decode(reponse.body)['features'];
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length == 0) return SizedBox();
    return FutureBuilder<List<dynamic>>(
      future: _onSearchSubmit(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No suggestions found');
        } else {
          // Suggestions based on snapshot.data
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> thisResult = snapshot.data![index];
              print('This result: ${thisResult.length}');
              // ... Rest of your code to build suggestions ...

              final double latitude = thisResult['geometry']['coordinates'][1];
              final double longitude = thisResult['geometry']['coordinates'][0];

              final String addressString = thisResult['place_name'];

              final String street = thisResult['text'];
              final List<dynamic> context = thisResult['context'];
              String? zipCode;
              String? place;
              String? district;
              String? region;
              String? country;
              context.forEach((element) {
                if ((element['id'] as String).contains('place')) {
                  place = element['text'];
                }
                if ((element['id'] as String).contains('district')) {
                  district = element['text'];
                }
                if ((element['id'] as String).contains('region')) {
                  region = element['text'];
                }
                if ((element['id'] as String).contains('country')) {
                  country = element['text'];
                }
                if ((element['id'] as String).contains('postcode')) {
                  zipCode = element['text'];
                }
              });
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: index != 0
                            ? BorderSide(color: AppColor.blur_grey)
                            : BorderSide.none)),
                child: ListTile(
                  onTap: () {
                    onSelected.call(Address(
                        name: '',
                        street: street,
                        place: place,
                        district: district,
                        city: region,
                        zipCode: zipCode,
                        country: country,
                        latitude: latitude,
                        longitude: longitude));
                    close(this.context, null);
                  },
                  title: Text(
                    addressString,
                    style: AppStyle.secondary_text_style,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ListTileStyle.list,
                  titleAlignment: ListTileTitleAlignment.center,
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length == 0) return SizedBox();
    return FutureBuilder<List<dynamic>>(
      future: _onSearchChanged(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No suggestions found');
        } else {
          // Suggestions based on snapshot.data
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> thisResult = snapshot.data![index];

              final double latitude = thisResult['geometry']['coordinates'][1];
              final double longitude = thisResult['geometry']['coordinates'][0];

              final String addressString = thisResult['place_name'];

              final String street = thisResult['text'];
              final List<dynamic> context = thisResult['context'];
              String? zipCode;
              String? place;
              String? district;
              String? region;
              String? country;
              context.forEach((element) {
                if ((element['id'] as String).contains('place')) {
                  place = element['text'];
                }
                if ((element['id'] as String).contains('district')) {
                  district = element['text'];
                }
                if ((element['id'] as String).contains('region')) {
                  region = element['text'];
                }
                if ((element['id'] as String).contains('country')) {
                  country = element['text'];
                }
                if ((element['id'] as String).contains('postcode')) {
                  zipCode = element['text'];
                }
              });
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: index != 0
                            ? BorderSide(color: AppColor.blur_grey)
                            : BorderSide.none)),
                child: ListTile(
                  onTap: () {
                    onSelected.call(Address(
                        name: '',
                        street: street,
                        place: place,
                        district: district,
                        city: region,
                        zipCode: zipCode,
                        country: country,
                        latitude: latitude,
                        longitude: longitude));
                    close(this.context, null);
                  },
                  title: Text(
                    addressString,
                    style: AppStyle.secondary_text_style,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ListTileStyle.list,
                  titleAlignment: ListTileTitleAlignment.center,
                ),
              );
            },
          );
        }
      },
    );
  }
}
