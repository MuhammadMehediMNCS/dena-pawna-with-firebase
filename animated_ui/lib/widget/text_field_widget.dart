import 'package:flutter/material.dart';

/// থিম-সচেতন টেক্সট ফিল্ড — [labelColor]/[textColor]/[accentColor] না
/// দিলে আগের (লাইট থিমের) ডিফল্ট রংগুলোই ব্যবহার হয়, তাই পুরনো
/// কল-সাইটগুলো ভাঙবে না। ডার্ক থিমে স্পষ্ট দেখানোর জন্যই এই প্যারামিটার
/// তিনটি যোগ করা হয়েছে।
class TextFieldWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? labelText;
  final bool readOnly;
  final bool? enabled;
  final int? maxLine;
  final VoidCallback? onPressed;
  final Function(String)? onChanged;
  final bool isPassword;
  final Color labelColor;
  final Color textColor;
  final Color accentColor;
  final Color fillColor;

  const TextFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    this.keyboard,
    this.labelText,
    this.readOnly = false,
    this.enabled,
    this.maxLine,
    this.onPressed,
    this.onChanged,
    this.isPassword = false,
    this.labelColor = Colors.black,
    this.textColor = Colors.black,
    this.accentColor = const Color(0xADCD852F),
    this.fillColor = Colors.transparent,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'TiroBangla-Regular',
                fontWeight: FontWeight.bold,
                color: widget.labelColor,
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            cursorColor: widget.accentColor,
            keyboardType: widget.keyboard,
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            style: TextStyle(color: widget.textColor),
            enabled: widget.enabled,
            decoration: InputDecoration(
              labelText: widget.labelText,
              filled: widget.fillColor != Colors.transparent,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: widget.accentColor.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: widget.accentColor),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: widget.accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
            readOnly: widget.readOnly,
            maxLines: widget.isPassword ? 1 : widget.maxLine,
            onTap: widget.onPressed,
            onChanged: widget.onChanged,
          ),
        ],
      );
}
