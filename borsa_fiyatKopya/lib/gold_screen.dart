import 'package:borsa_fiyat/altin_Api.dart';
import 'package:dio/dio.dart';

class AltinApi {
  final Dio dio = Dio();
  final String url = "https://api.collectapi.com/economy/goldPrice";
  final Map<String, dynamic> headers = {
    "authorization": "apikey 5OEbAbEyGSbfOewqVaoEPR:3i2qv5XtPxn9DVzXIErbYx",
    "content-type": "application/json"
  };

  Future<List<AltinFiyati>> getAltinFiyati() async {
    try {
      final response = await dio.get(url, options: Options(headers: headers));

      if (response.statusCode == 200) {
        print("Gelen veri: ${response.data}"); // << BURAYA EKLEDİM

        final List<dynamic> list = response.data["result"];
        return list.map((e) => AltinFiyati.fromJson(e)).toList();

      } else {
        throw Exception("API Hatası: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Veri çekme hatası: $e");
    }
  }
}
