class PetModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final String breed;
  final String age;
  final String gender;
  final double price;
  final bool isAdopted;
  final List<String> imageUrls;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.breed,
    required this.age,
    required this.gender,
    required this.price,
    required this.isAdopted,
    required this.imageUrls,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      breed: json['breed'],
      age: json['age'],
      gender: json['gender'],
      price: (json['price'] as num).toDouble(),
      isAdopted: json['isAdopted'],
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'breed': breed,
      'age': age,
      'gender': gender,
      'price': price,
      'isAdopted': isAdopted,
      'imageUrls': imageUrls,
    };
  }

  PetModel copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? breed,
    String? age,
    String? gender,
    double? price,
    bool? isAdopted,
    List<String>? imageUrls,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      price: price ?? this.price,
      isAdopted: isAdopted ?? this.isAdopted,
      imageUrls: imageUrls ?? List<String>.from(this.imageUrls),
    );
  }
}
