class CategoryInterface {
  final String id;
  final String name;
  final String image;

  CategoryInterface({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryInterface.fromJSON(Map<String, dynamic> json) {
    return CategoryInterface(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }
}

class ReservationInterface {
  final String id;
  final String fullname;
  final String email;
  final String phonenumber;
  final String product;
  final int price;
  final String quantity;

  ReservationInterface({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.product,
    required this.price,
    required this.quantity,
  });

  factory ReservationInterface.fromJSON(Map<String, dynamic> json) {
    return ReservationInterface(
        id: json['_id'] ?? "",
        fullname: json['fullname'] ?? "",
        email: json['email'] ?? "",
        phonenumber: json['phonenumber'] ?? "",
        product: json['product'] ?? "",
        price: json['price'] ?? 0,
        quantity: json['quantity'] ?? "");
  }
}
