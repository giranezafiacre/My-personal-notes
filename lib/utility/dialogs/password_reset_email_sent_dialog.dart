import 'package:flutter/widgets.dart';
import 'package:mypersonalnotes/utility/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you a password reset link.',
    optionsBuilder: ()=>{
      'OK':null
    },
  );
}
