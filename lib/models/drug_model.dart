class Drug {
  late String name;
  late String? scientificName;
  late List<String> companies;
  late String? picture;
  late String? details;
  late double price;
  late int id;
  late bool isFav;

  Drug({required Map<String, dynamic> drugData}) {
    name = drugData['name'];
    id = drugData['id'];
    price = drugData['price'];
    scientificName = drugData['scientific_name'];
    companies = drugData['companies'].toString().split(",");
    picture = drugData['picture'];
    details = drugData['details'];
    isFav = drugData['favorite'] == 1;
  }
}

class OrderItem {
  Drug drug;
  int quantity;
  OrderItem(this.drug, this.quantity);
}
