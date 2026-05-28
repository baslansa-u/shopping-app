import 'dart:convert';
import 'dart:developer';

import 'package:shopping/scr/models/brands_model.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/scr/models/product_model.dart';

const baseUrl = "http://10.0.2.2:8080";

//fetchData -> jsonDcode -> BransDataModel.fromMap ->fetchData
class BrandServices {
  static Future<List<BransDataModel>> fetchData() async {
    var client = http.Client();
    List<BransDataModel> posts = [];
    try {
      var response = await client.get(Uri.parse('$baseUrl/brands'));

      final Map<String, dynamic> json = jsonDecode(response.body);
      List result = json['data'];

      for (int i = 0; i < result.length; i++) {
        BransDataModel post =
            BransDataModel.fromMap(result[i] as Map<String, dynamic>);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}

class BrandAppleServices {
  static Future<List<ProductDataModel>> fetchData() async {
    var client = http.Client();
    List<ProductDataModel> apple = [];
    try {
      var response =
          await client.get(Uri.parse('$baseUrl/products?brand=apple'));

      final Map<String, dynamic> json = jsonDecode(response.body);
      List result = json['data'];

      for (int i = 0; i < result.length; i++) {
        ProductDataModel post =
            ProductDataModel.fromMap(result[i] as Map<String, dynamic>);
        apple.add(post);
      }
      return apple;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}

class BrandSamsungServices {
  static Future<List<ProductDataModel>> fetchData() async {
    var client = http.Client();
    List<ProductDataModel> samsung = [];
    try {
      var response =
          await client.get(Uri.parse('$baseUrl/products?brand=samsung'));
      final Map<String, dynamic> json = jsonDecode(response.body);
      List result = json['data'];

      for (int i = 0; i < result.length; i++) {
        ProductDataModel post =
            ProductDataModel.fromMap(result[i] as Map<String, dynamic>);
        samsung.add(post);
      }
      return samsung;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
