import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/services/api.dart';

class PicturePage extends StatefulWidget {
  final String picturePath;
  const PicturePage({super.key, required this.picturePath});

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: "$kApiUrl/establishments/picture/${widget.picturePath}",
                httpHeaders: {
                  'Authorization': 'Bearer ${Api.jwt}',
                },
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
