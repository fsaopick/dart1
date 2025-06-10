import 'package:flutter/material.dart';
import 'package:flutter_application_1/data.dart';
import 'package:flutter_application_1/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class HoroscopeBloc extends Cubit<HoroscopeState> {
  final GetHoroscopeUseCase _getHoroscope;
  final HoroscopeRepository _repository;

  HoroscopeBloc(this._getHoroscope, this._repository) 
      : super(HoroscopeInitial());

  Future<void> getHoroscope(String sign) async {
    emit(HoroscopeLoading());
    try {
      final horoscope = await _getHoroscope(sign);
      emit(HoroscopeLoaded(horoscope));
    } catch (e) {
      emit(HoroscopeError(e.toString()));
    }
  }

  Future<void> translateHoroscope() async {
    if (state is HoroscopeLoaded) {
      final currentState = state as HoroscopeLoaded;
      final translated = await _repository.translateHoroscope(
        currentState.horoscope.horoscope,
      );
      emit(HoroscopeLoaded(currentState.horoscope..translatedHoroscope = translated));
    }
  }
}

abstract class HoroscopeState {}

class HoroscopeInitial extends HoroscopeState {}

class HoroscopeLoading extends HoroscopeState {}

class HoroscopeLoaded extends HoroscopeState {
  final HoroscopeEntity horoscope;
  HoroscopeLoaded(this.horoscope);
}

class HoroscopeError extends HoroscopeState {
  final String message;
  HoroscopeError(this.message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Гороскоп',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => HoroscopeBloc(sl(), sl()),
        child: const HoroscopeScreen(),
      ),
    );
  }
}

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signs = [
      'aries', 'taurus', 'gemini', 'cancer',
      'leo', 'virgo', 'libra', 'scorpio',
      'sagittarius', 'capricorn', 'aquarius', 'pisces'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Гороскоп')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  items: signs.map((sign) => DropdownMenuItem(
                    value: sign,
                    child: Text(sign),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<HoroscopeBloc>().getHoroscope(value);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Выберите знак зодиака',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<HoroscopeBloc, HoroscopeState>(
                  builder: (context, state) {
                    if (state is HoroscopeLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is HoroscopeLoaded) {
                      return Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.horoscope.sign.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(state.horoscope.date),
                                  const SizedBox(height: 16),
                                  Text(state.horoscope.translatedHoroscope.isEmpty
                                      ? state.horoscope.horoscope
                                      : state.horoscope.translatedHoroscope),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is HoroscopeError) {
                      return Text('Ошибка: ${state.message}');
                    } else {
                      return const Text('Выберите знак зодиака');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}