class Address {
  String name;
  String street;
  String city;
  String state;
  String zipCode;
  String country;
  double? longitude;
  double? latitude;
  bool? isDefault = false;
  Address({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.longitude,
    this.latitude,
    this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        name: json['name'] as String,
        street: json['street'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        zipCode: json['zipCode'] as String,
        country: json['country'] as String,
        longitude: json['longitude'] as double?,
        latitude: json['latitude'] as double?,
        isDefault: json['isDefault']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
      'isDefault': isDefault,
    };
  }
}
