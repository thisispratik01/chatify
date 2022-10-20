import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;
  const RoundedButton(
      {Key? key,
      required this.name,
      required this.height,
      required this.width,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color.fromRGBO(0, 82, 218, 1.0),
      ),
      height: height,
      width: width,
      child: TextButton(
          onPressed: () => onPressed(),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              height: 1.5,
            ),
          )),
    );
  }
}
