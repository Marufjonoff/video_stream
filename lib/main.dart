import 'package:flutter/material.dart';
import 'package:video_stream/video_stream/video_player.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(FlutterConfig.get("MUX_TOKEN_ID"));
    print(FlutterConfig.get("MUX_TOKEN_SECRET"));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoPlayerScreenOne(),
    );
  }
}

