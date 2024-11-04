// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:asociaciones/res/theme.dart';

class EglInputMultiLineField extends StatefulWidget {
  const EglInputMultiLineField({
    super.key,
    required this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    required this.onValidator,
    this.label = false,
    this.labelText = '',
    this.hintText = '',
    required this.currentValue,
    this.maxLength = TextField.noMaxLength,
    this.maxLines = 3,
    required this.focusNode,
    required this.nextFocusNode,
    this.icon,
    this.iconLabel,
    this.ronudIconBorder = false,
  }); //articleEditController.formKey;

  final ValueChanged<String> onChanged;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<String> onValidator;
  final bool label;
  final String labelText;
  final String hintText;
  final String? currentValue;
  final int maxLength;
  final int? maxLines;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final IconData? icon;
  final IconData? iconLabel;
  final bool ronudIconBorder;

  @override
  State<EglInputMultiLineField> createState() => _EglInputMultiLineFieldState();
}

class _EglInputMultiLineFieldState extends State<EglInputMultiLineField> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: null,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: TextInputType.multiline,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      onFieldSubmitted: (_) => widget.nextFocusNode?.requestFocus(),
      initialValue: widget.currentValue,
      validator: (value) => widget.onValidator(value),
      onChanged: (valuChanged) => _debouncer.run(() {
        widget.onChanged(valuChanged);
      }),
      style: const TextStyle(height: null),
      decoration: InputDecoration(
        //   labelText: (focusNode!.hasFocus || controller.text.isNotEmpty) ? label : hint,
        label: Row(mainAxisSize: MainAxisSize.min, children: [
          if (widget.iconLabel != null)
            Container(
              decoration: widget.ronudIconBorder
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    )
                  : null,
              child: Icon(
                widget.iconLabel,
                size: widget.ronudIconBorder ? 16.0 : 22.0,
                color: Colors.black,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: widget.iconLabel == null ? 0.0 : 8.0),
            child: Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ]),
        // labelText: widget.label ? null : widget.labelText,
        hintText: widget.hintText,
        helperText: '',
        prefixIcon: widget.icon == null
            ? null
            : IconButton(
                onPressed: () {},
                icon: Icon(
                  widget.icon,
                  color: Colors.blue,
                )), // adjust size s needed
        errorMaxLines: 2,
        errorStyle: const TextStyle(
          height: 1,
          fontSize: 11,
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
