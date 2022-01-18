class Drug {
  late String name;
  late String? scientificName;
  late List<String> companies;
  late String? picture;
  late String? details;
  late double price;
  late int id;
  late bool idFav;

  Drug({required Map<String, dynamic> drudData}) {
    name = drudData['name'];
    id = drudData['id'];
    price = drudData['price'];
    scientificName = drudData['scientific_name'];
    companies = drudData['companies'].toString().split(",");
    picture = drudData['picture'];
    details = drudData['details'];
    idFav = drudData['favorite'] == 1;
  }
}

class OrderItem {
  Drug drug;
  int quantity;
  OrderItem(this.drug, this.quantity);
}
