import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  TextEditingController textEditingController;
  String hinttxt, title;
  TextInputType keyboardType;
  Input(
      {Key? key,
      required this.hinttxt,
      required this.title,
      required this.textEditingController,
      required this.keyboardType})
      : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
              fontSize: 13, color: Color.fromARGB(255, 97, 97, 97)),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          color: const Color.fromARGB(255, 216, 216, 216),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: TextFormField(
              validator: (v) {
                if (v!.isEmpty) {
                  return "This feild is required.";
                }
              },
              controller: widget.textEditingController,
              obscureText: widget.keyboardType == TextInputType.visiblePassword
                  ? true
                  : false,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration.collapsed(
                hintText: widget.hinttxt,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
