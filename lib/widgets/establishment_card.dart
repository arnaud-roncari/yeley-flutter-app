import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/models/establishment.dart';
import 'package:yeley_frontend/pages/establishment.dart';
import 'package:yeley_frontend/providers/users.dart';
import 'package:yeley_frontend/services/api.dart';
import 'package:geolocator/geolocator.dart';

class EstablishmentCard extends StatefulWidget {
  final Establishment establishment;
  const EstablishmentCard({super.key, required this.establishment});

  @override
  State<EstablishmentCard> createState() => _EstablishmentCardState();
}

class _EstablishmentCardState extends State<EstablishmentCard> {
  final PreloadPageController controller = PreloadPageController();

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildIndicators() {
    final List<Widget> indicators = [];
    for (int i = 0; i < widget.establishment.picturesPaths.length; i++) {
      indicators.add(Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: currentPage == i ? kMainGreen : Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
      ));

      final bool isNotLast = i != widget.establishment.picturesPaths.length - 1;
      if (isNotLast) {
        indicators.add(const SizedBox(height: 10));
      }
    }

    return Container(
      width: 20,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ...indicators,
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCardSummary() {
    final UsersProvider userProvider = context.watch<UsersProvider>();
    return Padding(
      // Buttons size with the padding
      padding: const EdgeInsets.only(bottom: 110, left: 15, right: 15),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.establishment.name,
              style: kBold22.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  "${widget.establishment.likes} J'aimes ",
                  style: kRegular16.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${(Geolocator.distanceBetween(
                        userProvider.address!.coordinates[1],
                        userProvider.address!.coordinates[0],
                        widget.establishment.coordinates[1],
                        widget.establishment.coordinates[0],
                      ) / 1000).toStringAsFixed(2)} Km ",
                  style: kRegular16.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  "€€",
                  style: kBold16.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.establishment.tags.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: kMainGreen,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          color: kMainGreen.withOpacity(0.1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          e.value,
                          style: kBold14.copyWith(
                            color: kMainGreen,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstablishmentPage(
                      establishment: context.read<UsersProvider>().displayedEstablishments!.first,
                    ),
                  ),
                );
              },
              child: PreloadPageView(
                preloadPagesCount: widget.establishment.picturesPaths.length,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                controller: controller,
                scrollDirection: Axis.vertical,
                children: widget.establishment.picturesPaths.map((e) {
                  return Container(
                    foregroundDecoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.4,
                          1,
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider("$kApiUrl/establishments/picture/$e", headers: {
                          'Authorization': 'Bearer ${Api.jwt}',
                        }),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            /// Defined with a least 2 elements.
            if (widget.establishment.picturesPaths.isNotEmpty && widget.establishment.picturesPaths.length > 1)
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 50),
                child: Align(alignment: Alignment.topRight, child: _buildIndicators()),
              ),

            /// Card summary informations
            _buildCardSummary(),
          ],
        ),
      ),
    );
  }
}
