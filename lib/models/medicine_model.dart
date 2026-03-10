class Medicine {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? imageUrl;
  final String? price;
  final String? manufacturer;
  final String? activeIngredient;
  final String? dosage;
  final String? sideEffects;
  final String? warnings;

  Medicine({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.imageUrl,
    this.price,
    this.manufacturer,
    this.activeIngredient,
    this.dosage,
    this.sideEffects,
    this.warnings,
  });

  factory Medicine.fromSearchJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['trade_name']?.toString() ?? '',
      description: json['description']?.toString() ?? json['indication']?.toString(),
      category: json['category']?.toString() ?? json['type']?.toString(),
      imageUrl: json['image']?.toString() ?? json['img']?.toString(),
      price: json['price']?.toString(),
      manufacturer: json['company']?.toString() ?? json['manufacturer']?.toString(),
      activeIngredient: json['active_ingredient']?.toString() ?? json['generic_name']?.toString(),
    );
  }

  factory Medicine.fromInfoJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['trade_name']?.toString() ?? '',
      description: json['description']?.toString() ?? json['indication']?.toString(),
      category: json['category']?.toString() ?? json['type']?.toString(),
      imageUrl: json['image']?.toString() ?? json['img']?.toString(),
      price: json['price']?.toString(),
      manufacturer: json['company']?.toString() ?? json['manufacturer']?.toString(),
      activeIngredient: json['active_ingredient']?.toString() ?? json['generic_name']?.toString(),
      dosage: json['dosage']?.toString() ?? json['dose']?.toString(),
      sideEffects: json['side_effects']?.toString() ?? json['side_effect']?.toString(),
      warnings: json['warnings']?.toString() ?? json['warning']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category,
    'imageUrl': imageUrl,
    'price': price,
    'manufacturer': manufacturer,
    'activeIngredient': activeIngredient,
    'dosage': dosage,
    'sideEffects': sideEffects,
    'warnings': warnings,
  };

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'],
    category: json['category'],
    imageUrl: json['imageUrl'],
    price: json['price'],
    manufacturer: json['manufacturer'],
    activeIngredient: json['activeIngredient'],
    dosage: json['dosage'],
    sideEffects: json['sideEffects'],
    warnings: json['warnings'],
  );
}
