
class Quote {

  dynamic current;
  dynamic change;
  dynamic percentChange;

  Quote.fromJson(Map<String, dynamic> json){
    current = json["c"];
    change = json["d"];
    percentChange = json["dp"];
  }
}