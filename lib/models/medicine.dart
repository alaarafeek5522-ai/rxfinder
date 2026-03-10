class Medicine {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? image;
  final String? price;
  final String? company;
  final String? activeIngredient;
  final String? usage;
  final String? warnings;
  final String? dosage;

  Medicine({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.image,
    this.price,
    this.company,
    this.activeIngredient,
    this.usage,
    this.warnings,
    this.dosage,
  });

  factory Medicine.fromSearchJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      image: json['image']?.toString(),
      price: json['price']?.toString(),
      company: json['company']?.toString(),
    );
  }

  factory Medicine.fromInfoJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      image: json['image']?.toString(),
      price: json['price']?.toString(),
      company: json['company']?.toString(),
      activeIngredient: json['active_ingredient']?.toString(),
      usage: json['usage']?.toString(),
      warnings: json['warnings']?.toString(),
      dosage: json['dosage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category,
    'image': image,
    'price': price,
    'company': company,
  };
}
