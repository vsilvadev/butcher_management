import 'package:butcher_management/screens/meat_registration_screen.dart';
import 'package:butcher_management/screens/meat_screen.dart';
import 'package:butcher_management/states/meat_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sabor da Morte',
        ),
      ),
      body: Center(
          child: Column(
        children: [
          ExpirationMeatWidget(screenHeight: screenHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MeatRegistrationScreen()),
                ),
                child: Text(
                  'Cadastrar Carne',
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MeatScreen()),
                ),
                child: Text(
                  'Ver carnes',
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}

class ExpirationMeatWidget extends StatelessWidget {
  final double screenHeight;

  const ExpirationMeatWidget({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    final meatState = context.watch<MeatState>();
    final warningMeats = meatState.getWarningExpirationMeats();
    final expiredMeats = meatState.getExpiredMeats();

    return Center(
      child: Container(
        alignment: Alignment.center,
        height: screenHeight * 0.75,
        child: Column(
          children: [
            Text(
              'Carnes com validade próxima:',
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 3.0,
                      offset: Offset(2.0, 2.0),
                      color: Colors.black,
                    ),
                  ],
                  fontSize: screenHeight * 0.03,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: screenHeight * 0.30,
              child: ListView.builder(
                itemCount: warningMeats.length,
                itemBuilder: (context, index) {
                  final meat = warningMeats[index];
                  return MeatCard(
                    meatName: meat.name,
                    meatId: meat.id,
                    fridge: meat.fridgeId,
                    expirationDays: meatState.calcDaysToExpire(
                      meat.createdAt,
                      meat.expirationDays,
                    ),
                    responsibleEmployee: meat.responsibleEmployee,
                  );
                },
              ),
            ),
            Text(
              'Carnes vencidas:',
              style: TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                    color: Colors.black,
                  ),
                ],
                fontSize: screenHeight * 0.03,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.30,
              child: ListView.builder(
                itemCount: expiredMeats.length,
                itemBuilder: (context, index) {
                  final meat = expiredMeats[index];
                  return MeatCard(
                    meatName: meat.name,
                    meatId: meat.id,
                    fridge: meat.fridgeId,
                    expirationDays: meatState.calcDaysToExpire(
                      meat.createdAt,
                      meat.expirationDays,
                    ),
                    responsibleEmployee: meat.responsibleEmployee,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeatCard extends StatelessWidget {
  final String meatName;
  final String meatId;
  final String fridge;
  final int expirationDays;
  final String responsibleEmployee;

  const MeatCard({
    super.key,
    required this.meatName,
    required this.meatId,
    required this.fridge,
    required this.expirationDays,
    required this.responsibleEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IntrinsicWidth(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    RichText(
                        text: TextSpan(
                      text: 'Nome da carne: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: meatName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    )),
                    RichText(
                        text: TextSpan(
                      text: 'Geladeira: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: fridge,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                SizedBox(
                  width: 24,
                ),
                Column(
                  children: [
                    expirationDays <= 0
                        ? ElevatedButton.icon(
                            onPressed: () {
                              final meatState = context.read<MeatState>();
                              final meatToRemove = meatState.meatList
                                  .firstWhere((meat) => meat.id == meatId);
                              meatState.removeMeat(meatToRemove);
                            },
                            label: const Text(
                              'Remover',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            icon: const Icon(
                              Icons.close,
                              size: 24.0,
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                            text: 'Dias pra vencer: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: expirationDays.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          )),
                    RichText(
                        text: TextSpan(
                      text: 'Responsável: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: responsibleEmployee,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
