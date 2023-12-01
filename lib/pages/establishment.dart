import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/models/establishment.dart';
import 'package:yeley_frontend/pages/picture.dart';
import 'package:yeley_frontend/providers/users.dart';
import 'package:yeley_frontend/services/api.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentPage extends StatefulWidget {
  final Establishment establishment;
  const EstablishmentPage({super.key, required this.establishment});

  @override
  State<EstablishmentPage> createState() => _EstablishmentPageState();
}

class _EstablishmentPageState extends State<EstablishmentPage> {
  Widget _buildInformations() {
    final UsersProvider usersProvider = context.read<UsersProvider>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.establishment.name,
              style: kBold22.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.heart,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Text(
                  "${widget.establishment.likes} J'aimes ",
                  style: kRegular16.copyWith(color: Colors.grey),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Text(
                  "${(Geolocator.distanceBetween(
                        usersProvider.address!.coordinates[1],
                        usersProvider.address!.coordinates[0],
                        widget.establishment.coordinates[1],
                        widget.establishment.coordinates[0],
                      ) / 1000).toStringAsFixed(2)} Km ",
                  style: kRegular16.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                const Text(
                  "€€",
                  style: kBold16,
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
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: kMainGreen,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.establishment.fullAddress,
                    style: kRegular14.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kMainGreen.withOpacity(0.2),
                          shadowColor: Colors.transparent,
                          shape: const StadiumBorder(),
                          side: const BorderSide(color: kMainGreen)),
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${widget.establishment.coordinates[1]},${widget.establishment.coordinates[0]}');

                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 5),
                          const Icon(
                            CupertinoIcons.map,
                            color: kMainGreen,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Direction",
                            style: kBold14.copyWith(
                              color: kMainGreen,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kMainGreen, shape: const StadiumBorder(), shadowColor: Colors.transparent),
                      onPressed: () async {
                        final Uri url = Uri.parse('tel:${widget.establishment.phone}');

                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 5),
                          const Icon(
                            CupertinoIcons.phone_arrow_up_right,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Appeler",
                            style: kBold14.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Define the start position for informations.
    /// Which is the half size of the background image.
    double topPosition = MediaQuery.of(context).size.height;
    topPosition = topPosition * 0.35;
    topPosition = topPosition / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            Container(
              color: kScaffoldBackground,
              width: double.infinity,
            ),
            FractionallySizedBox(
              heightFactor: 0.35,
              child: Container(
                foregroundDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0,
                      0.8,
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        "$kApiUrl/establishments/picture/${widget.establishment.picturesPaths.first}",
                        headers: {
                          'Authorization': 'Bearer ${Api.jwt}',
                        }),
                  ),
                ),
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
                  const SizedBox(width: 30),
                  Text(
                    'Détail de l\'établissement',
                    style: kBold22.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: topPosition, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInformations(),
                  const SizedBox(height: 20),
                  const Text("Photos", style: kBold22),
                  const SizedBox(height: 15),
                  Expanded(
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(widget.establishment.picturesPaths.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PicturePage(
                                    picturePath: widget.establishment.picturesPaths[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      "$kApiUrl/establishments/picture/${widget.establishment.picturesPaths[index]}",
                                      headers: {
                                        'Authorization': 'Bearer ${Api.jwt}',
                                      }),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
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
