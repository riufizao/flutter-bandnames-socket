import 'package:band_app/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Soda Stereo', votes: 5),
    Band(id: '2', name: 'Caifanes', votes: 4.5),
    Band(id: '3', name: 'Heroes Del Silencio', votes: 4),
    Band(id: '4', name: 'Los Tres', votes: 3.5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Band Names',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, int i) {
          return _bandTile(bands[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete band',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onDismissed: (direction) {
        print(direction);
        print(band.id);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void _addNewBand() {
    final textController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band Name'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => _addBandToList(textController.text),
                elevation: 5,
                child: const Text('Add'),
              )
            ],
          );
        });
  }

  void _addBandToList(String name) {
    bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
    Navigator.pop(context);
    setState(() {});
  }
}
