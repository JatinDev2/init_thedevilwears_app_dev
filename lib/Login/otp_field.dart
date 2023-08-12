import 'package:flutter/material.dart';

class CircularOtpInput extends StatefulWidget {
  final int length;
  final Function(String) onOtpEntered;

  CircularOtpInput({required this.length, required this.onOtpEntered});

  @override
  _CircularOtpInputState createState() => _CircularOtpInputState();
}

class _CircularOtpInputState extends State<CircularOtpInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(widget.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    _controllers[index].text = value;
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index].unfocus();
      _focusNodes[index + 1].requestFocus();
    }
    String otp = '';
    for (var controller in _controllers) {
      otp += controller.text;
    }
    widget.onOtpEntered(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
            (index) => Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) => _onTextChanged(index, value),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
