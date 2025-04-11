import 'package:butcher_management/models/meat_model.dart';
import 'package:flutter/material.dart';

class MeatState extends ChangeNotifier {
  final List<MeatModel> _meatList = [];

  List<MeatModel> get meatList => _meatList;

  void addMeat(MeatModel meat) {
    _meatList.add(meat);
    notifyListeners();
  }

  void removeMeat(MeatModel meat) {
    _meatList.remove(meat);
    notifyListeners();
  }

  List<MeatModel> getWarningExpirationMeats() {
    DateTime now = DateTime.now();

    return _meatList.where((meat) {
      DateTime expirationDate =
          meat.createdAt.add(Duration(days: meat.expirationDays));
      int daysToExpire = expirationDate.difference(now).inDays;

      return daysToExpire > 0 && daysToExpire <= 5;
    }).toList();
  }

  List<MeatModel> getExpiredMeats() {
    DateTime now = DateTime.now();

    return _meatList.where((meat) {
      DateTime expirationDate =
          meat.createdAt.add(Duration(days: meat.expirationDays));
      int daysToExpire = expirationDate.difference(now).inDays;

      return expirationDate.isBefore(now) || daysToExpire == 0;
    }).toList();
  }

  int calcDaysToExpire(DateTime createdAt, int expirationDays) {
    DateTime now = DateTime.now();
    DateTime expirationDate = createdAt.add(Duration(days: expirationDays));
    int daysToExpire = expirationDate.difference(now).inDays;
    return daysToExpire;
  }
}
