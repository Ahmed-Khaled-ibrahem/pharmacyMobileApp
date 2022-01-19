import 'package:pharmacyapp/models/drug_model.dart';

class OfferItem {
  Drug drug;
  bool percentage = true;
  int offer;

  OfferItem(this.drug, this.offer, {bool isPercentage = true}) {
    percentage = isPercentage;
  }
}
