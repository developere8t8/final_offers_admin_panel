class CategoryData {
  String? id;
  String? category;
  bool? active;

  CategoryData({required this.category, required this.active, required this.id});

  CategoryData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    category = map['category'];
    active = map['active'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category, 'active': active};
  }
}
