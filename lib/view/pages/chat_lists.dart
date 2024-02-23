import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/chat_lists.dart';
import '../../providers.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';

class ChatList extends ConsumerStatefulWidget with ChatListController {
  const ChatList({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  void initState() {
    widget.getUser(ref);
    super.initState();
  }

  Widget _searchBar(BuildContext context) {
    return CustomTextField(
      prefixIcon: Icon(
        CupertinoIcons.search,
        color: Colors.grey.shade600,
      ),
      hintText: 'Search chat, friends, group...',
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
      margin: const EdgeInsets.symmetric(
        // horizontal: 15.0,
        vertical: 8.0,
      ),
      borderRadius: BorderRadius.circular(30.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(chatDetailsProvider(null));

    if (currentUser.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (currentUser.hasError) {
      return Scaffold(
        body: Center(child: Text(currentUser.error.toString())),
      );
    }

    final user = currentUser.value!;
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        toolbarHeight: 110,
        title: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(user.profileImage),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Hi, ${user.username}\nWelcome to the ChatRoom',
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  onSelected: (String value) => {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.white,
                  surfaceTintColor: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.blueGrey.shade600,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        height: 28.0,
                        onTap: () => widget.onAddFriend(context),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              size: 16.0,
                              color: Colors.blueGrey.shade800,
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              'Add friends',
                              style: TextStyle(
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            _searchBar(context),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          if (user.friendLists.isEmpty)
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10.0),
                          Image.asset('assets/images/empty_chat_list.png'),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'You do not have any friends nor belong to any group. '
                              'Click the button below to add friend or join groups',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomElevatedButton(
                      onPressed: () => widget.onAddFriend(context),
                      text: 'Add friends',
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: user.friendLists.length,
                separatorBuilder: (_, __) => const Divider(height: 0.0),
                itemBuilder: (BuildContext context, int index) {
                  final id = user.friendLists.keys.elementAt(index);
                  final chatId =
                      user.friendLists.values.elementAt(index)['chatId'];
                  final chatDetails = ref.watch(chatDetailsProvider(id));
                  return chatDetails.when(
                    data: (chat) {
                      return ListTile(
                        onTap: () =>
                            widget.onChatPressed(context, ref, id, chatId),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(chat.profileImage),
                        ),
                        title: Text(chat.username),
                        subtitle: Text('Message of chat ${index + 1}'),
                        trailing: Column(
                          children: <Widget>[
                            const Text(
                              'Online',
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
                    error: (_, __) {
                      return Text('Error $_');
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),
          // if (user != null) ...[
          //   if (user.friendLists.isEmpty)
          //     Expanded(
          //       child: Column(
          //         children: <Widget>[
          //           Expanded(
          //             child: SingleChildScrollView(
          //               child: Column(
          //                 children: <Widget>[
          //                   const SizedBox(height: 10.0),
          //                   Image.asset('assets/images/empty_chat_list.png'),
          //                   Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 20.0),
          //                     child: Text(
          //                       'You do not have any friends nor belong to any group. '
          //                       'Click the button below to add friend or join groups',
          //                       textAlign: TextAlign.center,
          //                       style: TextStyle(
          //                         color: Colors.grey.shade700,
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(height: 100.0),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.all(15.0),
          //             child: CustomElevatedButton(
          //               onPressed: () => widget.onAddFriend(context),
          //               text: 'Add friends',
          //             ),
          //           ),
          //         ],
          //       ),
          //     )
          //   else
          //     Expanded(
          //       child: Container(
          //         // color: Colors.red,
          //         child: ListView(
          //           children: [
          //             ListTile(
          //               onTap: () {},
          //               tileColor: Colors.green,
          //               title: Text('Azag'),
          //             ),
          //           ],
          //         ),
          //       ),
          //       // child: ListView.separated(
          //       //   itemCount: user.friendLists.length,
          //       //   separatorBuilder: (_, __) => const Divider(height: 0.0),
          //       //   itemBuilder: (BuildContext context, int index) {
          //       //     // final chat = chatsData.elementAt(index);
          //       //     return ListTile(
          //       //       onTap: () => widget.onChatPressed(context, ref),
          //       //       leading: CircleAvatar(
          //       //         backgroundImage: AssetImage(user.profileImage),
          //       //       ),
          //       //       title: Text('Chat ${index + 1}'),
          //       //       subtitle: Text('Message of chat ${index + 1}'),
          //       //       trailing: Column(
          //       //         children: <Widget>[
          //       //           const Text(
          //       //             '3:22 PM',
          //       //             style: TextStyle(color: Colors.blueGrey),
          //       //           ),
          //       //           Container(
          //       //             margin: const EdgeInsets.all(15.0),
          //       //             child: const SizedBox.square(
          //       //               dimension: 6.0,
          //       //               child: DecoratedBox(
          //       //                 decoration: ShapeDecoration(
          //       //                   shape: CircleBorder(),
          //       //                   color: Colors.green,
          //       //                 ),
          //       //               ),
          //       //             ),
          //       //           ),
          //       //         ],
          //       //       ),
          //       //     );
          //       //   },
          //       // ),
          //     ),
          // ],
          // chatList.when(
          //   data: (chatsData) {
          //     return Column(
          //       children: <Widget>[
          //         Expanded(
          //           child: ListView.separated(
          //             itemCount: chatsData.length,
          //             separatorBuilder: (_, __) => const Divider(height: 0.0),
          //             itemBuilder: (BuildContext context, int index) {
          //               final chat = chatsData.elementAt(index);
          //               return ListTile(
          //                 onTap: () => widget.onChatPressed(context, ref),
          //                 leading: CircleAvatar(
          //                   backgroundImage: AssetImage(chat.profileImage),
          //                 ),
          //                 title: Text('Chat ${index + 1}'),
          //                 subtitle: Text('Message of chat ${index + 1}'),
          //                 trailing: Column(
          //                   children: <Widget>[
          //                     const Text(
          //                       '3:22 PM',
          //                       style: TextStyle(color: Colors.blueGrey),
          //                     ),
          //                     Container(
          //                       margin: const EdgeInsets.all(15.0),
          //                       child: const SizedBox.square(
          //                         dimension: 6.0,
          //                         child: DecoratedBox(
          //                           decoration: ShapeDecoration(
          //                             shape: CircleBorder(),
          //                             color: Colors.green,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          //   error: (_, __) {
          //     return Center(child: Text('Error $_'));
          //   },
          //   loading: () {
          //     return const Center(child: CircularProgressIndicator());
          //   },
          // ),
        ],
      ),
    );
  }
}
