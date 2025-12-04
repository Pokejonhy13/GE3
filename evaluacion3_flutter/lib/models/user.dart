class User {
  final int id;
  final String nombre;
  final String email;
  final bool? isActive;

  User({
    required this.id,
    required this.nombre,
    required this.email,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['user_id'] ?? 0;
    final nombre = json['nombre'] ?? json['name'] ?? json['usuario'] ?? '';
    final email = json['email'] ?? json['username'] ?? '';
    final isActive = json['is_active'] ?? json['isActive'];
    return User(id: id, nombre: nombre, email: email, isActive: isActive);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'is_active': isActive,
      };
}
