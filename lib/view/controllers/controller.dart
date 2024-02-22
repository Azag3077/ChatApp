// import 'package:chatapp/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../providers.dart';
// import '../pages/conversation.dart';
// import '../pages/create_account.dart';
// import '../pages/get_started.dart';
//
// mixin Controller on Widget {
//   Future<void> initialize(BuildContext context) async {
//     SharedPreferences.getInstance().then((prefs) {
//       final uid = prefs.get('uid');
//
//       if (uid == null) {
//         _gotoPage(context, const GetStarted());
//       } else {
//         _gotoPage(context, const ConversationPage());
//       }
//     });
//
// // // Save an integer value to 'counter' key.
// //     await prefs.setInt('counter', 10);
// // // Save an boolean value to 'repeat' key.
// //     await prefs.setBool('repeat', true);
// // // Save an double value to 'decimal' key.
// //     await prefs.setDouble('decimal', 1.5);
// // // Save an String value to 'action' key.
// //     await prefs.setString('action', 'Start');
// // // Save an list of strings to 'items' key.
// //     await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);
//
//     // FirebaseService.checkUserExistence();
//     // Future.delayed(const Duration(seconds: 2)).then(
//     //   (value) => Navigator.pushReplacement(
//     //       context, MaterialPageRoute(builder: (context) => const ChatList())),
//     // );
//   }
//
//   Future<bool> onWillPop() async {
//     return false;
//   }
//
//   void updatePageIndex(WidgetRef ref, int index) =>
//       ref.read(pageIndexProvider.notifier).update((state) => index);
//
//   void onAvatarPressed(WidgetRef ref, String avatar) =>
//       ref.read(userAvatarIconProvider.notifier).update((state) => avatar);
//
//   void onContinue(
//     BuildContext context,
//     WidgetRef ref,
//     PageController pageController,
//   ) {
//     final index = ref.read(pageIndexProvider);
//
//     if (index == 0) {
//       final profileImage = ref.read(userAvatarIconProvider);
//
//       if (profileImage == null) {
//       } else {
//         pageController.animateToPage(1,
//             duration: const Duration(milliseconds: 200), curve: Curves.linear);
//       }
//     }
//     print(index);
//     // _gotoPage(context, const CreateAccount());
//   }
//
//   void onPickRandomAvatar(BuildContext context, WidgetRef ref) {}
//   void onPickFromGallery(BuildContext context, WidgetRef ref) {}
//
//   void onChatPressed(BuildContext context, WidgetRef ref) {
//     FirebaseService.checkUserExistence();
//   }
//
//   void _gotoPage(BuildContext context, Widget page) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => page));
//   }
// }
