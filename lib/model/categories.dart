class Categories {
  String? icon;
  String name;
  bool isExpansion;
  bool isOpen;
  String code;

  Categories(
      {this.icon,
      required this.name,
      this.isExpansion = false,
      this.code="",
      this.isOpen = false});
}

class SelectedCategories {
  String catName;
  bool isSelected;
  int id;

  SelectedCategories(
      {required this.catName, this.isSelected = false, this.id = 0});
}
