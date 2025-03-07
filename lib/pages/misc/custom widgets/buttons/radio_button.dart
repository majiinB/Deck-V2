import 'package:flutter/material.dart';

class BuildRadioButton extends StatefulWidget {
  final int numberOfButtons;
  final List<String> buttonLabels;
  final List<String>? buttonSubtexts;
  final TextStyle textStyle;
  final TextStyle? subtextStyle;
  final Color activeColor;
  final Color inactiveColor;
  final Function(int) onButtonSelected;

  BuildRadioButton({
    required this.numberOfButtons,
    required this.buttonLabels,
    this.buttonSubtexts,
    required this.textStyle,
    this.subtextStyle,
    required this.activeColor,
    required this.inactiveColor,
    required this.onButtonSelected
  });

  @override
  _BuildRadioButtonState createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.numberOfButtons, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedValue = index;
            });
            widget.onButtonSelected(index);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio<int>(
                  value: index,
                  groupValue: selectedValue,
                  onChanged: (int? value) {
                    setState(() {
                      selectedValue = value;
                    });
                    //calls the function when a button is selected
                    widget.onButtonSelected(index);
                  },
                  activeColor: widget.activeColor,
                  fillColor: MaterialStateProperty.all(widget.inactiveColor),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///main label text
                      Text(
                        widget.buttonLabels[index],
                        style: widget.textStyle,
                        softWrap: true,
                      ),
                      ///subtext (only if present)
                      if (widget.buttonSubtexts != null && widget.buttonSubtexts![index].isNotEmpty)
                        Text(
                          widget.buttonSubtexts![index],
                          style: widget.subtextStyle,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
