class Sku {
  final String skuId;
  final String uomId;
  final String name;
  final String principalName;
  final bool baseUom;

  int? fresh;
  int? damaged;
  int? old;
  int? recalled;
  int? unreceived;

  Sku({
    required this.skuId,
    required this.uomId,
    required this.name,
    required this.principalName,
    required this.baseUom,
    this.fresh,
    this.damaged,
    this.old,
    this.recalled,
    this.unreceived,
  });

  factory Sku.fromJson(Map<String, dynamic> json) {
    return Sku(
      skuId: json['sku_id'] ?? '',
      uomId: json['uom_id'] ?? '',
      name: json['name'] ?? '',
      principalName: json['principalname'] ?? '',
      baseUom: json['base_uom'] ?? false,
    );
  }

  Map<String, dynamic> toPostJsonReceived() {
    return {
      "principalname": principalName,
      "sku_id": skuId,
      "uom_id": uomId,
      "quantity": [
        fresh ?? 0,
        damaged ?? 0,
        old ?? 0,
        recalled ?? 0,
      ],
    };
  }
  
  Map<String, dynamic> toPostJsonUnreceived() {
    return {
      "principalname": principalName,
      "sku_id": skuId,
      "uom_id": uomId,
      "quantity": [
        unreceived ?? 0,
        0,
        0,
        0,
      ],
    };
  }

  bool hasValidReceivedValues() {
    return (fresh != null && fresh! > 0) ||
        (damaged != null && damaged! > 0) ||
        (old != null && old! > 0) ||
        (recalled != null && recalled! > 0);
  }

  bool hasValidUnreceivedValues() {
    return (unreceived != null && unreceived! > 0);
  }
}
