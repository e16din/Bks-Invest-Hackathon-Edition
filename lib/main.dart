import 'dart:convert';

import 'package:bks_invest/data/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'data/stock_data.dart';
import 'pages/my_stocks_page.dart';
import 'pages/stock_page.dart';

void main() {
  runApp(MainApp());
}

const PrimaryColor = const Color(0xFF1473EF);

List<Stock> tempMyStocks = List();

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Stock _selectedStock;
  List<Stock> _myStocks;

  List<Stock> stocks = [
    Stock(
        'Сбербанк',
        'SBER',
        'assets/images/sber_logo.png',
        'assets/images/sber_line.png',
        "Сбербанк России — крупнейший российский финансовый конгломерат. Предлагает весь спектр инвестиционно-банковских услуг: корпоративные и розничные кредиты, депозиты, пенсионное страхование, обмен валют, дебетовые и кредитные карты, лизинг, электронные аукционы и др. Имеет представительства во многих странах мира, включая США, Великобританию, а также страны СНГ и Восточной Европы. Контролируется Центральным банком РФ.",
        10.65,
        255.60,
        0xFFE53935,
        "₽",
        2145),
    Stock(
        'Tesla',
        'TSLA',
        'assets/images/tesla_logo.png',
        'assets/images/tesla_line.png',
        "Tesla Inc. — американская компания, производитель электрокаров и компонентов силовых агрегатов. Компания владеет собственной сетью продаж и техобслуживания, поставляет компоненты другим автопроизводителям. Tesla Inc. основана в 2003 году, презентация первого автомобиля компании — Tesla Roadster — состоялась в 2006 году.",
        543.15,
        355.71,
        0xFF388E3C,
        "\$",
        421.20),
    Stock(
        'Газпром',
        'GAZP',
        'assets/images/gazprom_logo.png',
        'assets/images/gazprom_line.png',
        "«Газпром» — многопрофильная энергетическая корпорация с государственным участием. Основные направления деятельности — геологическая разведка углеводородных и нефтяных месторождений; добыча, переработка, хранение и транспортировка газа и нефти; генерация и сбыт тепловой энергии и электроэнергии. Один из ключевых игроков на глобальном энергетическом рынке. «Газпрому» принадлежит крупнейшая в мире система транспортировки газа, а также предприятия по разработке газовой и нефтехимической продукции.",
        33.24,
        821.50,
        0xFFE53935,
        "\$",
        1649.60),
    Stock(
        'Apple',
        'AAPL',
        'assets/images/apple_logo.png',
        'assets/images/apple_line.png',
        "Apple Inc. — американский производитель персональных и планшетных компьтеров, смартфонов и программного обеспечения. Компания продает свою продукцию через сеть розничных магазинов Apple Store, а также в официальном интернет-магазине и через других ритейлеров. Первая американская компания, чья капитализация превысила 1 триллион долларов США.",
        86.49,
        53.40,
        0xFF388E3C,
        "\$",
        115.14),
    Stock(
        'ЛУКОЙЛ',
        'LKOH',
        'assets/images/lukoil_logo.png',
        'assets/images/lukoil_line.png',
        "«Лукойл» — российская нефтегазовая компания. Занимается разведкой и добычей углеводородов, переработкой сырья, продажей нефти и нефтепродуктов. Компания владеет собственными нефтеперерабатывающими заводами, нефтехимическими комбинатами, заправочными станциями, значительным числом электроустановок, сетью трубопроводов, а также железнодорожным и водным транспортом. Участвует в разведке и разработке месторождений в Азербайджане, Иране, Ираке, Египте, Казахстане, Узбекистане и других странах.",
        29.65,
        1822.50,
        0xFFE53935,
        "₽",
        4325),
    Stock(
        'Intel',
        'INTC',
        'assets/images/intel_logo.png',
        'assets/images/intel_line.png',
        "Intel производит микропроцессоры, графические процессоры, чипсеты, сетевые платы, твердотелые накопители и другие компьютерные компоненты. Также компания разрабатывает графические технологии, технологии визуализации, памяти и безопасности, технологии для центров обработки данных и сетей 5G, производит 3D-камеры RealSense™.",
        14.69,
        8.30,
        0xFFE53935,
        "\$",
        48.19),
    Stock(
        'Норильский никель',
        'GMKN',
        'assets/images/nornikel_logo.png',
        'assets/images/nornikel_line.png',
        "«Норникель» — российская горно-металлургическая компания. Крупнейший в мире производитель никеля и палладия, один из крупнейших производителей платины и меди. Производит также кобальт, родий, серебро, золото, иридий, рутений, селен, теллур и серу. Продукция Норникеля экспортируется в более 30 стран мира.",
        15.34,
        2638,
        0xFF388E3C,
        "₽",
        19838),
    Stock(
        'Amazon',
        'AMZN',
        'assets/images/amazon_logo.png',
        'assets/images/amazon_line.png',
        "Amazon.com, Inc. — одна из первых компаний, которые начали продавать товары массового пользования в интернете. Сейчас на сайте Amazon.com продаются товары более 30 категорий, в том числе книги, бытовая электроника, детские игрушки, пищевые продукты, хозяйственные товары, спортивные товары и многое другое. Компания также производит устройства для чтения книг, компьютерные игры, товары для дома и сада и разрабатывает свои технологии: у Amazon есть платежная система и облачые технологии.",
        82.39,
        1450.39,
        0xFF388E3C,
        "\$",
        3210.80),
    Stock(
        'Яндекс',
        'YNDX',
        'assets/images/yandex_logo.png',
        'assets/images/yandex_line.png',
        "«Яндекс» — российская интернет-компания, владеющая крупнейшей в России поисковой системой и рядом других интернет-сервисов, включая онлайн-оператор такси, онлайн-кинотеатр и маркетплейсы. Работает в России, Беларуси, Казахстане и Турции. Основной доход получает от продажи рекламы. Яндекс также поддерживает крупнейшую в России сеть центров обработки и хранения данных, инвестирует в российские и зарубежные IT-компании.",
        118.81,
        2456,
        0xFF388E3C,
        "₽",
        4523.20)
  ];

  // Future<bool> loadData() async {
  //   var sharedPreferences = await SharedPreferences.getInstance();
  //   coinsCount = sharedPreferences.getInt(KeyCoinsCount);
  //   if (coinsCount == null) {
  //     coinsCount = defaultCoinsCount;
  //     sharedPreferences.setInt(KeyCoinsCount, defaultCoinsCount);
  //   }
  //
  //   var myStocksJson = sharedPreferences.getString(KeyMyStocks);
  //   var myStocks = List();
  //   if (myStocksJson != null) {
  //     Iterable jsonObjects = json.decode(myStocksJson);
  //     myStocks = List<Stock>.from(jsonObjects.map((i) => Stock.fromJson(i)));
  //   }
  //   tempMyStocks = myStocks;
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    // loadData();
    return MaterialApp(
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('MainPage'),
            child: StocksListWidget(
              stocks: stocks,
              onStockTapped: _onStockTapped,
              onMyStocksTapped: _onMyStocksTapped,
            ),
          ),
          if (_myStocks != null) MyStocksPage(myStocks: _myStocks),
          if (_selectedStock != null) StockPage(stock: _selectedStock)
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          setState(() {
            _selectedStock = null;
            _myStocks = null;
          });

          return true;
        },
      ),
    );
  }

  _onStockTapped(Stock stock) {
    setState(() {
      _selectedStock = stock;
    });
  }

  _onMyStocksTapped(List<Stock> myStocks) {
    setState(() {
      _myStocks = myStocks;
    });
  }
}

