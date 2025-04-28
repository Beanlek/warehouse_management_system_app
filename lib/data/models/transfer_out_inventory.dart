class TOInventory {
  String brand;
  String category;
  String subCategory;
  String skuId;
  String skuName;
  int sequence;
  String uomId;
  String shortCode;
  String name;
  List<int> quantity;
  List<int> quantityInput;
  List<String> availableSkuConversion;

  TOInventory({
    required this.brand,
    required this.category,
    required this.subCategory,
    required this.skuId,
    required this.skuName,
    required this.sequence,
    required this.uomId,
    required this.shortCode,
    required this.name,
    required this.quantity,
    this.quantityInput = const [0,0,0,0,0,0,0],
    required this.availableSkuConversion,
  });

  factory TOInventory.fromJson(Map<String, dynamic> json) {
    
    final quantityRaw = List.from(json['quantity'] as List);
    for (var i = 0; i < quantityRaw.length; i++) {
      quantityRaw[i] ??= 0;
    }

    final availableSkuConversionRaw = List.from(json['available_sku_conversion'] as List);
    for (var i = 0; i < availableSkuConversionRaw.length; i++) {
      availableSkuConversionRaw[i] ??= "NA";
    }
    
    return TOInventory(
      brand : json['brand'] ?? 'NA',
      category : json['category'] ?? 'NA',
      subCategory : json['sub_category'] ?? 'NA',
      skuId : json['sku_id'] ?? 'NA',
      skuName : json['sku_name'] ?? 'NA',
      sequence : json['sequence'] ?? 0,
      uomId : json['uom_id'] ?? 'NA',
      shortCode : json['short_code'] ?? 'NA',
      name : json['name'] ?? 'NA',
      quantity : List.from(quantityRaw),
      availableSkuConversion : List.from(availableSkuConversionRaw),
    );
  }

  void clear() {
    brand = '';
    category = '';
    subCategory = '';
    skuId = '';
    skuName = '';
    sequence = -1;
    uomId = '';
    shortCode = '';
    name = '';
    quantity = [];
    availableSkuConversion = [];
  }

  factory TOInventory.from(TOInventory other) {
    return TOInventory(
      brand: other.brand,
      category: other.category,
      subCategory: other.subCategory,
      skuId: other.skuId,
      skuName: other.skuName,
      sequence: other.sequence,
      uomId: other.uomId,
      shortCode: other.shortCode,
      name: other.name,
      quantity: other.quantity,
      availableSkuConversion: other.availableSkuConversion,
    );
  }

  bool get isNotEmpty =>
    brand.isNotEmpty ||
    category.isNotEmpty ||
    subCategory.isNotEmpty ||
    skuId.isNotEmpty ||
    skuName.isNotEmpty ||
    sequence >= 0 ||
    uomId.isNotEmpty ||
    shortCode.isNotEmpty ||
    name.isNotEmpty ||
    quantity.isNotEmpty ||
    availableSkuConversion.isNotEmpty;

  bool get isEmpty => !isNotEmpty;
}
