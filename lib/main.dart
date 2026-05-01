import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spad_cameroun/core/config/env_config.dart';

final testProvider = StateProvider<String>((ref) => "Initial Riverpod State");

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Check the initialized binds
  await dotenv.load(fileName: '.env.dev'); // load the env variables
  runApp(const ProviderScope(child: SpadCameroun()));
}

class SpadCameroun extends StatelessWidget {
  const SpadCameroun({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'SPAD Cameroun',
      theme: const CupertinoThemeData(primaryColor: Color(0xFF00C4D4)),
      home: const TestConfigScreen(),
    );
  }
}

class TestConfigScreen extends ConsumerStatefulWidget {
  const TestConfigScreen({super.key});

  @override
  ConsumerState<TestConfigScreen> createState() => _TestConfigScreenState();
}

class _TestConfigScreenState extends ConsumerState<TestConfigScreen> {
  String? _storedValue = 'Empty';
  final _storage = const FlutterSecureStorage(); // Create a storage instance

  // writing function
  Future<void> _saveData() async {
    await _storage.write(key: "myKey", value: "SPAD_TOKEN_123");
    ref.read(testProvider.notifier).state = "Data saved in Storage!";
    _readData();
  }

  Future<void> _readData() async {
    final value = await _storage.read(key: "myKey");
    setState(() {
      _storedValue = value;
    });
  }

  Future<void> _deleteData() async {
    await _storage.delete(key: "myKey");
    ref.read(testProvider.notifier).state = "Data deleted from Storage!";
    _readData();
  }

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    final riverpodState = ref.watch(testProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Test Config & Storage'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'API: ${EnvConfig.apiUrl}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Env: ${EnvConfig.environment}'),
              const SizedBox(height: 30),

              const Text("--- Riverpod State ---"),
              Text(
                riverpodState,
                style: const TextStyle(color: CupertinoColors.activeBlue),
              ),

              const SizedBox(height: 30),

              const Text("--- Secure Storage Value ---"),
              Text(
                _storedValue ?? "No data",
                style: const TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.activeGreen,
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton.filled(
                    onPressed: _saveData,
                    child: const Text("Set Storage"),
                  ),
                  SizedBox(width: 20,),
                  CupertinoButton.tinted(
                    onPressed: _deleteData,
                    child: const Text("Delete Storage"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
