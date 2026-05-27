import 'dart:convert';

import 'package:equatable/equatable.dart';

List<ProductDataModel> productDataModelFromJson(String str) =>
    List<ProductDataModel>.from(
        json.decode(str).map((x) => ProductDataModel.fromMap(x)));

String productDataModelToJson(List<ProductDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ProductDataModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final int price;
  final String brand;

  const ProductDataModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.brand,
  });

  factory ProductDataModel.fromMap(Map<String, dynamic> json) =>
      ProductDataModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        brand: json["brand"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "brand": brand,
      };

//เลือกใช้เฉพาะ id เปรียบเทียบ How ? -> class extends Equatable{} -> override
  @override
  List<Object> get props => [id];
}
