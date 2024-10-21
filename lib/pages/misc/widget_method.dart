import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

///updated methods as of 05/11/24 1:34AM
///
///
/// ----------------------- S T A R T -------------------------
/// ---------------------- A P P B A R ------------------------

///
///
/// DeckBar is an AppBar with the font Nunito (used in typical routes)
class DeckBar extends StatelessWidget implements PreferredSizeWidget {
  const DeckBar({
    super.key,
    required this.title,
    required this.color,
    required this.fontSize,
    this.onPressed,
    this.icon,
    this.iconColor,
  }); // Correct usage of super keyword

  final String title;
  final Color color;

  final double fontSize;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final IconData? icon; // Make IconData nullable

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (icon != null) {
      // Check if icon is not null
      actions.add(
        InkWell(
          onTap: onPressed,
          borderRadius:
              BorderRadius.circular(50), // Adjust the border radius as needed
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      );
      actions.add(const SizedBox(width: 10));
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
      centerTitle: true,
      foregroundColor: const Color.fromARGB(255, 61, 61, 61),
      actions: actions, // Use the constructed list of actions
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

///
///
/// AuthBar is an AppBar with the font Fraiche (used in auth and main routes)
class AuthBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthBar({
    super.key,
    required this.title,
    required this.color,
    required this.fontSize,
    this.automaticallyImplyLeading = false,
  });
  final String title;
  final Color color;
  final double fontSize;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Fraiche',
            fontSize: fontSize,
            color: color,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

/// ------------------------- E N D ---------------------------
/// ---------------------- A P P B A R ------------------------

///############################################################

///
///
/// ------------------------ S T A R T -------------------------
/// -------------- R O U T E  A N I M A T I O N ----------------

///
///
/// RouteGenerator is a widget that handles the animation of pages
class RouteGenerator {
  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Animation starts from right to left
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

/// -------------------------- E N D ---------------------------
/// -------------- R O U T E  A N I M A T I O N ----------------

///############################################################


///
///
/// ------------------------ S T A R T -------------------------
/// ------------------ D E C K  B U T T O N --------------------

///
///
/// DeckButton is the main button of Deck used for all routes
class BuildButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double height, width, radius, fontSize, borderWidth;
  final Color backgroundColor, textColor, borderColor;
  final IconData? icon;
  final String? svg;
  final Color? iconColor;
  final double? paddingIconText, size, svgHeight;


  const BuildButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.radius,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.borderWidth,
    required this.borderColor,
    this.svgHeight,
    this.size,
    this.icon,
    this.svg,
    this.iconColor,
    this.paddingIconText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: borderColor,
              width: borderWidth, // Add borderWidth
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: paddingIconText ?? 24.0),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: size,
                ),
              ),
            if (svg != null)
              Padding(
                padding: EdgeInsets.only(right: paddingIconText ?? 24.0),
                child: SvgPicture.asset(
                  svg!,
                  height: svgHeight,
                ),
              ),
            Text(
              buttonText,
              style: GoogleFonts.nunito(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// this will make the buttons act like a radio button. ir manages the state of the selected button.

class RadioButtonGroup extends StatefulWidget {
  final List<String> buttonLabels; // List of button labels
  final List<Color> buttonColors ; // List of button colors
  final bool isClickable; // whether the buttons can be clicked by user or not
  final int initialSelectedIndex;

  const RadioButtonGroup({
    Key? key,
    this.initialSelectedIndex = 0,
    required this.buttonLabels,
    required this.buttonColors,
    this.isClickable = true,
  })  : assert(buttonLabels.length == buttonColors.length,
  'Each button must have a corresponding color'),
        super(key: key);
  //use assert statement to prevent crashes and bugs
  @override
  _RadioButtonGroupState createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  int? _selectedIndex; // Keep track of the selected button index

  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }
  void _onButtonPressed(int index) {
    if (widget.isClickable) {
      setState(() {
        _selectedIndex = index; // Update the selected index
      });
    }
  }
  Color _getBackgroundColor(int index) {
    if (_selectedIndex == index) {
      return widget.buttonColors[index]; // Assign color
    }
    return Colors.transparent; // Default
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.buttonLabels.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0), // Space between buttons
          child: BuildButton(
            onPressed: () => _onButtonPressed(index),
            buttonText: widget.buttonLabels[index],
            height: 50,
            width: 130,
            radius: 10,
            backgroundColor: _getBackgroundColor(index),
            textColor: DeckColors.white,
            fontSize: 16,
            borderWidth: 2,
            borderColor: DeckColors.white,
          ),
        );
      }),
    );
  }
}

