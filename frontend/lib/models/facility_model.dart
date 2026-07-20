class Facility {
  final int id;
  final String name;
  final int categoryId;
  final String address;
  final String city;
  final String state;
  final double lat;
  final double lng;
  final String phone;
  final String description;

  Facility({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.address,
    required this.city,
    required this.state,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.description,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json["id"],
      name: json["name"],
      categoryId: json["category_id"],
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      lat: (json["lat"] ?? 0).toDouble(),
      lng: (json["lng"] ?? 0).toDouble(),
      phone: json["phone"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
