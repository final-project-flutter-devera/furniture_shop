class Address {
  String name;
  String? street;
  String? place;
  String? district;
  String? city;
  String? country;
  String? zipCode;
  double? longitude;
  double? latitude;
  bool? isDefault = false;
  Address({
    required this.name,
    required this.street,
    required this.place,
    required this.district,
    required this.city,
    required this.zipCode,
    required this.country,
    this.longitude,
    this.latitude,
    this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        name: json['name'] as String,
        street: json['street'],
        place: json['place'],
        city: json['city'],
        district: json['state'],
        zipCode: json['zipCode'],
        country: json['country'],
        longitude: json['longitude'] as double?,
        latitude: json['latitude'] as double?,
        isDefault: json['isDefault']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'place': place,
      'district': district,
      'zipCode': zipCode,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
      'isDefault': isDefault,
    };
  }
}
