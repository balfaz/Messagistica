import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:secret_chat/app_config.dart';

typedef void OnNewMessage(dynamic data);
typedef void OnConnected(dynamic data);
typedef void OnJoined(dynamic data);
typedef void OnDisconnected(dynamic data);
typedef void OnNewFile(dynamic data);

class socketCliente {
  final _manager = SocketIOManager();
  SocketIO _socketIO;

  OnNewMessage onNewMessage;
  OnConnected onConnected;
  OnJoined onJoined;
  OnDisconnected onDisconnected;
  OnNewFile onNewFile;

  connect(String token) async {
    final options = SocketOptions(appConfig.socketHost,
        query: {"token": token}, enableLogging: false);

    _socketIO = await _manager.createInstance(options);

    _socketIO.on('connected', (data) {
      if (onConnected != null) {
        onConnected(data);
      }
    });

    _socketIO.on('joined', (data) {
      if (onJoined != null) {
        onJoined(data);
      }
      //print("joined : ${data.toString()}");
    });

    _socketIO.on('disconnected', (data) {
      print("desconnected  ${data.toString()}");
      if (onDisconnected != null) {
        onDisconnected(data);
      }
      //print("joined : ${data.toString()}");
    });

    _socketIO.on('new-message', (data) {
      if (OnNewMessage != null) {
        onNewMessage(data);
      }
    });

    _socketIO.on('new-file', (data) {
      if (OnNewFile != null) {
        onNewFile(data);
      }
    });

    _socketIO.connect();

    _socketIO.onError((error) {
      print("on error : ${error.toString()}");
    });
  }

  disconnect() async {
    await _manager.clearInstance(_socketIO);
  }

  emit(String eventName, dynamic data) {
    _socketIO.emit(eventName, [data]);
  }
}
