import 'package:flutter/material.dart';
import 'package:growbox/plant.dart';
import 'package:hive/hive.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        addPlantDialog(context);
      },
      icon: const Icon(Icons.add),
      tooltip: 'Add plant',
    );
  }

  Future<void> addPlantDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            String name = '';
            return AlertDialog(
              content: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add Plant',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.start,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (String? value) {
                        var stripped = value?.trim();
                        if (stripped == null || stripped.isEmpty) {
                          return 'Enter a name to identify this plant';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String? value) {
                        name = value!;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Hive.box<Plant>('plants').add(Plant(name: name));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'.toUpperCase()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'.toUpperCase()),
                ),
              ],
            );
          });
        });
  }
}
