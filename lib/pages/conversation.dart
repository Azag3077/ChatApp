import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models.dart';
import '../providers.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({super.key});

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
    final messages = ref.watch(messagesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'LIVE CHAT WITH ADMIN',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(15.0),
              reverse: true,
              itemCount: messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10.0),
              itemBuilder: (BuildContext context, int index) {
                final message = messages.elementAt(index);
                return MessageBox(message: message);
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
                          onPressed: () => onSend(ref, controller),
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
  }
}

Future<void> onSend(WidgetRef ref, TextEditingController controller) async {
  final msg = controller.text.trim();

  if (msg.isEmpty) return;

  final message = Message(
    message: msg,
    sentTime: DateTime.now(),
    isSender: true,
  );

  ref.read(messagesProvider.notifier).update((state) => [message, ...state]);
  controller.clear();

  final response = await getResponse(msg);

  final responseMsg = Message(
    message: response,
    sentTime: DateTime.now(),
    isSender: false,
  );

  ref
      .read(messagesProvider.notifier)
      .update((state) => [responseMsg, ...state]);
}

Future<String> getResponse(String message) async {
  await Future.delayed(const Duration(milliseconds: 1000));
  return '<A MESSAGE FROM THE OTHER FRIEND>';
}

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.message,
  });
  final Message message;

  String get _time {
    final hour = message.sentTime.hour.toString().padLeft(2, '0');
    final minutes = message.sentTime.minute.toString().padLeft(2, '0');
    return '${message.isSender ? 'Sent' : 'Delivered'} $hour:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!message.isSender) ...[
          Image.asset('assets/avatars/img_2.png', width: 32.0),
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
            child: Image.asset('assets/avatars/img_3.png', width: 32),
          ),
        ],
      ],
    );
  }
}
