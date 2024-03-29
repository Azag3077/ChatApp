import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../controllers/add_screen.dart';
import '../widgets/chips.dart';

class AddScreen extends ConsumerWidget with AddScreenController {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(chatDetailsProvider(null)).value!;
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        title: const Text('Select friends to add'),
      ),
      body: users.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final user = data.elementAt(index);
              final isCurrentUser = currentUser.uid == user.uid;
              final isFriend = currentUser.friendLists.keys.contains(user.uid);
              if (isCurrentUser) {
                return const SizedBox.shrink();
              }
              return Column(
                children: <Widget>[
                  ListTile(
                    onTap: () =>
                        addUser(ref, currentUser.uid, user.uid, !isFriend),
                    leading: IconButton(
                      onPressed: () {},
                      icon: CircleAvatar(
                        backgroundImage: AssetImage(user.profileImage),
                      ),
                    ),
                    horizontalTitleGap: 5.0,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    title: Text(user.username),
                    subtitle: Text('Message of chat ${index + 1}'),
                    trailing: CategoryChip(
                      text: isFriend ? 'Remove Friend' : 'Add Friend',
                      onPressed: () =>
                          addUser(ref, currentUser.uid, user.uid, !isFriend),
                    ),
                  ),
                  Divider(height: 0.0, color: Colors.grey.shade200),
                ],
              );
            },
          );
        },
        error: (_, __) {
          return Text('Error $_');
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
