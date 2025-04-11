class MeatModel {
  String id;
  String name;
  String responsibleEmployee;
  String fridgeId;
  DateTime createdAt;
  int expirationDays;

  MeatModel({
    required this.id,
    required this.name,
    required this.responsibleEmployee,
    required this.fridgeId,
    required this.createdAt,
    required this.expirationDays,
  });
}
