import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      if (!canCheck) return false;

      final didAuthenticated = await auth.authenticate(
        localizedReason: 'Sign in using fingerprint or Face ID.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticated;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }
}
