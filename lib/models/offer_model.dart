class OfferItem {
  int drugId;
  bool percentage = true;
  int offer;

  OfferItem(this.drugId, this.offer, {bool isPercentage = true}) {
    percentage = isPercentage;
  }
}
