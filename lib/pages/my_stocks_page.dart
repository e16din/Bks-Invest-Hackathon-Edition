import 'dart:convert';

import 'package:bks_invest/data/stock_data.dart';
import 'package:bks_invest/pages/stock_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyStocksPage extends Page {
  final List<Stock> myStocks;

  MyStocksPage({
    this.myStocks,
  }) : super(key: ValueKey(json.encode(myStocks)));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return MyStocksWidget(myStocks: myStocks);
      },
    );
  }
}

class MyStocksWidget extends StatelessWidget {
  final List<Stock> myStocks;

  MyStocksWidget({@required this.myStocks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Мои акции"),
        ),
        body: Stack(children: [
          ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.blueGrey,
                    indent: 32,
                    endIndent: 32,
                    thickness: 0.1,
                    height: 0.1,
                  ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myStocks.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(0.0),
                    child: ListTile(
                        title: Text(myStocks[index].name),
                        subtitle: Text(myStocks[index].shortName),
                        leading: CircleAvatar(
                            child: ClipOval(
                                child: Image.asset(myStocks[index].logoAsset))),
                        trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${myStocks[index].percents.toStringAsFixed(2)}%",
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: Color(myStocks[index].color))),
                              Text(
                                  "${myStocks[index].value.toStringAsFixed(2)}\$",
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF999999)))
                            ]),
                        onTap: () => {
                              // Navigator.push(
                              //     context,
                              //     StockPage(stock: myStocks[index])
                              //         .createRoute(context))
                            }),
                  )),
          Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 280,
                    height: 80,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: () {
                        _launchURL("https://bcs.ru/");
                      },
                      child: const Text('Перевести виртуальные в реальные',
                          style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 5,
                    ),
                  )))
        ]));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
