import 'package:yeley_frontend/commons/constants.dart';

class Tag {
  final String value;
  final EstablishmentType type;
  final String id;
  final String? picturePath;

  const Tag({
    required this.value,
    required this.type,
    required this.id,
    required this.picturePath,
  });

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "id": id,
      "picturePath": picturePath,
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      value: json['value'],
      type: EstablishmentType.values.byName(json["type"]),
      id: json['id'],
      picturePath: json['picturePath'],
    );
  }

  static List<Tag> fromJsons(List<dynamic> jsons) {
    final List<Tag> tags = [];
    for (Map<String, dynamic> json in jsons) {
      tags.add(Tag.fromJson(json));
    }
    return tags;
  }

  static List<String> getIds(List<Tag> tags) {
    List<String> ids = [];

    for (Tag tag in tags) {
      ids.add(tag.id);
    }
    return ids;
  }
}
