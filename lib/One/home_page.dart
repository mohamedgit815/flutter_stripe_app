import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String,dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Payment") ,
        centerTitle: true ,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Center(
            child: MaterialButton(
                onPressed: () async {

                  await makePayment();

                },child: const Text("Pay")),
          )
        ],
      ),
    );
  }


  Future<void> makePayment() async {
    try{
      paymentIntentData = await createPaymentIntent(amount: "9",currency: "USD");

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerId: paymentIntentData!['customer'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: "+20",testEnv: true),
              applePay: const PaymentSheetApplePay(merchantCountryCode: "+20",) ,
              style: ThemeMode.dark ,
              merchantDisplayName: "Mohamed"
      ));

      displayPaymentSheet();


    } catch (e) {
      print("Exception ${e.toString()}");
    }
  }

  displayPaymentSheet() {
    try{
      Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData!['client_secret'] ,
            confirmPayment: true
          )
      );
      setState(() {
        paymentIntentData = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PaidSuccessfully") ));

    } on StripeException catch (e) {
      print("displayPaymentSheet ${e.toString()}");

      showDialog(context: context, builder: (_)=> const AlertDialog(
        content:  Text("Canceled"),
      ));

    }
  }

// Future<Map<String,dynamic>?>
   createPaymentIntent({ required String amount , required String currency }) async {
    const String _secretKey = "sk_test_51LXkxEEBumJR8Vl7QDF7cStRyrV3qR2QMHwZVwyIWcpkNX29eNrGyl8FebUV8eMq8xCOkTPeJ4BkQajtdvGsDJ7a00gtVU2bW2";

    final Map<String,String> _headers = <String,String>{
      "Authorization":"Bearer $_secretKey" ,
      "Content-Type": "application/x-www-form-urlencoded"
    };

    final Map<String , String> _body = <String , String>{
      "amount": calculateAmount(amount) ,
      "currency": currency ,
      "payment_method_types[]": "card"
    };

    final http.Response _response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: _headers , body: _body
    );

    return await jsonDecode(_response.body);

  }




  String calculateAmount(String amount) {
    final _calculate = (int.parse(amount)) * 100;
    return _calculate.toString();
  }
}