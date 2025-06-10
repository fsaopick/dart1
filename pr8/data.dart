import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'domain.dart';

const String _baseUrl = 'https://api.api-ninjas.com/v1';
const String _horoscopeEndpoint = '/horoscope';
const String _apiKey = 'https://api.api-ninjas.com/v1/horoscope'; 

class HoroscopeRemoteDataSource {
  final Dio _dio;

  HoroscopeRemoteDataSource() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {'X-Api-Key': _apiKey},
  )) {
    _dio.interceptors.add(PrettyDioLogger());
  }

  Future<HoroscopeEntity> getHoroscope(String sign) async {
    try {
      final response = await _dio.get(
        _horoscopeEndpoint,
        queryParameters: {'zodiac': sign}, 
      );
      
      if (response.statusCode == 200) {
        return HoroscopeEntity.fromJson(response.data);
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}

class HoroscopeRepository {
  final HoroscopeRemoteDataSource _dataSource = HoroscopeRemoteDataSource();

  Future<HoroscopeEntity> getHoroscope(String sign) => 
      _dataSource.getHoroscope(sign);

  Future<String> translateHoroscope(String text) async {
    return 'Перевод: $text';
  }
}