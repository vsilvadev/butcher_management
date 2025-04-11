import 'package:butcher_management/models/meat_model.dart';
import 'package:butcher_management/states/meat_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MeatRegistrationScreen extends StatefulWidget {
  const MeatRegistrationScreen({super.key});

  @override
  State<MeatRegistrationScreen> createState() => _MeatRegistrationScreenState();
}

class _MeatRegistrationScreenState extends State<MeatRegistrationScreen> {
  String fridge = '';
  final TextEditingController meatType = TextEditingController();
  final TextEditingController employee = TextEditingController();
  final TextEditingController expirationDate = TextEditingController();
  final uuid = Uuid();

  @override
  void dispose() {
    meatType.dispose();
    employee.dispose();
    expirationDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meatState = context.read<MeatState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro de Carne',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: meatType,
                decoration: InputDecoration(
                  labelText: 'Tipo de Carne',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: employee,
                decoration: InputDecoration(
                  labelText: 'Nome do responsável',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              PopupMenuButton(
                  onSelected: (String value) {
                    setState(() {
                      fridge = value;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.kitchen_outlined, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              fridge.isEmpty ? 'Selecione a geladeira' : fridge,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'opcao1',
                        child: Text(
                          'Geladeira 1',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'opcao2',
                        child: Text(
                          'Geladeira 2',
                        ),
                      ),
                    ];
                  }),
              SizedBox(height: 16),
              TextField(
                controller: expirationDate,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Dias pra vencer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final expirationDays = int.tryParse(expirationDate.text);
                  final createdAt = DateTime.now();

                  final MeatModel meat = MeatModel(
                    id: uuid.v4(),
                    name: meatType.text,
                    responsibleEmployee: employee.text,
                    fridgeId: fridge,
                    expirationDays: expirationDays ?? 0,
                    createdAt: createdAt,
                  );

                  try {
                    meatState.addMeat(meat);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Carne cadastrada com sucesso!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao cadastrar carne!'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Cadastrar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
