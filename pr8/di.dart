import 'package:get_it/get_it.dart';

import 'data.dart';
import 'domain.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerSingleton<HoroscopeRepository>(HoroscopeRepository());
  
  sl.registerSingleton(GetHoroscopeUseCase(sl()));
}
