
mixin StockTakeComponents {
  late String? refID;

  int conditionsIndex = 0;
  List<String> conditions = [
    'Fresh',
    'Old',
    'Damaged',
    'Recalled',
  ];
  String conditionsSelected = 'Fresh';

  List<String> subCategoryFilters = [];
  List<bool> subCategorySelection = [];
  List<Map<String, dynamic>> filterSelection = [];
  String selectedSubCategoryFilter = '';
  bool showComment = true;
}