import 'package:local_auth/local_auth.dart';
import '../utils/app_notifier.dart';

class BiometricAuthController {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;

      AppNotifier.logWithScreen("Biometric Auth Controller","isAvailable: $isAvailable");
      AppNotifier.logWithScreen("Biometric Auth Controller","canCheckBiometrics: $canCheck");

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
      AppNotifier.logWithScreen("Biometric Auth Controller", 'Error during biometric authentication: $e');
      return false;
    }
  }
}
