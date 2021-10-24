import 'package:growbox/plant.dart';
import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard(this.plant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: ListTile(
              leading: const Icon(Icons.local_florist),
              title: Text(plant.name),
              subtitle:
                  Text('Last watered: ${readableEvent(plant.lastWatered())}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    plant.water();
                    plant.save();
                  },
                  icon: const Icon(Icons.water_outlined),
                  label: Text('Water'.toUpperCase()),
                ),
                SizedBox.fromSize(size: const Size(8.0, 0.0)),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.healing),
                  label: Text('Update Health'.toUpperCase()),
                ),
                Expanded(child: Container()),
                PlantOverflowMenu(plant: plant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String readableEvent(DateTime? event) {
    if (event != null) {
      var d = DateTime.now().difference(event);
      if (d < const Duration(minutes: 1)) {
        return 'just now';
      } else if (d < const Duration(minutes: 2)) {
        return '1 minute ago';
      } else if (d < const Duration(hours: 1)) {
        return '${d.inMinutes} minutes ago';
      } else if (d < const Duration(hours: 2)) {
        return '1 hour ago';
      } else if (d < const Duration(days: 1)) {
        return '${d.inHours} hours ago';
      } else if (d < const Duration(days: 2)) {
        return 'yesterday';
      } else {
        return '${d.inDays} days ago';
      }
    } else {
      return 'never';
    }
  }
}

class PlantOverflowMenu extends StatelessWidget {
  final Plant plant;

  const PlantOverflowMenu({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (OverflowOption option) {
        switch (option) {
          case OverflowOption.delete:
            plant.delete();
            break;
          case OverflowOption.rename:
            renameDialog(context, plant);
            break;
        }
      },
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: OverflowOption.rename,
          child: Text('Rename'),
        ),
        PopupMenuItem(
          value: OverflowOption.delete,
          child: Text('Delete',
              style: TextStyle(color: Theme.of(context).errorColor)),
        ),
      ],
    );
  }

  Future<void> renameDialog(BuildContext context, Plant plant) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            final form = GlobalKey<FormState>();
            var name = plant.name;

            return AlertDialog(
              title: const Text('Rename'),
              content: Form(
                key: form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  initialValue: name,
                  validator: (String? value) {
                    var stripped = value?.trim();
                    if (stripped == null || stripped.isEmpty) {
                      return 'Name can\'t be empty';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String? value) {
                    name = value!;
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      form.currentState!.save();
                      plant.name = name;
                      plant.save();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Rename'.toUpperCase()),
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

enum OverflowOption {
  delete,
  rename,
}
