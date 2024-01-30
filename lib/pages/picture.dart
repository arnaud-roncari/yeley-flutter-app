import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/services/api.dart';

class PicturePage extends StatefulWidget {
  final List<String> picturePaths;
  final int index;
  const PicturePage({super.key, required this.picturePaths, required this.index});

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  late PageController controller;
  late List<Widget> pictures = [];

  @override
  void initState() {
    controller = PageController(initialPage: widget.index);

    for (String picturePath in widget.picturePaths) {
      pictures.add(
        Center(
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: "$kApiUrl/establishments/picture/$picturePath",
            httpHeaders: {
              'Authorization': 'Bearer ${Api.jwt}',
            },
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: controller,
              children: pictures,
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
