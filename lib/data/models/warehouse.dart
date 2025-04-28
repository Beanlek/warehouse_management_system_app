class Warehouse {
  String id;
  String name;
  bool select;

  Warehouse({
    required this.id,
    required this.name,
    this.select = false,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  void clear() {
    id = '';
    name = '';
    select = false;
  }

  factory Warehouse.from(Warehouse other) {
    return Warehouse(
      id: other.id,
      name: other.name,
      select: other.select,
    );
  }

  bool get isNotEmpty => id.isNotEmpty || name.isNotEmpty;

  bool get isEmpty => !isNotEmpty;
}
