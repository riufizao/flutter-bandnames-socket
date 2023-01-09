import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  connecting,
  online,
  offline,
}

class SocketService with ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  SocketService() {
    print('init');
    _initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;
  set serverStatus(value) => _serverStatus = value;
  io.Socket get socket => _socket;

  void _initConfig() {
    _socket = io.io(
        //cambiar ip cada que se conectar a la red
        'http://192.168.31.248:3000',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    _socket.onConnect((_) {
      print('onConnect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('onDisconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('new_msg', (payload) => print(payload));
  }
}
