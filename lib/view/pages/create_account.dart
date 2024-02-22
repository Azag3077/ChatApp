import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../controllers/create_account.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';

class CreateAccount extends ConsumerStatefulWidget
    with CreateAccountController {
  CreateAccount({super.key});

  @override
  ConsumerState<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends ConsumerState<CreateAccount> {
  final _pageController = PageController();
  final _usernameController = TextEditingController();

  Widget _pageViewContent1() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: List.generate(
              20,
              (index) {
                final avatar = 'assets/avatars/img_${index + 1}.png';
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: ref.watch(userAvatarIconProvider) == avatar
                        ? Theme.of(context).primaryColor.withOpacity(.3)
                        : null,
                  ),
                  child: IconButton(
                    onPressed: () => widget.onAvatarPressed(ref, avatar),
                    icon: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(
                        avatar,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlinedButton(
              onPressed: () => widget.onPickRandomAvatar(context, ref),
              child: const Text('Pick random'),
            ),
            OutlinedButton(
              onPressed: () => widget.onPickFromGallery(context, ref),
              child: const Text('Pick from gallery'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pageViewContent2() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          CustomTextField(
            controller: _usernameController,
            labelText: 'Username',
          ),
        ],
      ),
    );
  }

  Widget _pageView({
    required BuildContext context,
    required String text,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
        ),
        content,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.onWillPop(ref, _pageController),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) =>
                    widget.updatePageIndex(ref, index),
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _pageView(
                    context: context,
                    text: 'Select an avatar for your profile '
                        'image or pick image from gallery',
                    content: _pageViewContent1(),
                  ),
                  _pageView(
                    context: context,
                    text: 'Set-up your profile',
                    content: _pageViewContent2(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomElevatedButton(
                onPressed: () => widget.onContinue(context, ref,
                    _pageController, _usernameController.text.trim()),
                text: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
