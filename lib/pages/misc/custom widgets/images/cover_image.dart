import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../theme/theme_provider.dart';
// import '../misc/custom widgets/buttons/custom_buttons.dart';

///
///
/// BuildCoverImage is a method for Cover Photo
class BuildCoverImage extends StatefulWidget {
  final Image? coverPhotoFile;
  final String? imageUrl; // Optional image URL
  final double borderRadiusContainer, borderRadiusImage;
  final bool isHeader; // Determines if it’s in the header

  const BuildCoverImage({
    super.key,
    this.coverPhotoFile,
    this.imageUrl,
    required this.borderRadiusContainer,
    required this.borderRadiusImage,
    this.isHeader = false, // Default to false
  });

  @override
  BuildCoverImageState createState() => BuildCoverImageState();
}

class BuildCoverImageState extends State<BuildCoverImage> {
  final String defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=2b0faebd-9691-4c37-8049-dc30289460c2";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadiusContainer),
        color: widget.coverPhotoFile != null || widget.imageUrl != null
            ? null
            : DeckColors.primaryColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadiusImage),
        child: _buildImage(),
      ),
    );
  }

  /// Decides which image to show: `coverPhotoFile`, `imageUrl`, or default.
  Widget _buildImage() {
    if (widget.coverPhotoFile != null) {
      return Image(
        image: widget.coverPhotoFile!.image,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (widget.imageUrl != null) {
      return Image.network(
        widget.imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return widget.isHeader
              ? _buildHeaderFallback()
              : _buildSelectionFallback();
        },
      );
    } else {
      return _buildSelectionFallback();
    }
  }

  /// Builds the fallback for the **header** when the image fails to load.
  Widget _buildHeaderFallback() {
    return Container(
      color: DeckColors.white,
      child: const Center(
        child: Icon(Icons.photo, color: DeckColors.primaryColor, size: 50),
      ),
    );
  }

  /// Builds the fallback for **selection** when no image is selected.
  Widget _buildSelectionFallback() {
    return Container(
      color: DeckColors.primaryColor,
      child: const Center(
        child: Icon(Icons.add_a_photo, color: Colors.white, size: 50),
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
