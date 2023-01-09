import 'package:band_app/models/band.dart';
import 'package:band_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active_bands', (payload) {
      /*  for (var band in payload) {
        Band bandMap = Band.fromMap(band);
        bands.add(bandMap);
      } */

      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active_bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SocketService socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
        title: const Center(
          child: Text(
            'Band Names',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showChart(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, int i) {
                return _bandTile(bands[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

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
      onDismissed: (_) {
        socketService.socket.emit('delete_band', {'id': band.id});
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
        onTap: () {
          socketService.socket.emit('votes_app', {'id': band.id});
        },
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.emit('add_band', {'name': name});
    Navigator.pop(context);
    setState(() {});
  }

  Widget _showChart() {
    Map<String, double> bandsMap = {
      for (var e in bands) e.name: e.votes.toDouble()
    };

    return PieChart(
      dataMap: bandsMap,
      chartType: ChartType.ring,
      chartValuesOptions: const ChartValuesOptions(decimalPlaces: 0),
    );
  }
}
