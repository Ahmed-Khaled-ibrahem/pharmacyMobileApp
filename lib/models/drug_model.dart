class Drug {
  late String name;
  late String? scientificName;
  late List<String> companies;
  late String? picture;
  late double price;
  late int id;
  late bool isFav;

  Drug({required Map<String, dynamic> drugData}) {
    name = drugData['name'];
    id = drugData['id'];
    price = double.parse(drugData['price'].toString());
    scientificName = drugData['scientific_name'] == "Null"
        ? null
        : drugData['scientific_name'];
    picture = drugData['picture'] == "Null" ? null : drugData['picture'];
    companies = drugData['companies'].toString().split(",");
    isFav = false;
  }
}

class OrderItem {
  Drug drug;
  int quantity;
  OrderItem(this.drug, this.quantity);
}
