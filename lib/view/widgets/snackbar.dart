// import 'package:flutter/material.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//
// class AwesomeSnackBarExample extends StatelessWidget {
//   const AwesomeSnackBarExample({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               child: const Text('Show Awesome SnackBar'),
//               onPressed: () {
//                 final snackBar = SnackBar(
//                   /// need to set following properties for best effect of awesome_snackbar_content
//                   elevation: 0,
//                   behavior: SnackBarBehavior.floating,
//                   backgroundColor: Colors.transparent,
//                   content: AwesomeSnackbarContent(
//                     title: 'On Snap!',
//                     message:
//                         'This is an example error message that will be shown in the body of snackbar!',
//
//                     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//                     contentType: ContentType.failure,
//                   ),
//                 );
//
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(snackBar);
//               },
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               child: const Text('Show Awesome Material Banner'),
//               onPressed: () {
//                 final materialBanner = MaterialBanner(
//                   /// need to set following properties for best effect of awesome_snackbar_content
//                   elevation: 0,
//                   backgroundColor: Colors.transparent,
//                   forceActionsBelow: true,
//                   content: AwesomeSnackbarContent(
//                     title: 'Oh Hey!!',
//                     message:
//                         'This is an example error message that will be shown in the body of materialBanner!',
//
//                     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//                     contentType: ContentType.success,
//                     // to configure for material banner
//                     inMaterialBanner: true,
//                   ),
//                   actions: const [SizedBox.shrink()],
//                 );
//
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentMaterialBanner()
//                   ..showMaterialBanner(materialBanner);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void snackbar({
  required BuildContext context,
  required String title,
  required String message,
  ContentType? contentType,
}) {
  final snackBar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType ?? ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
