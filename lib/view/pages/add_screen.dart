import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        title: Text('Select friend'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => {},
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/avatars/img_15.png'),
            ),
            title: Text('Chat ${index + 1}'),
            subtitle: Text('Message of chat ${index + 1}'),
            trailing: Container(
              child: Text('Add Friend'),
            ),
          );
        },
      ),
    );
  }
}
