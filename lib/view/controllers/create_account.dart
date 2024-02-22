import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chatapp/view/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers.dart';
import '../../services.dart';
import '../../utils.dart';
import '../pages/chat_lists.dart';

mixin CreateAccountController on Widget {
  final pageAnimationDuration = const Duration(milliseconds: 300);

  Future<bool> onWillPop(WidgetRef ref, PageController pageController) async {
    if (ref.read(pageIndexProvider) == 0) {
      return true;
    }
    pageController.previousPage(
        duration: pageAnimationDuration, curve: Curves.linear);
    return false;
  }

  void updatePageIndex(WidgetRef ref, int index) =>
      ref.read(pageIndexProvider.notifier).update((state) => index);

  void onAvatarPressed(WidgetRef ref, String avatar) =>
      ref.read(userAvatarIconProvider.notifier).update((state) => avatar);

  void onContinue(
    BuildContext context,
    WidgetRef ref,
    PageController pageController,
    String username,
  ) {
    if (ref.read(pageIndexProvider) == 0) {
      if (ref.read(userAvatarIconProvider) == null) {
        snackbar(
          context: context,
          title: 'Oops!!!',
          message: 'Please select a profile image',
          contentType: ContentType.warning,
        );
      } else {
        pageController.animateToPage(1,
            duration: pageAnimationDuration, curve: Curves.linear);
      }
    } else if (username.isEmpty) {
      snackbar(
        context: context,
        title: 'Oops!!!',
        message: 'Please provide a username so that friends to identify you',
        contentType: ContentType.warning,
      );
    } else {
      _createAccount(context, username, ref.read(userAvatarIconProvider)!);
    }
  }

  Future<void> _createAccount(
    BuildContext context,
    String username,
    String profileImage,
  ) async {
    final uid = await getDeviceUid();

    FirebaseService.createUser(username, profileImage).then((value) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('uid', uid).then((value) {
          _gotoPage(context, const ChatList());
        });
      });
    });
  }

  void onPickRandomAvatar(BuildContext context, WidgetRef ref) {}
  void onPickFromGallery(BuildContext context, WidgetRef ref) {}

  void _gotoPage(BuildContext context, Widget page) =>
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => page));
}
