import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'plant.g.dart';

@HiveType(typeId: 2)
class Watered {
  @HiveField(0)
  final DateTime time;

  Watered({DateTime? time}) : time = time ?? DateTime.now();
}

@HiveType(typeId: 3)
class Health {
  @HiveField(0)
  final DateTime time;

  Health({DateTime? time}) : time = time ?? DateTime.now();
}

@HiveType(typeId: 1)
class Plant extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<Watered> waterHistory;
  static const _uuid = Uuid();

  Plant({required this.name, List<Watered>? waterHistory, String? id})
      : id = id ?? _uuid.v1(),
        waterHistory = waterHistory ?? List.empty(growable: true);

  DateTime? lastWatered() {
    if (waterHistory.isNotEmpty) {
      return waterHistory.last.time;
    } else {
      return null;
    }
  }

  void water() {
    waterHistory.add(Watered());
  }
}
