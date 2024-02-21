import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/text_field.dart';
import 'conversation.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 8.0,
      ),
      child: CustomTextField(
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Colors.grey.shade600,
        ),
        hintText: 'Courses',
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                'Search',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 13.0,
                ),
              ),
            ),
          ],
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter ChatRoom'),
      ),
      body: Column(
        children: <Widget>[
          _searchBar(context),
          Expanded(
            child: ListView.separated(
              itemCount: 20,
              separatorBuilder: (_, __) => const Divider(height: 0.0),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConversationPage()));
                  },
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatars/img_1.png'),
                  ),
                  title: Text('Chat ${index + 1}'),
                  subtitle: Text('Message of chat ${index + 1}'),
                  trailing: Column(
                    children: <Widget>[
                      const Text(
                        '3:22 PM',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        child: const SizedBox.square(
                          dimension: 6.0,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
