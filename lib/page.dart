import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import "package:http/http.dart" as http;

class HomePageTow extends StatefulWidget {
  const HomePageTow({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageTow> {

  Map<String,dynamic>? paymentIntent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [

          Center(
            child: MaterialButton(onPressed: () async {
              await makePayment();
            } , child: const Text("Payment"),),
          )
        ],
      ),
    );
  }


  makePayment() async {
    //
    // print( paymentIntent!['client_secret']);
    // print( paymentIntent!['customer']);
    // print( paymentIntent!['ephemeralKey']);


    paymentIntent = await createPaymentIntent(amount: "2", currency: "USD");
    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntent!['client_secret'] ,
      customerId: paymentIntent!['customer'],
      customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
      applePay: const PaymentSheetApplePay(merchantCountryCode: "+20") ,
      googlePay: const PaymentSheetGooglePay(merchantCountryCode: "+20" , testEnv: true) ,
      style: ThemeMode.dark ,
      merchantDisplayName: "Mohamed",
    ));


  }

  createPaymentIntent({required String amount , required String currency}) async {
    try{
      const String secretKey = "sk_test_51LXkxEEBumJR8Vl7QDF7cStRyrV3qR2QMHwZVwyIWcpkNX29eNrGyl8FebUV8eMq8xCOkTPeJ4BkQajtdvGsDJ7a00gtVU2bW2";

      final Map<String,dynamic> _body = {
        "amount" : calculateAmount(amount) ,
        "currency" : currency ,
        "payment_method_types[]": "card"
      };

      final Map<String,String> _headers = {
        "Authorization": "Bearer $secretKey" ,
        "Content-Type" : "application/x-www-form-urlencoded"
      };

      final http.Response _response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents") ,
          body: _body,
          headers: _headers
      );

     // print("Payment Intent Body ${_response.body.toString()}");

      return jsonDecode(_response.body);

    } on PaymentSheetError catch(e) {
     // print("Google: ${e.index.toString()}");
    }
  }

  String calculateAmount(String amount) {
    final _calculate = (int.parse(amount)) * 100;
    return _calculate.toString();
  }
}
