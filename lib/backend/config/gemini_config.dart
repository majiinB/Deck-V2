import 'package:deck/backend/config/firebase_remote_config.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiConfig{
  late final String _apiKey;
  late final GenerativeModel _model;

  GeminiConfig(){
    _init();
  }

  Future<void> _init() async{
    _apiKey = await _getAPIKey();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );
  }
  // Method to fetch the API key asynchronously
  Future<String> _getAPIKey() async {
    FirebaseRemoteConfigService service = FirebaseRemoteConfigService();
    return await service.fetchStringConfig();
  }
  // Public getter for the model
  GenerativeModel get model => _model;
}