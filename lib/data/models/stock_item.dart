class StockItem {
  final int sequence;
  final String skuId;
  final String uomId;
  final List<int> quantity;
  String name;
  String principalName;
  List<int> unreceivedQuantity;

  StockItem({
    required this.sequence,
    required this.skuId,
    required this.uomId,
    required this.quantity,
    this.name = '',
    this.principalName = '',
    required this.unreceivedQuantity,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      sequence: json['sequence'] ?? 0,
      skuId: json['sku_id'] ?? '',
      uomId: json['uom_id'] ?? '',
      quantity: List<int>.from(json['quantity'] ?? []),
      name: json['name'] ?? '',
      principalName: json['principalname'] ?? '',
      unreceivedQuantity: [0,0,0,0]
    );
  }

  Map<String, dynamic> toPostJsonReceived() {
    return {
      "principalname": principalName,
      "sku_id": skuId,
      "uom_id": uomId,
      "quantity": [
        quantity[0],
        quantity[1],
        quantity[2],
        quantity[3],
      ],
    };
  }

  Map<String, dynamic> toPostJsonUnreceived() {
    return {
      "principalname": principalName,
      "sku_id": skuId,
      "uom_id": uomId,
      "quantity": [
        unreceivedQuantity[0],
        0,
        0,
        0
      ],
    };
  }
}
