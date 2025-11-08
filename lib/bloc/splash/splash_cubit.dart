import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temu_recipe/bloc/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial());

  Future<void> checkFirstLaunch() async {
    // ✅ Laisse SharedPreferences se charger correctement
    await Future.delayed(const Duration(milliseconds: 120));

    final prefs = await SharedPreferences.getInstance();

    final onboardingDone = prefs.getBool('onboarding_done');

    // ✅ Valeur non définie = première installation
    if (onboardingDone == null || onboardingDone == false) {
      emit(state.copyWith(status: SplashStatus.firstLaunch));
    } else {
      emit(state.copyWith(status: SplashStatus.notFirstLaunch));
    }

    // ✅ Splash timer (ne bloque plus la logique)
    await Future.delayed(const Duration(seconds: 2));
  }
}
