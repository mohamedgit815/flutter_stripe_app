import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_app/One/home_page.dart';


Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Stripe.instance.applySettings();
 // Stripe.publishableKey = "pk_test_51LXkxEEBumJR8Vl7QnlnTGjEE8Luz0OtuJVoEQBhiDOLXQU712Yxgz6xpAbQCPESUkd8JsjCvDxs6y2qoK7VMT7000PEr9B8Q2";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo' ,
      theme: ThemeData( primarySwatch: Colors.blue ) ,
      home: const HomePage()
    );
  }
}