/// -------------------------- E N D ---------------------------
/// ------------------ D E C K  B U T T O N --------------------

///############################################################

///
///
/// ------------------------ S T A R T -------------------------
/// ---------------------- A C C O U N T -----------------------

///
///
/// BuildCoverImage is a method for Cover Photo
class BuildCoverImage extends StatefulWidget {
  final Image? coverPhotoFile;
  final double borderRadiusContainer, borderRadiusImage;

  const BuildCoverImage(
      {super.key,
      this.coverPhotoFile,
      required this.borderRadiusContainer,
      required this.borderRadiusImage});

  @override
  BuildCoverImageState createState() => BuildCoverImageState();
}

class BuildCoverImageState extends State<BuildCoverImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadiusContainer),
        color: widget.coverPhotoFile != null
            ? null
            : DeckColors.coverImageColorSettings,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadiusImage),
        child: widget.coverPhotoFile != null
            ? Image(
                image: widget.coverPhotoFile!.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              )
            : const Placeholder(
                color: DeckColors.coverImageColorSettings,
              ),
      ),
    );
  }
}

class BuildCoverImageUrl extends StatelessWidget {
  final String? imageUrl;
  final double borderRadiusContainer, borderRadiusImage;
  final Color backgroundColor;

  const BuildCoverImageUrl({
    super.key,
    this.imageUrl,
    required this.borderRadiusContainer,
    required this.borderRadiusImage,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusContainer),
        color: imageUrl != null ? null : backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusImage),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              )
            : Container(
                color: backgroundColor,
                width: double.infinity,
                height: double.infinity,
              ),
      ),
    );
  }
}

///
///
/// BuildProfileImage is a method for Profile Photo
class BuildProfileImage extends StatefulWidget {
  final Image? profilePhotoFile;

  const BuildProfileImage(this.profilePhotoFile, {super.key});

  @override
  BuildProfileImageState createState() => BuildProfileImageState();
}

class BuildProfileImageState extends State<BuildProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: DeckColors.backgroundColor, width: 3.0),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: DeckColors.white,
        backgroundImage: widget.profilePhotoFile?.image,
        radius: 70,
        child: widget.profilePhotoFile?.image == null
            ? const Icon(DeckIcons.account,
                size: 70, color: DeckColors.backgroundColor)
            : null,
      ),
    );
  }
}

///
///
///SwipeToDeleteAndRetrieve is to delete and retrieve Decks
class SwipeToDeleteAndRetrieve extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve;
  final bool enableRetrieve;

  const SwipeToDeleteAndRetrieve({
    super.key,
    required this.child,
    required this.onDelete,
    this.onRetrieve,
    this.enableRetrieve = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: enableRetrieve
          ? DismissDirection.horizontal
          : DismissDirection.endToStart,
      background: enableRetrieve
          ? Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: DeckColors.primaryColor,
              ),
              child: const Icon(Icons.undo, color: DeckColors.white),
            )
          : Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.red,
              ),
              child: const Icon(DeckIcons.trash_bin, color: DeckColors.white),
            ),
      secondaryBackground: enableRetrieve
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.red, // Red background for delete
              ),
              child: const Icon(DeckIcons.trash_bin, color: DeckColors.white),
            )
          : null,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else if (direction == DismissDirection.startToEnd && enableRetrieve) {
          onRetrieve?.call();
        }
      },
      child: child,
    );
  }
}

///
///
///BuidListOfDecks is a method for Container of Decks but only for design
class BuildListOfDecks extends StatefulWidget {
  final String? deckImageUrl;
  final String titleText, numberText;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve;
  final bool enableSwipeToRetrieve;

  const BuildListOfDecks({
    super.key,
    this.deckImageUrl,
    required this.titleText,
    required this.numberText,
    required this.onDelete,
    this.onRetrieve,
    this.enableSwipeToRetrieve = true,
  });

