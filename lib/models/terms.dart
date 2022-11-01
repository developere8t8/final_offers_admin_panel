class TermsData {
  String? id;
  String? terms;
  TermsData({required this.id, required this.terms});

  TermsData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    terms = map['terms'];
  }

  Map<String, dynamic> tomap() {
    return {'id': id, 'terms': terms};
  }
}
