import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {

  Future<String> fetchStringConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      //Set default values before fetching
      await remoteConfig.setDefaults(const {
        "GEMINI_API_KEY": 'default_api_key',  // Default value
      });

      //Set configuration settings
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      //Fetch and activate latest config
      bool activated = await remoteConfig.fetchAndActivate();
      print('Fetch and activate status: $activated');

      //Get the string value
      String geminiApiKey = remoteConfig.getString('GEMINI_API_KEY');

      //Check if the value is null or empty and handle accordingly
      if (geminiApiKey.isEmpty) {
        print('GEMINI_API_KEY is empty, returning default value.');
        return 'default_api_key';  // Return the default if the key is empty
      }

      return geminiApiKey;
    } catch (e) {
      print('Error initializing Remote Config: $e');
      return 'default_api_key';  // Return a safe fallback value on error
    }
  }

}
