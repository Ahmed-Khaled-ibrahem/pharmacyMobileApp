import 'package:pharmacyapp/models/drug_model.dart';

class OfferItem {
  Drug drug;
  bool percentage = true;
  double offer;

  OfferItem(this.drug, this.offer, {bool isPercentage = true}) {
    percentage = isPercentage;
  }
}
