class Inventory {
  String? brand;
  String? category;
  String? subCategory;
  String? skuId;
  String? skuName;
  int? sequence;
  String? uomId;
  String? shortCode;
  String? name;
  int? quantity; // Changed from List<int> to int

  Inventory({
    this.brand,
    this.category,
    this.subCategory,
    this.skuId,
    this.skuName,
    this.sequence,
    this.uomId,
    this.shortCode,
    this.name,
    this.quantity,
  });

  Inventory.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    category = json['category'];
    subCategory = json['sub_category'];
    skuId = json['sku_id'];
    skuName = json['sku_name'];
    sequence = json['sequence'];
    uomId = json['uom_id'];
    shortCode = json['short_code'];
    name = json['name'];
    quantity = json['quantity'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    data['category'] = category;
    data['sub_category'] = subCategory;
    data['sku_id'] = skuId;
    data['sku_name'] = skuName;
    data['sequence'] = sequence;
    data['uom_id'] = uomId;
    data['short_code'] = shortCode;
    data['name'] = name;
    data['quantity'] = quantity;
    return data;
  }
}
