import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/models/tag.dart';
import 'package:yeley_frontend/services/api.dart';
import 'package:yeley_frontend/commons/constants.dart';

class TagChip extends StatefulWidget {
  final Tag tag;
  final Future<void> Function(bool isSelected) onTap;
  final bool isSelected;

  const TagChip({super.key, required this.tag, required this.isSelected, required this.onTap});

  @override
  State<TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: widget.isSelected ? Border.all(color: kMainGreen, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          onTap: () async {
            await widget.onTap(widget.isSelected);
          },
          child: Row(
            children: [
              const SizedBox(width: 2.5),
              widget.tag.picturePath != null
                  ? CachedNetworkImage(
                      imageUrl: '$kApiUrl/tags/picture/${widget.tag.picturePath}',
                      imageBuilder: (context, imageProvider) => Container(
                        height: 42.5,
                        width: 42.5,
                        decoration: BoxDecoration(
                            color: kMainGreen,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )),
                      ),
                      httpHeaders: {
                        'Authorization': 'Bearer ${Api.jwt}',
                      },
                    )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: kMainGreen,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                    ),
              const SizedBox(width: 15),
              Text(
                widget.tag.value,
                style: kRegular16,
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
    );
  }
}
