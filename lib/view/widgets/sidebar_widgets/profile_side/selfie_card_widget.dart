import 'dart:io';

import 'package:dima2022/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/size_config.dart';
import '../../common/custom_button.dart';

class SelfieCard extends StatefulWidget {
  final String? userImageUrl;

  const SelfieCard({super.key, this.userImageUrl});

  @override
  _SelfieCardState createState() => _SelfieCardState();
}

class _SelfieCardState extends State<SelfieCard> {
  final _picker = ImagePicker();
  PickedFile? _image;

  Future _getImage() async {
    final image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var avatarDim = getProportionateScreenHeight(200);

    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              // Add the avatar image
              Container(
                width: avatarDim,
                height: avatarDim,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(
                            File(_image!.path),
                          ),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image:
                              NetworkImage(widget.userImageUrl ?? userAvatar),
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              Container(
                width: avatarDim,
                height: avatarDim,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(50),
          ),
          CustomButton(
            transparent: false,
            text: "Upload Selfie",
            onPressed: _getImage,
          ),
        ],
      ),
    );
  }
}
