

class Company {

  dynamic current;
  dynamic change;
  dynamic percentChange;

  Company.fromJson(Map<String, dynamic> json){
    current = json["c"];
    change = json["d"];
    percentChange = json["dp"];

  }
}