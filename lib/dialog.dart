import 'package:flutter/material.dart';

enum DialogType { dialog, bottomSheet }
showFullWidthDialogBox(
    BuildContext context,
    Widget child,
    isCancelable,
    DialogType type,
    ) {
  if (type == DialogType.dialog) {
    showDialog(
      barrierDismissible: isCancelable,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  } else {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      isDismissible: isCancelable,
      builder: (context) => child,
    );
  }
}