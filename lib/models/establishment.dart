import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/models/tag.dart';

class Establishment {
  final String id;
  final String name;
  final String fullAddress;
  final List<Tag> tags;
  // Long lat
  final List<double> coordinates;
  final List<String> picturesPaths;
  final int likes;
  final String phone;
  final EstablishmentType type;

  const Establishment({
    required this.name,
    required this.id,
    required this.fullAddress,
    required this.tags,
    required this.coordinates,
    required this.picturesPaths,
    required this.likes,
    required this.phone,
    required this.type,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['id'],
      name: json['name'],
      fullAddress: json['fullAddress'],
      tags: Tag.fromJsons(json['tags']),
      coordinates: List<double>.from(json['coordinates']),
      picturesPaths: List<String>.from(json['picturesPaths']),
      likes: json['likes'],
      phone: json['phone'],
      type: EstablishmentType.values.byName(json["type"]),
    );
  }

  static Future<List<Establishment>> fromJsons(List<dynamic> jsons) async {
    final List<Establishment> establishments = [];
    for (Map<String, dynamic> json in jsons) {
      establishments.add(Establishment.fromJson(json));
    }
    return establishments;
  }
}