  @override
  State<BuildListOfDecks> createState() => BuildListOfDecksState();
}

class BuildListOfDecksState extends State<BuildListOfDecks> {
  @override
  Widget build(BuildContext context) {
    return SwipeToDeleteAndRetrieve(
      onDelete: widget.onDelete,
      onRetrieve: widget.enableSwipeToRetrieve ? widget.onRetrieve : null,
      enableRetrieve: widget.enableSwipeToRetrieve,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: DeckColors.gray,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: widget.deckImageUrl != null ? null : DeckColors.white,
              height: 75,
              width: 75,
              child: widget.deckImageUrl != null
                  ? Image.network(
                      widget.deckImageUrl!,
                      width: 20,
                      height: 10,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: DeckColors.white,
                          child: const Center(
                              child:
                                  Icon(Icons.broken_image, color: Colors.grey)),
                        );
                      },
                    )
                  : const Placeholder(
                      color: DeckColors.white,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titleText,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: DeckColors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: DeckColors.coverImageColorSettings,
                        ),
                        child: Text(
                          widget.numberText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: DeckColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///ShowConfirmationDialog is a method for Confirm Dialog
class ShowConfirmationDialog extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ShowConfirmationDialog({
    super.key,
    required this.title,
    required this.text,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel();
            Navigator.of(context).pop();
          },
          child: const Text("No", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text("Yes", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}

//Used to show the Dialog Box
void showConfirmationDialog(BuildContext context, String title, String text,
    VoidCallback onConfirm, VoidCallback onCancel) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ShowConfirmationDialog(
        title: title,
        text: text,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
  );
}

///

// Method to show an informational dialog
void showInformationDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}

/// -------------------------- E N D ---------------------------
/// ---------------------- A C C O U N T -----------------------

///############################################################

///
///
/// ----------------------- S T A R T --------------------------
/// -------------------- S E T T I N G S -----------------------

// Container for a function in settings
class BuildSettingsContainer extends StatefulWidget {
  final IconData selectedIcon;
  final IconData? alternateIcon;
  final String nameOfTheContainer;
  final String? alternateText;
  final VoidCallback? onTap;
  final bool showSwitch, showArrow;
  final Color containerColor;
  final Color selectedColor;
  final Color textColor;
  final Color toggledColor;
  final ValueChanged<bool>? onToggleChanged;

  const BuildSettingsContainer({
    required this.selectedIcon,
    required this.nameOfTheContainer,
    this.alternateIcon,
    this.alternateText,
    this.showSwitch = false,
    this.showArrow = false,
    this.onTap,
    this.onToggleChanged,
    required this.containerColor,
    required this.selectedColor,
    required this.textColor,
    required this.toggledColor,
    super.key,
  });

  @override
  State<BuildSettingsContainer> createState() => BuildSettingsContainerState();
}

class BuildSettingsContainerState extends State<BuildSettingsContainer> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _isToggled = themeProvider.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: _isToggled ? widget.toggledColor : widget.containerColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isToggled
                        ? (widget.alternateIcon ?? widget.selectedIcon)
                        : widget.selectedIcon,
                    color: _isToggled
                        ? DeckColors.primaryColor
                        : widget.selectedColor,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      _isToggled
                          ? (widget.alternateText ?? widget.nameOfTheContainer)
                          : widget.nameOfTheContainer,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color:
                            _isToggled ? (widget.textColor) : widget.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.showSwitch)
                Switch(
                  value: _isToggled,
                  onChanged: (bool value) {
                    setState(() {
                      _isToggled = value;
                    });
                    if (widget.onToggleChanged != null) {
                      widget.onToggleChanged!(value);
                    }
                  },
                  activeColor: DeckColors.primaryColor,
                  inactiveThumbColor: Colors.white,
                ),
              if (widget.showArrow)
                const Icon(
                  Icons.arrow_right,
                  color: Colors.grey,
                  size: 32,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

///
///
///

///
///
///
///
///
///

/// ------------------------- E N D ----------------------------
/// -------------------- S E T T I N G S -----------------------

///############################################################

///
///
/// ----------------------- S T A R T --------------------------
/// ------------ C H A N G E  P A S S W O R D ------------------
class BuildTextBox extends StatefulWidget {
  final String? hintText, initialValue;
  final bool showPassword;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isMultiLine;
  final bool isReadOnly;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const BuildTextBox({
    super.key,
    this.hintText,
    this.showPassword = false,
    this.leftIcon,
    this.rightIcon,
    this.initialValue,
    this.controller,
    this.onTap,
    this.isMultiLine = false,
    this.isReadOnly = false,
  });

  @override
  State<BuildTextBox> createState() => BuildTextBoxState();
}

class BuildTextBoxState extends State<BuildTextBox> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      readOnly: widget.isReadOnly,
      onTap: widget.onTap,
      controller: widget.controller,
      initialValue: widget.initialValue,
      style: GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 16,
      ),
      maxLines: widget.isMultiLine ? null : 1,
      minLines: widget.isMultiLine ? 4 : 1,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: DeckColors.primaryColor, // Change to your desired color
            width: 2.0,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: Colors.white,
        ),
        filled: true,
        fillColor: DeckColors.backgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        prefixIcon: widget.leftIcon != null
            ? Icon(widget.leftIcon)
            : null, // Change to your desired left icon
        suffixIcon: widget.showPassword
            ? IconButton(
                icon: _obscureText
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.rightIcon != null
                ? IconButton(
                    icon: Icon(widget.rightIcon),
                    onPressed: widget.onTap,
                  )
                : null,
      ),
      obscureText: widget.showPassword ? _obscureText : false,
    );
  }
}

