import 'package:aptos/aptos_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/main_camera_screen.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/providers/transaction_provider.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/scan_successful_screen.dart';
import 'package:web3auth_flutter/input.dart';
import 'features/wallet/presentation/screens/wallet_registration_screen.dart';
import 'package:reclaim/core/navigation/navigation.dart';
import 'package:reclaim/features/authentication/presentation/screens/log_in_screen.dart';
import 'firebase_options.dart';
import 'package:reclaim/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:reclaim/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final client = AptosClient('https://api.devnet.aptoslabs.com/v1');
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final AptosClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TransactionProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReClaim',
        theme: ThemeData(fontFamily: 'Inter'),
        home: LogInScreen(),
        routes: {
          MainCameraScreen.routeName: (context) => const MainCameraScreen(),
          ScanSuccessfulScreen.routeName: (context) => const ScanSuccessfulScreen(),
          // DashboardScreen.routeName: (context) => 
        //   DashboardScreen(
        //     user: AppUser(
        //       uid: FirebaseAuth.instance.currentUser!.uid,
        //       email: FirebaseAuth.instance.currentUser!.email,
        // ),),
        //   LogInScreen.routeName: (context) => const LogInScreen(),
          // SignUpScreen.routeName: (context) => const SignUpScreen(),
        },
      ),
    );
  }
}
