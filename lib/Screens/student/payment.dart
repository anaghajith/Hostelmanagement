import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _makePayment(context);
          },
          child: Text('Pay Now'),
        ),
      ),
    );
  }

  void _makePayment(BuildContext context) async {
    try {
      var MyPaymentGateway;
      final transactionId = await MyPaymentGateway.initiatePayment(amount: 100.0);

      // Handle successful payment
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Transaction ID: $transactionId'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle payment errors
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Payment Failed'),
          content: Text('An error occurred while processing your payment.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
