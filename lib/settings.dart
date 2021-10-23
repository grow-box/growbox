import 'package:flutter/material.dart';
import 'package:growbox/plant.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ValueListenableBuilder(
                valueListenable:
                    Hive.box('settings').listenable(keys: ['dark_mode']),
                builder: (context, Box box, _) {
                  return SwitchListTile.adaptive(
                      title: const Text('Dark Mode'),
                      value: box.get('dark_mode', defaultValue: false),
                      onChanged: (value) {
                        box.put('dark_mode', value);
                      });
                }),
            const Divider(),
            Center(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (_) => Theme.of(context).errorColor),
                ),
                onPressed: () async {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Clear local data?'),
                          content: const SingleChildScrollView(
                            child: Text(
                                'This will delete all plants, plant history, and settings.'),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Hive.box<Plant>('plants').clear();
                                Hive.box('settings').clear();
                                Navigator.pop(context);
                              },
                              child: Text('Delete'.toUpperCase()),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (_) => Theme.of(context).errorColor),
                              ),
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
                },
                icon: const Icon(Icons.delete_forever),
                label: Text('Clear local data'.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
