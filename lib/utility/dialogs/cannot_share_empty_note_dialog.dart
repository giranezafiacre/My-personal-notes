import 'package:flutter/widgets.dart';
import 'package:mypersonalnotes/utility/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note!',
    optionsBuilder: ()=>{
      'OK':null
    },
  );
}
