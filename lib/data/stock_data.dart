class Stock {
  String name;
  String shortName;
  String logoAsset;
  String lineAsset;
  String description;

  double percents;
  double value;
  int color;
  String sign;
  double price;

  Stock(this.name, this.shortName, this.logoAsset, this.lineAsset,
      this.description, this.percents, this.value, this.color, this.sign, this.price);

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "shortName": this.shortName,
      "logoAsset": this.logoAsset,
      "lineAsset": this.lineAsset,
      "description": this.description,
      "percents": this.percents,
      "value": this.value,
      "color": this.color,
      "sign": this.sign,
      "price": this.price
    };
  }

  Stock.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortName = json['shortName'];
    logoAsset = json['logoAsset'];
    lineAsset = json['lineAsset'];
    description = json['description'];
    percents = json['percents'];
    value = json['value'];
    color = json['color'];
    sign = json['sign'];
    price = json['price'];
  }

}
