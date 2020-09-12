import 'package:flutter/material.dart';

class TanggalSet extends StatelessWidget{
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  const TanggalSet({
    Key key,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
    this.child
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 30, top: 8, right: 30),
        child: InputDecorator(
          decoration: InputDecoration(labelText: labelText),
          baseStyle: valueStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                valueText,
                style: valueStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70,
              )
            ],
          ),
        ),
      ),
    );
  }

}