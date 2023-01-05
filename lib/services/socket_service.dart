import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  connecting,
  online,
  offline,
}

class SocketService with ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  SocketService() {
    print('init');
    _initConfig();
  }

  get serverStatus => _serverStatus;
  set serverStatus(value) => _serverStatus = value;

  void _initConfig() {
    _socket = io(
        'http://192.168.31.248:3000',
        OptionBuilder()
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
  }
}
