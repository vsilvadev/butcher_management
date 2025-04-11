import 'package:butcher_management/screens/home_screen.dart';
import 'package:butcher_management/states/meat_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeatScreen extends StatelessWidget {
  const MeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meatState = context.read<MeatState>();
    final meatList = meatState.meatList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carnes Cadastradas',
        ),
      ),
      body: ListView.builder(
        itemCount: meatList.length,
        itemBuilder: (context, index) {
          final meat = meatList[index];
          return MeatCard(
            meatName: meat.name,
            meatId: meat.name,
            fridge: meat.fridgeId,
            expirationDays: meatState.calcDaysToExpire(
              meat.createdAt,
              meat.expirationDays,
            ),
            responsibleEmployee: meat.responsibleEmployee,
          );
        },
      ),
    );
  }
}
