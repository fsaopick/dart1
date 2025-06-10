import 'package:flutter_application_1/data.dart';

class HoroscopeEntity {
  final String date;
  final String sign;
  final String horoscope;
  String translatedHoroscope;

  HoroscopeEntity({
    required this.date,
    required this.sign,
    required this.horoscope,
    this.translatedHoroscope = '',
  });

  factory HoroscopeEntity.fromJson(Map<String, dynamic> json) {
    return HoroscopeEntity(
      date: json['date'],
      sign: json['sign'],
      horoscope: json['horoscope'],
    );
  }
}

class GetHoroscopeUseCase {
  final HoroscopeRepository _repository;

  GetHoroscopeUseCase(this._repository);

  Future<HoroscopeEntity> call(String sign) async {
    return await _repository.getHoroscope(sign);
  }
}