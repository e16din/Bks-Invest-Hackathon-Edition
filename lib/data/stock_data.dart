class Stock {
  String name;
  String shortName;
  String logoAsset;
  String lineAsset;
  String description;

  double percents;
  double value;
  int color;

  Stock(this.name, this.shortName, this.logoAsset, this.lineAsset,
      this.description, this.percents, this.value, this.color);

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "shortName": this.shortName,
      "logoAsset": this.logoAsset,
      "lineAsset": this.lineAsset,
      "description": this.description,
      "percents": this.percents,
      "value": this.value
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
  }

  static from(Stock json) {

  }
}
