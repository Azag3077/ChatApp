import 'package:chatapp/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../models/user.dart';
import '../../providers.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage(this.id, this.chatId, {super.key});
  final String id;
  final String chatId;

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatDetails = ref.watch(chatDetailsProvider(widget.id));
    final messages = ref.watch(messagesProvider(widget.chatId));
    final currentUser = ref.watch(userProvider)!;

    return chatDetails.when(
      data: (chat) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 24,
            elevation: 7,
            title: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(chat.profileImage),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chat.username,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  ref.invalidate(messagesProvider(widget.chatId));
                },
                icon: const Icon(CupertinoIcons.video_camera_solid),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              if (messages.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (messages.hasError)
                Expanded(
                  child: Center(
                    child: Text(messages.error.toString()),
                  ),
                )
              else if (messages.hasValue)
                Expanded(
                  child: ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.all(15.0),
                    itemCount: messages.value!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages.value!.elementAt(index);
                      return MessageBox(
                        message: message,
                        receiver: currentUser,
                        sender: chat,
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    // Image(image: AssetImages.theme.image, width: 32),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: controller,
                                cursorColor: Theme.of(context).primaryColor,
                                maxLines: 5,
                                minLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'Write a message',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10.0),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  onSend(ref, controller, widget.chatId),
                              // icon: AssetImages.send,
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
  }
}

Future<void> onSend(
    WidgetRef ref, TextEditingController controller, String chatId) async {
  final msg = controller.text.trim();

  if (msg.isEmpty) return;

  final message = Message(
    message: msg,
    timestamp: DateTime.now(),
    isSender: true,
  );
  await FirebaseService.addMessage(chatId, message);

  // ref.read(messagesProvider.notifier).update((state) => [message, ...state]);
  controller.clear();

  // final response = await getResponse(msg);
  //
  // final responseMsg = Message(
  //   message: response,
  //   timestamp: DateTime.now(),
  //   isSender: false,
  // );
  //
  // ref
  //     .read(messagesProvider.notifier)
  //     .update((state) => [responseMsg, ...state]);
}

Future<String> getResponse(String message) async {
  await Future.delayed(const Duration(milliseconds: 1000));
  return '<A MESSAGE FROM THE OTHER FRIEND>';
}

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.message,
    required this.receiver,
    required this.sender,
  });
  final Message message;
  final User receiver;
  final User sender;

  String get _time {
    final hour = message.timestamp.hour.toString().padLeft(2, '0');
    final minutes = message.timestamp.minute.toString().padLeft(2, '0');
    return '${message.isSender ? 'Sent' : 'Delivered'} $hour:$minutes';
  }

  Widget _profileImage(String image) {
    return CircleAvatar(
      backgroundImage: AssetImage(image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!message.isSender) ...[
          _profileImage(sender.profileImage),
          const SizedBox(width: 8.0),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(8.0),
                child: Text(message.message),
              ),
              const SizedBox(height: 4.0),
              Text(
                _time,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        if (message.isSender) ...[
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _profileImage(receiver.profileImage),
          ),
        ],
      ],
    );
  }
}