class StocksListWidget extends StatelessWidget {
  final List<Stock> stocks;
  final ValueChanged<Stock> onStockTapped;

  final ValueChanged<List<Stock>> onMyStocksTapped;

  StocksListWidget({
    @required this.stocks,
    @required this.onStockTapped,
    @required this.onMyStocksTapped,
  });

  @override
  Widget build(BuildContext context) {
    var _helloText = "Здравствуйте, у Вас на счету\n${coinsCount.toStringAsFixed(2)} БКС-монет!";

    return Scaffold(
        appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text("Инвестиции"),
            leading: Padding(
                padding: EdgeInsets.all(4),
                child: Image.asset('assets/images/bks_logo.png'))),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.white])),
          child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                  child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(_helloText,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.white))),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                // Visibility(
                //     visible: tempMyStocks.length > 0,
                Container(
                    height: 88,
                    width: double.infinity,
                    child: InkWell(
                        onTap: () => { onMyStocksTapped(tempMyStocks)},
                        child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 2),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    "Ваши акции растут: ",
                                                    style: new TextStyle(
                                                        fontSize: 16.0))),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("${21}%",
                                                    style: new TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.green)),
                                                Text("${1890}\$",
                                                    style: new TextStyle(
                                                        fontSize: 16.0,
                                                        color:
                                                            Color(0xFF999999)))
                                              ],
                                            )
                                          ])),
                                  Padding(padding: EdgeInsets.only(top: 5.0)),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text("Подробнее",
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              color: PrimaryColor)))
                                ]))))),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Text("Купить акции:", style: TextStyle(color: Colors.white)),
                Card(
                    child: Column(children: [
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
                      itemCount: stocks.length,
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.all(0.0),
                            child: ListTile(
                              title: Text(stocks[index].name),
                              subtitle: Text(stocks[index].shortName),
                              leading: CircleAvatar(
                                  child: ClipOval(
                                      child: Image.asset(
                                          stocks[index].logoAsset))),
                              trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${stocks[index].percents.toStringAsFixed(2)}%",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Color(stocks[index].color))),
                                    Text(
                                        "${stocks[index].value.toStringAsFixed(2)}${stocks[index].sign}",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF999999)))
                                  ]),
                              onTap: () => onStockTapped(stocks[index]),
                            ),
                          ))
                ]))
              ]))),
        ));
  }

  double calcMyPercents(List<Stock> myStocks) {
    double sum = 0;
    myStocks.forEach((stock) {
      sum += stock.percents ?? 0.0;
    });
    return sum / myStocks.length;
  }

  double calcMyValues(List<Stock> myStocks) {
    double sum = 0;
    myStocks.forEach((stock) {
      sum += stock.value ?? 0.0;
    });
    return sum / myStocks.length;
  }
}
