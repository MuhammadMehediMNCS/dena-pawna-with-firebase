import 'package:flutter/material.dart';

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

  /// থিম অনুযায়ী রঙ বসানোর জন্য — না দিলে আগের ডিফল্ট আচরণই (কালো
  /// টাইটেল/টেক্সট, বাদামি কার্সর) বজায় থাকে, তাই পুরনো কোনো কল-সাইট
  /// ভাঙে না।
  final Color? labelColor;
  final Color? textColor;
  final Color? accentColor;

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
    this.labelColor,
    this.textColor,
    this.accentColor,
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
  Widget build(BuildContext context) {
    final Color accent = widget.accentColor ?? const Color(0xADCD852F);

    return Column(
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
          cursorColor: accent,
          keyboardType: widget.keyboard,
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          style: TextStyle(color: widget.textColor),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: widget.textColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: accent),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: accent,
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
}
