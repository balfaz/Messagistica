import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:secret_chat/models/message_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Chat extends StatefulWidget {
  final String userID;
  final List<Message> messages;
  final Function(String, bool) onSend;

  const Chat(this.userID,
      {Key key, this.messages = const [], @required this.onSend})
      : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  var _isTheEnd = false;
  var unRead = 0;
  List<StorageUploadTask> _tasks = List();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _onSend() {
    final text = _controller.value.text;
    if (text.trim().length == 0) {
      return;
    }

    if (widget.onSend != null) {
      widget.onSend(text, true);
    }
    _controller.text = '';
  }

  goToEnd() {
    setState(() {
      unRead = 0;
    });
    Timer(Duration(milliseconds: 300), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  checkUnread() {
    if (_scrollController.position.maxScrollExtent == 0) return;
    if (_isTheEnd) {
      goToEnd();
    } else {
      setState(() {
        unRead++;
      });
    }
  }

  pickImage() async {
    //String error;
    // List<Asset> assets;
    try {
      List<Asset> assets = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
      );

      StorageReference ref = FirebaseStorage.instance.ref();
      for (Asset asset in assets) {
        final path = await asset.identifier;
        //final ByteData data = await load(asset);
        final ext = extension(path);
        final fileName = "${DateTime.now().millisecondsSinceEpoch}.$ext";

        final byteData = await asset.getByteData();
        final imageData = byteData.buffer.asUint8List();

        final task =
            ref.child("/users/${widget.userID}/$fileName").putData(imageData);

        task.events.listen((StorageTaskEvent event) async {
          if (task.isComplete && task.isSuccessful) {
            final url = await event.snapshot.ref.getDownloadURL();
            //print("file $url");
            widget.onSend(url, false);
            _tasks.remove(task);
            setState(() {});
          } else if (task.isComplete) {
            _tasks.remove(task);
            setState(() {});
          }
        });

        _tasks.add(task);
        setState(() {});
      }
    } on Exception catch (e) {
      String error = e.toString();
      print(error);
    }
  }

  Widget _item(Message message) {
    final isMe = widget.userID == message.id;
    return Container(
      child: Wrap(
        alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: isMe ? Colors.cyan : Colors.yellow,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isMe
                      ? SizedBox(width: 0)
                      : Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            '@${message.username},',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ),
                  message.type == MessageType.image
                      ? CachedNetworkImage(
                          imageUrl: message.message,
                          width: 150.0,
                          placeholder: (BuildContext context, String string) {
                            return Center(
                              child: CupertinoActivityIndicator(
                                radius: 15,
                              ),
                            );
                          },
                        )
                      : Text(
                          message.message,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: NotificationListener(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: widget.messages.length,
                        itemBuilder: (context, index) {
                          final message = widget.messages[index];
                          return _item(message);
                        }),
                    onNotification: (t) {
                      if (t is ScrollEndNotification) {
                        print("end to Scroll");
                        if (_scrollController.offset !=
                            _scrollController.position.maxScrollExtent) {
                          _isTheEnd = true;
                        } else {
                          _isTheEnd = false;
                        }
                      }
                      return false;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: CupertinoTextField(
                        controller: _controller,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Color(0xffd2d2d2),
                            borderRadius: BorderRadius.circular(20.0)),
                      )),
                      SizedBox(
                        width: 10.0,
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.all(5.0),
                        minSize: 30.0,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        child: Icon(Icons.image),
                        onPressed: pickImage,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        minSize: 30.0,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                        child: Text("Send"),
                        onPressed: _onSend,
                      ),
                    ],
                  ),
                )
              ],
            ),
            unRead > 0
                ? Positioned(
                    left: 30.0,
                    bottom: 60.0,
                    child: Stack(
                      children: <Widget>[
                        CupertinoButton(
                          color: Colors.grey[350].withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                          padding: EdgeInsets.all(5),
                          child:
                              Icon(Icons.arrow_downward, color: Colors.black),
                          onPressed: goToEnd,
                        ),
                        unRead > 0
                            ? Positioned(
                                top: 5.0,
                                right: 5.0,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green),
                                  child: Center(
                                    child: Text(
                                      unRead.toString(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ))
                            : Container(),
                      ],
                    ))
                : Container(),
            _tasks.length > 0
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 70,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Updating image (${_tasks.length})...',
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black12)]),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
