class Address {
  final String address;
  final String city;
  final String postalCode;
  final String country = "France";
  final String fullAddress;
  // Long lat
  final List<double> coordinates;

  const Address({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.fullAddress,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "city": city,
      "postalCode": postalCode,
      "fullAddress": fullAddress,
      "coordinates": coordinates,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'],
      fullAddress: json['fullAddress'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
}
