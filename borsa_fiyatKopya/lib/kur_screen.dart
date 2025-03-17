import 'package:dio/dio.dart';
import 'kur_api.dart';


class kurApi {
  final Dio dio = Dio();
  final String url = "https://api.collectapi.com/economy/currencyToAll?int=10&base=TRY";
  final Map<String, dynamic> headers = {
    "authorization": "apikey 5OEbAbEyGSbfOewqVaoEPR:3i2qv5XtPxn9DVzXIErbYx",
    "content-type": "application/json"
  };

  Future<List<kurFiyatlari>> getkurFiyatlari() async {
    try {
      final response = await dio.get(url, options: Options(headers: headers));

      if (response.statusCode == 200) {
        print("Gelen veri: ${response.data}");

        final List<dynamic> list = response.data["result"]["data"];
        return list.map((e) => kurFiyatlari.fromJson(e)).toList();
      } else {
        throw Exception("API Hatası: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Veri çekme hatası: $e");
    }
  }
}
