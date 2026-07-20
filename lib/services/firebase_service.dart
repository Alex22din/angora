import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();
  factory FirebaseService() => _instance;
  FirebaseService._();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
    _initialized = true;
  }
}
