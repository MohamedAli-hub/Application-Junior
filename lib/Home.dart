import 'package:flutter/material.dart';
import 'package:flutter_app/payment-service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        //Navigator.pushNamed(context, '/payViaNewCard');
        break;
        // case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }


  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response =
        await StripeService.payWithNewCard(amount: '15000', currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  //icon = Icon(Icons.add_circle, color: theme.primaryColor);
                  icon = Icon(Icons.credit_card, color: theme.primaryColor);
                  text = Text('Pay via new card');
                  break;
                  //  case 1:
                  icon = Icon(Icons.credit_card, color: theme.primaryColor);
                  text = Text('Pay via existing card');
                  break;
              }
              return Column(children: [
                //Center(child: Image(image:AssetImage('assets/img1.jpeg')),),
                // Center(child: Image.asset('assets/img2.jpg')),
                InkWell(
                  onTap: () {
                    onItemPress(context, index);
                  },
                  child: ListTile(
                    title: text,
                    leading: icon,
                  ),
                ),


                Center(
                  child: Image(image: AssetImage('assets/img1.jpeg')),
                ),
                Center(child: Image.asset('assets/img2.jpg')),
              ]);
            },
            separatorBuilder: (context, index) => Divider(
                  color: theme.primaryColor,
                ),
            itemCount: 1),
      ),
    );
  }
}
