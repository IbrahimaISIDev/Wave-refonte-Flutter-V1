//lib/presentation/widgets/CodeInputWidget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInputWidget extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const CodeInputWidget({
    Key? key,
    this.length = 6,
    required this.onCompleted,
    this.backgroundColor = Colors.white10,
    this.textColor = Colors.white,
    this.borderColor = Colors.white,
  }) : super(key: key);

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _onCodeCompleted() {
    final code = _getCode();
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 55,
            height: 65,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(2, 3),
                ),
              ],
              border: Border.all(
                color: _focusNodes[index].hasFocus 
                    ? widget.borderColor 
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (index < widget.length - 1) {
                    _focusNodes[index + 1].requestFocus();
                  } else {
                    _focusNodes[index].unfocus();
                    _onCodeCompleted();
                  }
                } else if (value.isEmpty && index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              },
              onTap: () {
                if (_controllers[index].text.isEmpty) {
                  // Trouve le premier champ vide avant l'index actuel
                  for (int i = 0; i < index; i++) {
                    if (_controllers[i].text.isEmpty) {
                      _focusNodes[i].requestFocus();
                      return;
                    }
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}