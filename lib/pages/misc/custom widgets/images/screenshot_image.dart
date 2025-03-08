import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../buttons/icon_button.dart';

class BuildScreenshotImage extends StatefulWidget {


  const BuildScreenshotImage({
    super.key,
  });

  @override
  BuildScreenshotImageState createState() => BuildScreenshotImageState();
}

class BuildScreenshotImageState extends State<BuildScreenshotImage> {

  final String defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=2b0faebd-9691-4c37-8049-dc30289460c2";
  List <String> uploadedImagesName = [];
  double progress = 0.0;
  bool isUploading = false;
  bool isVisible = true;
  final ImagePicker picker = ImagePicker();

  void _simulateUpload() {
    setState(() {
      isUploading = true;
      progress = 0.0;
    });

    ///Simulate upload progress with a timer; SIMULATION LANG!!! I  just wanna see if it works
    Future.delayed(Duration(milliseconds: 100), () {
      for (int i = 0; i <= 100; i++) {
        Future.delayed(Duration(milliseconds: 50 * i), () {
          if (isUploading) {
            setState(() {
              progress = i / 100;
            });
          }
        });
      }
    });
  }

  ///This removes the container when user clicks the X button
  void _cancelUpload() {
    setState(() {
      isUploading = false;
      progress = 0.0;
    });
  }

  Future<void> _pickImage() async {
    ///check if the limit of 3 images has been reached
    if (uploadedImagesName.length >= 3){
      ///show dialog box
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Upload Limit Reached'),
          content: const Text('You can only upload up to 3 images.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; //exit if limit is reached
    }
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        uploadedImagesName.add(image.name); //get the file name of the selected image
      });

      ///starts the simulated (SIMULATION LANG EHE) upload process
      _simulateUpload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: DeckColors.white,
                border: Border.all(
                  color: DeckColors.primaryColor,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Icon(
                    Icons.upload_file_rounded,
                    color: DeckColors.primaryColor,
                    size: 50
                ),
              ),
            ),
            Positioned(
              top: 140,
              right: 10,
              child: BuildIconButton(
                containerWidth: 40,
                containerHeight: 40,
                onPressed: _pickImage,
                icon: DeckIcons.pencil,
                iconColor: DeckColors.white,
                backgroundColor: DeckColors.primaryColor,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _buildFileItems(),
        ),

      ],
    );
  }


  Widget _buildFileItems() {
    return Column(
      children: List.generate(uploadedImagesName.length, (index) {
        return _buildFileItem(uploadedImagesName[index], index);
      }),
    );
  }

  ///This is the container for the files being uploaded
  Widget _buildFileItem(String imageName, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: DeckColors.white,
            border: Border.all(
              color: DeckColors.primaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
              )
            ]
        ),
        child: Row(
          children: [
            const Icon(Icons.image_rounded,
                color: DeckColors.primaryColor,
                size: 50),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        imageName,
                        style: const TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: DeckColors.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 16,
                          color: DeckColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      valueColor: const AlwaysStoppedAnimation(DeckColors.primaryColor),
                      backgroundColor: Colors.grey[300],
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            //If 'X' button is clicked, it will remove the item from the list
            IconButton(
              icon: const Icon(Icons.close, color: DeckColors.deckRed),
              onPressed: () {
                setState(() {
                  uploadedImagesName.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
    ///----E N D -----
  }
}
