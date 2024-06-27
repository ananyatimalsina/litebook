import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:litebook/screens/home.dart';
import 'package:litebook/screens/onboarding/onboarding.dart';
import 'package:litebook/screens/splash.dart';
import 'package:litebook/api/backend.dart';
import 'package:litebook/api/book_data_model.dart';
import 'package:permission_handler/permission_handler.dart';

late Box box;
late Box bookBox;

late Backend backend;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [
    Permission.camera,
  ].request();
  await Hive.initFlutter();
  box = await Hive.openBox('box');
  Hive.registerAdapter(BookAdapter());
  bookBox = await Hive.openBox<List>('books');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    if (box.get("showHome", defaultValue: false) == false) {
      runApp(MaterialApp(
          home: Onboarding(
              onOnboardingComplete: () => {
                    runApp(Splash(
                        onInitializationComplete: () =>
                            {runApp(const LiteBook())}))
                  })));
    } else {
      runApp(
        Splash(
          onInitializationComplete: () => {
            runApp(
              const LiteBook(),
            )
          },
        ),
      );
    }
  });
}

class LiteBook extends StatelessWidget {
  const LiteBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LiteBook',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.indigo,
      ),
      home: HomePage(
        backend: backend,
      ),
    );
  }
}
