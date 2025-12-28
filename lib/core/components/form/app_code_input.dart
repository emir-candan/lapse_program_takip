import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_text_input.dart';
import '../../theme/app_theme.dart';

class AppCodeInput extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;

  const AppCodeInput({
    super.key,
    this.length = 4,
    this.onCompleted,
  });

  @override
  State<AppCodeInput> createState() => _AppCodeInputState();
}

class _AppCodeInputState extends State<AppCodeInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (widget.onCompleted != null) {
          final code = _controllers.map((c) => c.text).join();
          widget.onCompleted!(code);
        }
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: AppTheme.tokens.codeInputWidth,
          margin: EdgeInsets.symmetric(horizontal: AppTheme.tokens.codeInputSpacing),
          child: AppTextInput(
            controller: _controllers[index],
            hintText: "",
            onChanged: (v) => _onChanged(v, index),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
          ),
        );
      }),
    );
  }
}
