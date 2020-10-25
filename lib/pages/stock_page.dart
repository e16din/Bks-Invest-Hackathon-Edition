import 'package:bks_invest/data/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/stock_data.dart';
import 'dart:convert';

class StockPage extends Page {
  final Stock stock;

  StockPage({
    this.stock,
  }) : super(key: ValueKey(stock));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return StockWidget(stock: stock);
      },
    );
  }
}

class StockWidget extends StatelessWidget {
  final Stock stock;

  StockWidget({
    @required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(stock.name)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            color: Colors.white,
            constraints: new BoxConstraints.expand(),
            child: Stack(children: [
              SingleChildScrollView(
                  child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                child: ClipOval(
                                    child: Image.asset(stock.logoAsset))),
                            Text("${stock.percents.toStringAsFixed(2)}%",
                                style: new TextStyle(
                                    fontSize: 16.0, color: Color(stock.color))),
                            Text("${stock.value.toStringAsFixed(2)}\$",
                                style: new TextStyle(
                                    fontSize: 16.0, color: Color(0xFF999999)))
                          ])),
                  Padding(padding: EdgeInsets.only(right: 8)),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 7)),
                      Text("О компании",
                          style: Theme.of(context).textTheme.headline6),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Text(stock.description,
                          style: TextStyle(
                            fontSize: 15,
                          )),
                    ],
                  ))
                ]),
                Padding(padding: EdgeInsets.only(top: 24)),
                Image.asset(stock.lineAsset),
                Padding(padding: EdgeInsets.only(top: 56)),
              ])),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 180,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: () {
                        _onBuyPressed(context);
                      },
                      child:
                          const Text('Купить', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 5,
                    ),
                  ))
            ])),
      ),
    );
  }

  _onBuyPressed(BuildContext context) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var coinsCount = sharedPreferences.getInt(
      KeyCoinsCount,
    );
    if (coinsCount >= 300) {
      var stockVirtualPrice = 300;
      sharedPreferences.setInt(KeyCoinsCount, coinsCount - stockVirtualPrice);

      var myStocksJson = sharedPreferences.getString(KeyMyStocks);

      List<Stock> myStocks = List();
      if (myStocksJson != null) {
        Iterable jsonObjects = json.decode(myStocksJson);
        myStocks = List<Stock>.from(jsonObjects.map((i) => Stock.fromJson(i)));
      }
      myStocks.add(stock);
      sharedPreferences.setString(KeyMyStocks, jsonEncode(myStocks));

      showOkAlertDialog(context, "Поздравляем, покупка прошла успешно!");

    } else {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Отмена"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Пополнить"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(true);
          Navigator.pop(context);
          _launchURL("https://bcs.ru/");
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("БКС Инвестиции"),
        content: Text("Недостаточно БКС-монет для покупки, необходимо пополнить баланс."),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showOkAlertDialog(BuildContext context, String message) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Отмена"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Ок"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("БКС Инвестиции"),
      content: Text(message),
      actions: [
        // cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
