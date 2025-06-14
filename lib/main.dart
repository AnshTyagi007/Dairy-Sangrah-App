import 'package:farm_expense_mangement_app/api/firebase_api.dart';
import 'package:farm_expense_mangement_app/screens/authenticate/authentication.dart';
import 'package:farm_expense_mangement_app/screens/wrappers/wrapperhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:farm_expense_mangement_app/screens/authenticate/phoneno.dart';
final navigatorKey=GlobalKey<NavigatorState>();


class AppData with ChangeNotifier {
  static String _persistentVariable = "en";

  String get persistentVariable => _persistentVariable;

  set persistentVariable(String value) {
    _persistentVariable = value;
    notifyListeners(); // Notify listeners of the change
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // FirebaseAuth.instance.createUserWithEmailAndPassword(email: '2021csb1136@iitrpr.ac.in', password: 'iit@123#');
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return const Authenticate();

          } else {
            // final cattleDb = DatabaseServicesForCattle(user.uid);

            // cattleDb.infoToServerSingleCattle(cattle);
            return const WrapperHomePage();
          }
        },
      ),
    );
  }
}
