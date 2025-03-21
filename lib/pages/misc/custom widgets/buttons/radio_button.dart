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
  final int? selectedIndex; // Added for initial selection

  BuildRadioButton({
    required this.numberOfButtons,
    required this.buttonLabels,
    this.buttonSubtexts,
    required this.textStyle,
    this.subtextStyle,
    required this.activeColor,
    required this.inactiveColor,
    required this.onButtonSelected,
    this.selectedIndex, // Initialize this
  });

  @override
  _BuildRadioButtonState createState() => _BuildRadioButtonState();
}

class _BuildRadioButtonState extends State<BuildRadioButton> {
  int? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedIndex; // Set initial value
  }

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
                    widget.onButtonSelected(index);
                  },
                  activeColor: widget.activeColor,
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) =>
                    states.contains(MaterialState.selected)
                        ? widget.activeColor
                        : widget.inactiveColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.buttonLabels[index],
                        style: widget.textStyle,
                        softWrap: true,
                      ),
                      if (widget.buttonSubtexts != null &&
                          widget.buttonSubtexts![index].isNotEmpty)
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
