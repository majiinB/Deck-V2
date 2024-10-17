import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  // Singleton: private constructor and static instance.
  FirebaseRemoteConfigService._internal();
  static final FirebaseRemoteConfigService _instance =
  FirebaseRemoteConfigService._internal();

  static FirebaseRemoteConfigService get instance => _instance;

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  // Initialize Remote Config settings.
  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate(); // Optional: Fetch & activate configs.
  }
}
