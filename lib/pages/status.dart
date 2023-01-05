import 'package:band_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SocketService socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${socketService.serverStatus}'),
          ],
        ),
      ),
    );
  }
}
