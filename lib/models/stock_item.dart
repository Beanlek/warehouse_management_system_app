class StockItem {
  final int sequence;
  final String skuId;
  final String uomId;
  final List<int> quantity;

  StockItem({
    required this.sequence,
    required this.skuId,
    required this.uomId,
    required this.quantity,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      sequence: json['sequence'] ?? 0,
      skuId: json['sku_id'] ?? '',
      uomId: json['uom_id'] ?? '',
      quantity: List<int>.from(json['quantity'] ?? []),
    );
  }
}
