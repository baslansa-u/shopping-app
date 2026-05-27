import 'dart:convert';

List<BransDataModel> brandsFromJson(String str) => List<BransDataModel>.from(
    json.decode(str).map((x) => BransDataModel.fromMap(x)));

String brandsToJson(List<BransDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BransDataModel {
  final String name;
  final String logo;

  BransDataModel({
    required this.name,
    required this.logo,
  });

  factory BransDataModel.fromMap(Map<String, dynamic> json) => BransDataModel(
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "logo": logo,
      };
}

// abstract class BrandDataModel {
//   int get id;
//   String get name;
//   String get image;
//   int get price;
// }
