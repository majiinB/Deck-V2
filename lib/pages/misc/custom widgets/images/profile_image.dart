import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
// import '../theme/theme_provider.dart';
// import '../misc/custom widgets/buttons/custom_buttons.dart';

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