/// ------------------------- E N D ----------------------------
/// ------------ C H A N G E  P A S S W O R D ------------------

///############################################################

///
///
/// ----------------------- S T A R T --------------------------
/// --------------- E D I T  P R O F I L E ---------------------
//icon button
class BuildIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor, backgroundColor;
  final Color? borderColor;
  final double containerWidth, borderWidth, containerHeight;

  const BuildIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.containerWidth,
    required this.containerHeight,
    this.borderColor,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth,
          )),
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }
}

/// ------------------------- E N D ----------------------------
/// --------------- E D I T  P R O F I L E ---------------------

///############################################################

///
///
/// ----------------------- S T A R T --------------------------
/// -------------- D R O P D O W N  M E N U --------------------

///
///
///Dropdown Menu Test
class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final IconData? leftIcon;
  final Color? leftIconColor;

  const CustomDropdown({
    super.key,
    required this.items,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.leftIcon,
    this.leftIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String?>(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        prefixIcon: leftIcon != null
            ? Icon(
                leftIcon,
                color: leftIconColor,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Fixed radius of 10 pixels
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      hint: const Text(
        'Select an option',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String?>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      iconStyleData: const IconStyleData(
        icon: Icon(
          DeckIcons.dropdown,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Fixed radius of 10 pixels
          color: Colors.grey[200],
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// -------------- D R O P D O W N  M E N U --------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// ------------------- C H E C K B O X ------------------------

///
///
///Checkbox Widget
class DeckBox extends StatefulWidget {
  bool isChecked = false;
  DeckBox({super.key});

  @override
  State<DeckBox> createState() => DeckBoxState();
}

class DeckBoxState extends State<DeckBox> {
  bool isChecked() {
    return widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MSHCheckbox(
        size: 24,
        value: widget.isChecked,
        colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
          checkedColor: DeckColors.primaryColor,
        ),
        style: MSHCheckboxStyle.stroke,
        onChanged: (selected) {
          setState(() {
            widget.isChecked = selected;
          });
        },
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// ------------------- C H E C K B O X ------------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///
///
/// Bottom Sheet
class BuildContentOfBottomSheet extends StatelessWidget {
  final String bottomSheetButtonText;
  final IconData bottomSheetButtonIcon;
  final VoidCallback onPressed;

  const BuildContentOfBottomSheet(
      {super.key,
      required this.bottomSheetButtonText,
      required this.bottomSheetButtonIcon,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BuildButton(
        onPressed: onPressed,
        buttonText: bottomSheetButtonText,
        height: 70.0,
        borderColor: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        backgroundColor: DeckColors.gray,
        textColor: DeckColors.white,
        radius: 0.0,
        fontSize: 16,
        borderWidth: 0,
        iconColor: DeckColors.white,
        paddingIconText: 20.0,
        size: 32,
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///
///
///Floating Action Button
class DeckFAB extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final VoidCallback onPressed;
  final double? fontSize;

  const DeckFAB({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      //preferBelow: false,
      verticalOffset: -13,
      margin: const EdgeInsets.only(right: 65),
      message: text,
      textStyle: GoogleFonts.nunito(
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w900,
          color: DeckColors.white),
      decoration: BoxDecoration(
        color: backgroundColor,
        //borderRadius: BorderRadius.circular(8.0),
      ),
      child: FloatingActionButton(
        onPressed: () => onPressed(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
          ],
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

class IfCollectionEmpty extends StatelessWidget {
  final String ifCollectionEmptyText;
  final String? ifCollectionEmptySubText;
  final double ifCollectionEmptyHeight;

  const IfCollectionEmpty(
      {super.key,
      required this.ifCollectionEmptyText,
      this.ifCollectionEmptySubText,
      required this.ifCollectionEmptyHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ifCollectionEmptyHeight,
      child: Center(
          child:
              // Container(
              //     height: MediaQuery.of(context).size.width,
              //     width: MediaQuery.of(context).size.width - 100, // dunno what size
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.pinkAccent
              //     ),
              //     child:
              Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              height: 130,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  // 'assets/images/HDR-Branding.png',
                  'assets/images/Deck-Logo7.png',
                ),
              )),
          Text(
            ifCollectionEmptyText,
            style:TextStyle(
              fontFamily: 'Fraiche',
              fontSize: 30,
              color: DeckColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            ifCollectionEmptySubText ?? "",
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )
          // )
          ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({super.key});

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool customIcon = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              'Instructions ',
              style: GoogleFonts.nunito(
                color: DeckColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            trailing: Icon(customIcon
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded),
            onExpansionChanged: (bool expanded) {
              setState(() {
                customIcon = expanded;
              });
            },
            tilePadding: const EdgeInsets.all(10),
            backgroundColor: DeckColors.gray,
            collapsedBackgroundColor: DeckColors.gray,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: DeckColors.gray),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  '1. Provide information in the "Enter Description" text field to '
                  'guide AI in generating content for your flashcards.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '2. Next, use the "Enter Subject" and "Enter Topic" fields to assist AI in '
                  'generating a more specific and relevant set of flashcards.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '3. Optionally, if you want to upload a PDF instead; just upload your existing PDF and '
                  'it will prompt the application to automatically generate flashcards for you.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '4.  Ensure that you specified the number (2-20) of flashcards you desire'
                  ' for the AI to generate.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Note: You have the ability to employ both features simultaneously. Also, the AI may generate less flashcards than what you have indicated due to lack of information. Moreover, rest assured that AI-generated flashcards content can be edited by the user.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

/// THIS METHOD IS FOR THE DECKS CONTAINER IN THE FLASHCARD PAGE
class BuildDeckContainer extends StatefulWidget {
  final String? deckCoverPhotoUrl;
  final String titleOfDeck;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback? onRetrieve;
  final bool enableSwipeToRetrieve;

  const BuildDeckContainer({
    super.key,
    required this.onDelete,
    this.onRetrieve,
    this.enableSwipeToRetrieve = true,
    this.deckCoverPhotoUrl,
    required this.titleOfDeck,
    required this.onTap,
  });

  @override
  State<BuildDeckContainer> createState() => BuildDeckContainerState();
}

class BuildDeckContainerState extends State<BuildDeckContainer> {
  Color _containerColor = DeckColors.gray;
  final String defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=2b0faebd-9691-4c37-8049-dc30289460c2";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _containerColor = Colors.grey.withOpacity(0.7);
        });
      },
      onTapUp: (_) {
        setState(() {
          _containerColor = DeckColors.gray;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _containerColor = DeckColors.gray;
        });
      },
      child: SwipeToDeleteAndRetrieve(
        onDelete: widget.onDelete,
        onRetrieve: widget.enableSwipeToRetrieve ? widget.onRetrieve : null,
        enableRetrieve: widget.enableSwipeToRetrieve,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: _containerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: (widget.deckCoverPhotoUrl != null &&
                            widget.deckCoverPhotoUrl != "no_image")
                        ? null
                        : DeckColors.coverImageColorSettings,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: (widget.deckCoverPhotoUrl != null &&
                            widget.deckCoverPhotoUrl != "no_image")
                        ? Image.network(
                            widget.deckCoverPhotoUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                defaultImageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: DeckColors.coverImageColorSettings,
                                    child: const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.grey),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Image.network(
                            defaultImageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: DeckColors.coverImageColorSettings,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.white),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titleOfDeck,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: DeckColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

class BuildTabBar extends StatelessWidget {
  final List<String> titles;
  final int length;
  final List<Widget> tabContent;

  const BuildTabBar({
    super.key,
    required this.titles,
    required this.length,
    required this.tabContent,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: DeckColors.accentColor,
              ),
              child: TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: DeckColors.primaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelColor: DeckColors.white,
                unselectedLabelColor: DeckColors.white,
                tabs: buildTabs(),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: tabContent,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildTabs() {
    return titles.map((title) {
      return buildContentTabBar(title: title);
    }).toList();
  }

  Widget buildContentTabBar({required String title}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///############################################################

///
///
/// ---------------------- S T A R T ---------------------------
/// --------------- B O T T O M  S H E E T ---------------------

class BuildContainerOfFlashCards extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve, onTap;
  final bool enableSwipeToRetrieve;
  final String titleOfFlashCard, contentOfFlashCard;
  bool isStarShaded;
  final VoidCallback onStarShaded;
  final VoidCallback onStarUnshaded;

  BuildContainerOfFlashCards({
    super.key,
    required this.onDelete,
    required this.isStarShaded,
    required this.onStarShaded,
    required this.onStarUnshaded,
    this.onRetrieve,
    required this.enableSwipeToRetrieve,
    required this.titleOfFlashCard,
    required this.contentOfFlashCard,
    this.onTap,
  });

  @override
  State<BuildContainerOfFlashCards> createState() =>
      BuildContainerOfFlashCardsState();
}

class BuildContainerOfFlashCardsState extends State<BuildContainerOfFlashCards>
    with SingleTickerProviderStateMixin {
  Color _containerColor = DeckColors.gray;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          if (widget.onTap != null) {
            _containerColor = Colors.grey.withOpacity(0.7);
          }
        });
      },
      onTapUp: (_) {
        setState(() {
          _containerColor = DeckColors.gray;
        });
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() {
          _containerColor = DeckColors.gray;
        });
      },
      child: SwipeToDeleteAndRetrieve(
        onDelete: widget.onDelete,
        onRetrieve: widget.enableSwipeToRetrieve ? widget.onRetrieve : null,
        enableRetrieve: widget.enableSwipeToRetrieve,
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: _containerColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.titleOfFlashCard,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: DeckColors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the state of isStarShaded
                        widget.isStarShaded = !widget.isStarShaded;
                        if (widget.isStarShaded) {
                          widget.onStarShaded();
                        } else {
                          widget.onStarUnshaded();
                        }
                      });
                    },
                    child: Icon(
                      size: 24,
                      widget.isStarShaded ? Icons.star : Icons.star_border,
                      color: widget.isStarShaded
                          ? DeckColors.primaryColor
                          : DeckColors.primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  color: DeckColors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  widget.contentOfFlashCard,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: DeckColors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T ---------------------

///#############################################################

///LEILA PART AFAIK
/// ----------------------- S T A R T ---------------------------
/// ------------ D E C K  S L I V E R H E A D E R ---------------

///
///
///SLiverHeader
class DeckSliverHeader extends StatelessWidget {
  final Color backgroundColor;
  final String headerTitle;
  final bool? isPinned;
  final bool hasIcon;
  final TextStyle textStyle;
  final double? max;
  final double? min;
  final VoidCallback? onPressed;
  final IconData? icon;
  const DeckSliverHeader({
    super.key,
    required this.backgroundColor,
    required this.headerTitle,
    required this.textStyle,
    this.onPressed,
    required this.hasIcon,
    this.isPinned,
    this.max,
    this.min,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: isPinned ?? true,
      floating: false,
      delegate: DeckDelegate(
        backgroundColor,
        headerTitle,
        onPressed ?? () {},
        hasIcon,
        textStyle,
        max,
        min,
        icon ?? Icons.calendar_month_rounded,
      ),
    );
  }
}

class DeckDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String headerTitle;
  final TextStyle textStyle;
  final double? max;
  final double? min;
  final VoidCallback onPressed;
  final bool hasIcon;
  final IconData icon;

  DeckDelegate(this.backgroundColor, this.headerTitle, this.onPressed,
      this.hasIcon, this.textStyle, this.max, this.min, this.icon);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
          ),
          if (hasIcon)
            BuildIconButton(
              onPressed: onPressed,
              icon: icon,
              iconColor: DeckColors.white,
              backgroundColor: backgroundColor,
              containerWidth: 60,
              containerHeight: 60,
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => max ?? 180;

  @override
  double get minExtent => min ?? 180;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// ------------------------ E N D -----------------------------
/// ------------ D E C K  S L I V E R H E A D E R --------------

///############################################################

///
/// ----------------------- S T A R T --------------------------
/// ------------ T A S K  T I L E  I N  H O M E-----------------

class HomeTaskTile extends StatelessWidget {
  final String taskName;
  final String deadline;
  // final double cardWidth;
  //final File? deckImage;
  final VoidCallback? onPressed;

  const HomeTaskTile({
    super.key,
    required this.taskName,
    required this.deadline,
    required this.onPressed,

    // required this.cardWidth,
    // required this.deckImage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: DeckColors.accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            // Use Row to position the colored box and text side by side
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns children vertically
            children: [
              Container(
                width: 10, // Set width for the colored box
                height: 60, // Set height for the colored box
                color: DeckColors.deckRed, // Set your desired color here
              ),
              const SizedBox(
                  width: 10), // Add some spacing between the box and text
              Expanded(
                // Use Expanded to fill available space
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns text to the left
                  children: [
                    Text(
                      taskName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'fraiche',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: DeckColors.white,
                      ),
                    ),
                    Text(
                      deadline,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: DeckColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// ------------ T A S K  T I L E  I N  H O M E-----------------

///############################################################

///
/// ----------------------- S T A R T --------------------------
/// ------------ D E C K  T I L E  I N  H O M E-----------------
class HomeDeckTile extends StatelessWidget {
  final String deckName;
  final Color deckColor;
  final double cardWidth;
  final String? deckImageUrl;
  final VoidCallback? onPressed;

  const HomeDeckTile({
    super.key,
    required this.deckName,
    required this.deckColor,
    required this.cardWidth,
    this.onPressed,
    this.deckImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: cardWidth,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: DeckColors.gray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: deckImageUrl != null
                          ? Image.network(
                              deckImageUrl!,
                              width: cardWidth,
                              // height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: DeckColors.gray,
                                  child: const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.white)),
                                );
                              },
                            )
                          : Container(
                              color: DeckColors.gray,
                              child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.white)),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SizedBox(
                      width: cardWidth,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: DeckColors.accentColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //   gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Colors.transparent,
                        //       Colors.black.withOpacity(0.9),
                        //     ],
                        //   ),
                        //   borderRadius: const BorderRadius.only(
                        //     bottomLeft: Radius.circular(10),
                        //     bottomRight: Radius.circular(10),
                        //   ),
                        // ),
                        child: Text(
                          deckName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Fraiche',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------- E N D ----------------------------
/// ------------ D E C K  T I L E  I N  H O M E-----------------

///############################################################

///
/// ------------ D E C K  T A S K T I L E ----------------------
/// a custom widget that is used in the task page

class DeckTaskTile extends StatefulWidget {
  final String title;
  final String deadline;
  final String priority; // high, medium, low
  String progressStatus;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve, onTap;
  final bool enableRetrieve;

  /*const*/ DeckTaskTile({
    super.key,
    required this.title,
    required this.deadline,
    required this.priority,
    this.progressStatus = 'to do',
    required this.onDelete,
    this.onRetrieve,
    this.enableRetrieve = false,
    this.onTap,
  });

  @override
  State<DeckTaskTile> createState() => DeckTaskTileState();
}

class DeckTaskTileState extends State<DeckTaskTile> {
  Color _containerColor = DeckColors.gray; // Default color

  @override
  void initState() {
    super.initState();
    _updatePriorityColor(); // Set initial color based on priority
  }

  // Function to change icon based on task status
  IconData _getProgressIcon() {
    switch (widget.progressStatus.toLowerCase()) {
      case 'to do':
        return Icons.circle_outlined;
      case 'in progress':
        return Icons.circle;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.circle_outlined;
    }
  }

  // Function to set the container color based on priority level
  Color _updatePriorityColor() {
    switch (widget.priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.yellow;
      case "low":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }



  void _onProgressChange(String value) {
    setState(() {
      widget.progressStatus = value; // Update the progress status
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          if (widget.onTap != null) {
            _containerColor = DeckColors.accentColor.withOpacity(0.7);
          }
        });
      },
      onTapUp: (_) {
        _containerColor = DeckColors.accentColor;
        widget.onTap?.call();
      },
      onTapCancel: () {
        _containerColor = DeckColors.accentColor;
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SwipeToDeleteAndRetrieve(
          onRetrieve: widget.enableRetrieve ? widget.onRetrieve : null,
          enableRetrieve: widget.enableRetrieve,
          onDelete: widget.onDelete,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _containerColor,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              fontSize: 20,
                              color: DeckColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.deadline,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: DeckColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    color: _updatePriorityColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class DeckTaskTile extends StatefulWidget {
//   final String title;
//   final String deadline;
//   final bool isChecked;
//   final ValueChanged<bool?> onChanged;
//   final VoidCallback onDelete;
//   final VoidCallback? onRetrieve, onTap;
//   final bool enableRetrieve;
//
//   const DeckTaskTile({
//     super.key,
//     required this.title,
//     required this.deadline,
//     required this.isChecked,
//     required this.onChanged,
//     required this.onDelete,
//     this.onRetrieve,
//     this.enableRetrieve = false,
//     this.onTap,
//   });
//
//   @override
//   State<DeckTaskTile> createState() => DeckTaskTileState();
// }
//
// class DeckTaskTileState extends State<DeckTaskTile> {
//   Color _containerColor = DeckColors.accentColor;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           if (widget.onTap != null) {
//             _containerColor = DeckColors.accentColor.withOpacity(0.7);
//           }
//         });
//       },
//       onTapUp: (_) {
//         setState(() {
//           _containerColor = DeckColors.accentColor;
//         });
//         widget.onTap?.call();
//       },
//       onTapCancel: () {
//         setState(() {
//           _containerColor = DeckColors.accentColor;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         child: SwipeToDeleteAndRetrieve(
//           onRetrieve: widget.enableRetrieve ? widget.onRetrieve : null,
//           enableRetrieve: widget.enableRetrieve,
//           onDelete: widget.onDelete,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.0),
//               color: _containerColor,
//             ),
//             child: Row(
//               children: [
//                 Checkbox(
//                     activeColor: Colors.transparent,
//                     checkColor: DeckColors.primaryColor,
//                     value: widget.isChecked,
//                     onChanged: widget.onChanged,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                     ),
//                     side: const BorderSide(
//                       color: DeckColors.white,
//                       width: 3.0,
//                     )),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 100,
//                           child: Text(
//                             widget.title,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: DeckColors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 100,
//                           child: Text(
//                             widget.deadline,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: DeckColors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/// ------------------------- E N D ----------------------------
/// ------------ D E C K  T A S K T I L E ----------------------

///
/// M E T H O D  T O  C A L L  L O A D I N G
///

void showLoad(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: DeckColors.primaryColor,
        ),
      );
    },
  );
}

///
/// M E T H O D  T O  H I D E  L O A D I N G
///

void hideLoad(BuildContext context) {
  Navigator.of(context).pop();
}

/// ------------------------- S T A R T ----------------------------
/// ------------ D E C K  I N T R O P A G E----------------------
///

class DeckIntroPage extends StatelessWidget {
  final String img;
  final String text;

  const DeckIntroPage({
    super.key,
    required this.img,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(img, fit: BoxFit.contain),
    );
  }
}







///
/// ------------------------- E N D ----------------------------
/// ------------ D E C K  I N T R O P A G E----------------------
