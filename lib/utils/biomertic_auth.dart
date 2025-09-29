import 'package:local_auth/local_auth.dart';

import 'app_notifier.dart';

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;

      AppNotifier.logWithScreen("Biometric Auth","isAvailable: $isAvailable");
      AppNotifier.logWithScreen("Biometric Auth","canCheckBiometrics: $canCheck");

      if (!isAvailable || !canCheck) return false;

      final didAuthenticated = await auth.authenticate(
        localizedReason: 'Sign in using fingerprint or Face ID.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticated;
    } catch (e) {
      AppNotifier.logWithScreen("Biometric Auth", 'Error during biometric authentication: $e');
      return false;
    }
  }
}
