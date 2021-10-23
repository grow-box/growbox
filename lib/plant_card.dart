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
                PopupMenuButton(
                  onSelected: (_) {
                    plant.delete();
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete',
                          style:
                              TextStyle(color: Theme.of(context).errorColor)),
                    ),
                  ],
                ),
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
      // TODO: use relative terms like 'yesterday' based on date rather than absolute time
      // TODO: use singular nouns, e.g. '1 minute ago' rather than '1 minutes ago'
      if (d < const Duration(minutes: 1)) {
        return 'just now';
      } else if (d < const Duration(hours: 1)) {
        return '${d.inMinutes} minutes ago';
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
