import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/widgets/basic_list_tile.dart';
import 'package:nb_utils/nb_utils.dart';

Future showBottomSheetForUpdatePhoto(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return Wrap(children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update account photo",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ).paddingBottom(10),
              createBasicListTile(text: "Choose from Cloudbox", icon: Icons.camera_alt),
              createBasicListTile(text: "Choose from gallery", icon: Icons.my_library_books_outlined).onTap(() {
                ImagePicker().pickImage(source: ImageSource.gallery);
              }),
              createBasicListTile(text: "Use Camera", icon: Icons.photo_album_rounded).onTap(() {
                ImagePicker().pickImage(source: ImageSource.camera);
              }),
            ],
          ).paddingAll(10),
        ),
      ]);
    },
  );
}
