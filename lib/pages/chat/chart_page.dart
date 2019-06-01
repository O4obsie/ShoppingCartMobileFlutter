import 'package:flutter/material.dart';
import 'package:hello_world/app_store/app_state.dart';
import 'package:hello_world/app_store/chat_provider.dart';
import 'package:hello_world/models/chat_message.dart';
import 'package:hello_world/models/online_user.dart';
import 'package:hello_world/pages/chat/received_message.dart';
import 'package:hello_world/pages/chat/sent_message.dart';
import 'package:provider/provider.dart';
class ChatPage extends StatelessWidget {
  final OnlineUserModel onlineUser;
  const ChatPage({Key key, this.onlineUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chatStte = Provider.of<ChatProvider>(context);
    final authstate = Provider.of<AppState>(context);
    final filtredMessages =chatStte.getMessages().where((message) {
                return (message.toId==onlineUser.id &&
                        message.fromId ==
                            authstate.getUserLoginDetails().userDetails.id) ||
                    (message.toId ==
                            authstate.getUserLoginDetails().userDetails.id &&
                        message.fromId == onlineUser.id);
              }).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(onlineUser.firstName),
        ),
        body: Column(
          children: <Widget>[
            new Flexible(
                child: ListView.builder(
              itemCount: filtredMessages.length,
              itemBuilder: (context, int index) {
                double cWidth = MediaQuery.of(context).size.width * 0.8;
                if (filtredMessages[index].toId==authstate.getUserLoginDetails().userDetails.id) {
                  return Container(
                      padding: const EdgeInsets.all(16.0),
                      width: cWidth,
                      child: ReceivedMessage(
                          message: filtredMessages[index].message));
                }
                return Container(
                    padding: const EdgeInsets.all(16.0),
                    width: cWidth,
                    child: SentMessage(
                        message:
                           filtredMessages[index].message));
              },
            )),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextFormField(
                      autofocus: false,
                      decoration: new InputDecoration(
                          labelText: "Type a message",
                          suffix: GestureDetector(
                            child: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            ),
                            onTap: () {
                              chatStte.sendMessage(
                                  ChatMessage.fromJson({"id": ""}));
                            },
                          )),
                      keyboardType: TextInputType.text),
                ),
              ],
            ),
          ],
        ));
  }
}