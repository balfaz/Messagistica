//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret_chat/models/message_model.dart';
import 'package:secret_chat/provider/chat_provider.dart';
import 'package:secret_chat/utils/dialogs.dart';
//import 'package:secret_chat/utils/responsive.dart';
import 'package:secret_chat/provider/me.dart';
import 'package:secret_chat/utils/session.dart';
import 'package:secret_chat/utils/socket_client.dart';
import 'package:secret_chat/api/auth_api.dart';
import 'package:secret_chat/widgets/chat.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _chatKey = GlobalKey<ChatState>();
  Me _me;
  final _authAPI = AuthAPI();
  final _socketClient = socketCliente();
  ChatProvider _chat;

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  void dispose() {
    _socketClient.disconnect();
    super.dispose();
  }

  _connectSocket() async {
    final token = await _authAPI.getAccessToken();
    await _socketClient.connect(token);
    _socketClient.onNewMessage = (data) => _addNewMessage(data, true);

    _socketClient.onConnected = (data) {
      final user = Map<String, dynamic>.from(data['connectedUsers']);
      print("${user.length}");
      _chat.counter = user.length;
    };

    _socketClient.onNewFile = (data) => _addNewMessage(data, false);

    _socketClient.onJoined = (data) {
      _chat.counter++;
    };

    _socketClient.onDisconnected = (data) {
      if (_chat.counter > 0) {
        _chat.counter--;
      }
    };
  }

  _addNewMessage(dynamic data, bool isText) {
    final message = Message(
        id: data['from']['id'],
        message: isText ? data['message'] : data['image']['url'],
        type: isText ? MessageType.text : data['file']['type'],
        username: data['from']['username'],
        createdAt: DateTime.now());
    _chat.addMessage(message);
    _chatKey.currentState.checkUnread();
  }

  _sendMessage(String text, bool isText) {
    Message message = Message(
        id: _me.data.id,
        username: _me.data.username,
        message: text,
        type: isText ? MessageType.text : MessageType.image,
        createdAt: DateTime.now());

    if (isText) {
      _socketClient.emit('send', text);
    } else {
      _socketClient.emit('send-file', {"type": MessageType.image, "url": text});
    }

    _chat.addMessage(message);
    _chatKey.currentState?.goToEnd();
  }

  @override
  Widget build(BuildContext context) {
    _me = Me.of(context);
    _chat = ChatProvider.of(context);

    //final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connected  (${_chat.counter})",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'share', child: Text('Share')),
              PopupMenuItem(value: 'exit', child: Text('Exit')),
            ],
            onSelected: (String value) {
              if (value == 'exit') {
                _onExit();
              }
            },
          ),
        ],
        elevation: 1,
      ),
      body: SafeArea(
        child: Chat(
          _me.data.id,
          key: _chatKey,
          onSend: _sendMessage,
          messages: _chat.messages,
        ),
      ),
    );
  }

  _onExit() {
    Dialogs.confirm(context, title: "Confirm", message: "Are you sure?",
        onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () async {
      Session session = Session();
      await session.clearSession();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
    });
  }
}
