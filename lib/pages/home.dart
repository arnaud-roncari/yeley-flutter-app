// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/commons/constants.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/models/establishment.dart';
import 'package:yeley_frontend/models/tag.dart';
import 'package:yeley_frontend/pages/establishment.dart';
import 'package:yeley_frontend/providers/users.dart';
import 'package:yeley_frontend/services/api.dart';
import 'package:yeley_frontend/widgets/establishment_card.dart';
import 'package:yeley_frontend/widgets/tag_chip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRestaurant = true;
  final _switchController = ValueNotifier<bool>(true);
  final _bottomBarController = ValueNotifier<bool>(true);
  final GlobalKey _kmInkWellKey = GlobalKey();
  int _range = 5;

  @override
  void initState() {
    super.initState();

    /// Set listener for the switch button (cf the package).
    _switchController.addListener(() async {
      setState(() {
        isRestaurant = _switchController.value;
      });
      await context.read<UsersProvider>().onEstablishmentTypeSwitched(context);
    });

    _bottomBarController.addListener(() async {
      await context.read<UsersProvider>().onBottomNavigationUpdated(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final usersProvider = context.read<UsersProvider>();

      /// Define the screen size.
      usersProvider.screenSize = MediaQuery.of(context).size;

      /// Fetch data
      Future.wait([
        usersProvider.getTags(context),
        usersProvider.getNearbyEstablishments(context),
      ]);
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Êtes-vous sûr ?',
            style: kBold22.copyWith(color: Colors.black),
          ),
          content: Text(
            'Votre compte sera supprimé définitivement.',
            style: kRegular16.copyWith(color: Colors.black),
          ),
          actions: context.watch<UsersProvider>().isDeleting
              ? [
                  const Center(
                      child: CircularProgressIndicator(
                    color: kMainGreen,
                  ))
                ]
              : <Widget>[
                  TextButton(
                    child: Text(
                      'Supprimer',
                      style: kRegular16.copyWith(color: Colors.red),
                    ),
                    onPressed: () async {
                      await context.read<UsersProvider>().deleteAccount(context);
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Annuler',
                      style: kRegular16.copyWith(color: Colors.black),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
        );
      },
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/yeley.svg",
            height: 45,
            width: 45,
          ),
          const Spacer(),
          if (context.watch<UsersProvider>().navigationIndex == BottomNavigation.home)
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: AdvancedSwitch(
                controller: _switchController,
                thumb: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kMainGreen,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Icon(
                      isRestaurant == true ? Icons.sports_basketball_outlined : Icons.fastfood_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                activeColor: Colors.white,
                inactiveColor: Colors.white,
                activeChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.fastfood_outlined,
                      color: kMainGreen,
                      size: 25,
                    ),
                    const Spacer(),
                    Text(
                      'Restaurants',
                      style: kRegular16.copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                  ],
                ),
                inactiveChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Activités',
                      style: kRegular16.copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.sports_basketball_outlined,
                      color: kMainGreen,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                width: 200,
                height: 50,
                enabled: true,
              ),
            ),
          const Spacer(),
          PopupMenuButton<void>(
            color: Colors.white,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
              PopupMenuItem<void>(
                child: const Text(
                  'Conditions générales d\'utilisation',
                  style: kRegular16,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/terms-of-use');
                },
              ),
              PopupMenuItem<void>(
                child: const Text(
                  'Politique de confidentialité',
                  style: kRegular16,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/privacy-policy');
                },
              ),
              PopupMenuItem<void>(
                child: const Text(
                  'Se déconnecter',
                  style: kRegular16,
                ),
                onTap: () async {
                  await context.read<UsersProvider>().logout(context);
                },
              ),
              PopupMenuItem<void>(
                child: Text(
                  'Supprimer son compte',
                  style: kRegular16.copyWith(color: Colors.red),
                ),
                onTap: () async {
                  _showMyDialog();
                },
              ),
            ],
            child: const Icon(
              Icons.settings_outlined,
              size: 30,
              color: kMainGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final UsersProvider userProvider = context.watch<UsersProvider>();
    return Container(
      height: 70,
      // I can't use "double.infinity" here, since there is rows and inkwell as childs, their size depending of this container width.
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // I don't understand why here I can't use FractionalySizedBox...
          // It crash. So I did that calculation instead.
          // 0.5 is for the grey line (container) between the inkwells.
          SizedBox(
            width: ((MediaQuery.of(context).size.width - 30) / 2) - 0.5,
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                onTap: () async {
                  await Navigator.pushNamed(context, '/address-form');
                  UsersProvider provider = context.read<UsersProvider>();
                  if (provider.navigationIndex == BottomNavigation.home) {
                    await provider.getNearbyEstablishments(context);
                  } else {
                    await Future.wait([
                      provider.getNearbyEstablishments(context),
                      provider.getNearbyFavoriteRestaurants(context),
                      provider.getNearbyFavoriteActivities(context),
                    ]);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Adresse",
                            style: kRegular14.copyWith(color: Colors.grey),
                          ),
                          const Icon(
                            Icons.location_on_outlined,
                            color: kMainGreen,
                          )
                        ],
                      ),
                      const Spacer(),
                      Text(
                        userProvider.address == null ? "" : userProvider.address!.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kRegular16.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            heightFactor: 0.7,
            child: Container(
              color: Colors.grey[350],
              width: 1,
            ),
          ),
          SizedBox(
            width: ((MediaQuery.of(context).size.width - 30) / 2) - 0.5,
            child: Material(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: InkWell(
                key: _kmInkWellKey,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                onTap: () async {
                  RenderBox box = _kmInkWellKey.currentContext!.findRenderObject() as RenderBox;
                  Offset position = box.localToGlobal(Offset.zero);
                  await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
                    items: [
                      PopupMenuItem<int>(
                        value: 5,
                        onTap: () async {
                          setState(() {
                            _range = 5;
                          });
                          await context.read<UsersProvider>().onRangeUpdated(context, _range);
                        },
                        child: const Text(
                          '5',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 10,
                        onTap: () async {
                          setState(() {
                            _range = 10;
                          });
                          await context.read<UsersProvider>().onRangeUpdated(context, _range);
                        },
                        child: const Text(
                          '10',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 15,
                        onTap: () async {
                          setState(() {
                            _range = 15;
                          });
                          await context.read<UsersProvider>().onRangeUpdated(context, _range);
                        },
                        child: const Text(
                          '15',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 20,
                        onTap: () async {
                          setState(() {
                            _range = 20;
                          });
                          await context.read<UsersProvider>().onRangeUpdated(context, _range);
                        },
                        child: const Text(
                          '25',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 50,
                        onTap: () async {
                          setState(() {
                            _range = 50;
                          });
                          await context.read<UsersProvider>().onRangeUpdated(context, _range);
                        },
                        child: const Text(
                          '50',
                          style: kRegular16,
                        ),
                      ),
                    ],
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "KM",
                            style: kRegular14.copyWith(color: Colors.grey),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      const Spacer(),
                      Text(
                        "$_range KM",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kRegular16.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    final UsersProvider usersProvider = context.watch<UsersProvider>();
    if (usersProvider.displayedTags == null || usersProvider.isTagsLoading) {
      return const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(color: kMainGreen),
        ),
      );
    }

    final List<Tag> selectedTags = context.read<UsersProvider>().selectedTags;
    final List<Widget> tagChips = [];

    /// Left padding
    tagChips.add(const SizedBox(
      width: 15,
    ));

    for (final Tag tag in usersProvider.displayedTags!) {
      // Due to front rebuild issues, the state cannot be save in the widget, but defined thanks to the provider.
      // When the state was in the widget, if you were switching from restaurants to activities, the restaurants selected tags
      // would make the activies ones selected too, but only on the front displayed, not in the provider side.
      bool isSelected = false;
      for (Tag selectedTag in selectedTags) {
        if (tag.id == selectedTag.id) {
          isSelected = true;
          break;
        }
      }

      tagChips.add(Padding(
        // The row cut the shadow, so i set some padding to fix it.
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TagChip(
          tag: tag,
          isSelected: isSelected,
          onTap: (isSelected) async {
            await context.read<UsersProvider>().onHomeTagTap(context, tag, !isSelected);
          },
        ),
      ));
      final isFirst = tagChips.isEmpty;
      if (!isFirst) {
        tagChips.add(const SizedBox(
          width: 10,
        ));
      }
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: tagChips,
        ),
      ),
    );
  }

  Widget _buildNoEstablishmentFoundMessage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/no_establishments.svg"),
            const SizedBox(height: 40),
            const Text(
              "Aucun établissement.",
              style: kBold22,
            ),
            const SizedBox(height: 15),
            Text(
              "Vous n'avez aucun établissement autours de vous pour le moment.",
              style: kRegular14.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoFavoritesMessage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/no_favorites.svg",
            ),
            const SizedBox(height: 40),
            const Text(
              "Aucun favoris.",
              style: kBold22,
            ),
            const SizedBox(height: 15),
            Text(
              "Vous n'avez rien sur votre liste pour le moment.",
              style: kRegular14.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressUndefinedMessage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/no_establishments.png"),
            const SizedBox(height: 15),
            const Text(
              "Où êtes-vous ?",
              style: kBold22,
            ),
            const SizedBox(height: 5),
            Text(
              "Remplissez votre adresse pour accéder aux établissements autour de vous !",
              style: kRegular14.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/address-form');
                UsersProvider provider = context.read<UsersProvider>();
                if (provider.navigationIndex == BottomNavigation.home) {
                  await provider.getNearbyEstablishments(context);
                } else {
                  await Future.wait([
                    provider.getNearbyEstablishments(context),
                    provider.getNearbyFavoriteRestaurants(context),
                    provider.getNearbyFavoriteActivities(context),
                  ]);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kMainGreen, shape: const StadiumBorder()),
              child: Text(
                "Définir mon adresse",
                style: kBold16.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstablishmentCards() {
    final UsersProvider userProvider = context.watch<UsersProvider>();
    final List<Establishment> establishments = userProvider.displayedEstablishments!;

    final List<Widget> establishmentCards = [];

    /// We have to loop reversely, so that the first element of the list well be displayed first, since we are using Stack widget bellow.
    /// Without the reverse loop, the first element would be the first one draw (so the last one visible, since other elements will be display on the top of it).
    ///
    /// The ternary limit the build element to 2 maximum, to avoid performances issues.
    for (int i = establishments.length < 2 ? establishments.length - 1 : 1; i >= 0; i--) {
      if (i == 0) {
        final Duration milliseconds = Duration(milliseconds: userProvider.isCardSwiped ? 400 : 0);
        final Offset position = userProvider.frontCardPosition;

        establishmentCards.add(
          LayoutBuilder(builder: (context, constraint) {
            final Offset center = constraint.smallest.center(Offset.zero);
            final double angle = userProvider.angle * pi / 180;
            final Matrix4 rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
              duration: milliseconds,
              curve: Curves.easeInOut,
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: GestureDetector(
                onPanUpdate: (details) {
                  userProvider.onUpdatePosition(details);
                },
                onPanEnd: (details) {
                  userProvider.onEndPosition(context, details);
                },
                child: EstablishmentCard(
                  key: UniqueKey(),
                  establishment: establishments[i],
                ),
              ),
            );
          }),
        );
      } else {
        establishmentCards.add(EstablishmentCard(key: UniqueKey(), establishment: establishments[i]));
      }
    }

    /// Dislike and like button
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(children: [
          ...establishmentCards,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
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
                            await context
                                .read<UsersProvider>()
                                .onCardButtonSwiped(context, EstablishmentSwiped.disliked);
                          },
                          child: const Center(
                            child: Text(
                              "🥱",
                              style: TextStyle(fontSize: 45),
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(width: 35),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
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
                          await context.read<UsersProvider>().onCardButtonSwiped(context, EstablishmentSwiped.liked);
                        },
                        child: const Center(
                          child: Text(
                            "🤩",
                            style: TextStyle(fontSize: 45),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: AdvancedSwitch(
        controller: _bottomBarController,
        thumb: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: kMainGreen.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Icon(
              context.watch<UsersProvider>().navigationIndex == BottomNavigation.home
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.house_fill,
              color: kMainGreen,
              size: 28,
            ),
          ),
        ),
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        activeChild: Padding(
          padding: const EdgeInsets.only(left: 7.5, top: 5, right: 5, bottom: 5),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: kMainGreen,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.house_fill,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 15),
                Text("Home", style: kBold14.copyWith(color: Colors.white))
              ],
            ),
          ),
        ),
        inactiveChild: Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, right: 7.5, bottom: 5),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: kMainGreen,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 15),
                Text("Favoris", style: kBold14.copyWith(color: Colors.white))
              ],
            ),
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        width: (MediaQuery.of(context).size.width - 30) * 0.80, // The horizontal padding
        height: 65,
        enabled: true,
      ),
    );
  }

  Widget _buildFavoriteCards() {
    final UsersProvider provider = context.read<UsersProvider>();
    final List<Widget> restaurantFavoriteTagChips = [];
    final List<Widget> activityFavoriteTagChips = [];

    /// Left padding
    restaurantFavoriteTagChips.add(const SizedBox(
      width: 15,
    ));
    activityFavoriteTagChips.add(const SizedBox(
      width: 15,
    ));

    /// Restaurants tags
    for (final Tag tag in provider.restaurantsTags!) {
      bool isSelected = false;
      for (Tag selectedTag in provider.favoriteSelectedRestaurantsTags) {
        if (tag.id == selectedTag.id) {
          isSelected = true;
          break;
        }
      }

      restaurantFavoriteTagChips.add(Padding(
        // The row cut the shadow, so i set some padding to fix it.
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TagChip(
          tag: tag,
          isSelected: isSelected,
          onTap: (isSelected) async {
            await context.read<UsersProvider>().onFavoriteTagTap(context, tag, !isSelected);
          },
        ),
      ));
      final isFirst = restaurantFavoriteTagChips.isEmpty;
      if (!isFirst) {
        restaurantFavoriteTagChips.add(const SizedBox(
          width: 10,
        ));
      }
    }

    /// Activities tags
    for (final Tag tag in provider.activitiesTags!) {
      bool isSelected = false;
      for (Tag selectedTag in provider.favoriteSelectedActivitiesTags) {
        if (tag.id == selectedTag.id) {
          isSelected = true;
          break;
        }
      }

      activityFavoriteTagChips.add(Padding(
        // The row cut the shadow, so i set some padding to fix it.
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TagChip(
          tag: tag,
          isSelected: isSelected,
          onTap: (isSelected) async {
            await context.read<UsersProvider>().onFavoriteTagTap(context, tag, !isSelected);
          },
        ),
      ));
      final isFirst = activityFavoriteTagChips.isEmpty;
      if (!isFirst) {
        activityFavoriteTagChips.add(const SizedBox(
          width: 10,
        ));
      }
    }

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Restaurants",
                style: kBold22,
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: restaurantFavoriteTagChips,
                ),
              ),
            ),
            const SizedBox(height: 15),
            provider.isNearbyFavoriteRestaurantsLoading
                ? const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                      color: kMainGreen,
                    )),
                  )
                : Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(provider.favoriteRestaurants!.length, (index) {
                        return Padding(
                          padding: index == 0
                              ? const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 15)
                              : const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EstablishmentPage(
                                    establishment: provider.favoriteRestaurants![index],
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  foregroundDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.black,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0,
                                        0.2,
                                        1,
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          "$kApiUrl/establishments/picture/${provider.favoriteRestaurants![index].picturesPaths[0]}",
                                          headers: {
                                            'Authorization': 'Bearer ${Api.jwt}',
                                          }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      provider.favoriteRestaurants![index].name,
                                      overflow: TextOverflow.ellipsis,
                                      style: kRegular18.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Activités",
                style: kBold22,
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: activityFavoriteTagChips,
                ),
              ),
            ),
            const SizedBox(height: 15),
            provider.isNearbyFavoriteActivitiesLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kMainGreen,
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      children: List.generate(provider.favoriteActivities!.length, (index) {
                        return Padding(
                          padding: index == 0
                              ? const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 15)
                              : const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EstablishmentPage(
                                    establishment: provider.favoriteActivities![index],
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  foregroundDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.black,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0,
                                        0.2,
                                        1,
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          "$kApiUrl/establishments/picture/${provider.favoriteActivities![index].picturesPaths[0]}",
                                          headers: {
                                            'Authorization': 'Bearer ${Api.jwt}',
                                          }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      provider.favoriteActivities![index].name,
                                      overflow: TextOverflow.ellipsis,
                                      style: kRegular18.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UsersProvider userProvider = context.watch<UsersProvider>();

    final bool isAddressUndefined = userProvider.address == null;

    if (userProvider.navigationIndex == BottomNavigation.home) {
      return Container(
        color: kScaffoldBackground,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: kScaffoldBackground,
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _buildTopBar(),
                ),
                const SizedBox(height: 15),
                _buildSearchBar(),
                const SizedBox(height: 15),
                isAddressUndefined
                    ? _buildAddressUndefinedMessage()
                    : Expanded(
                        child: Column(
                          children: [
                            _buildTags(),
                            const SizedBox(height: 15),
                            userProvider.displayedEstablishments == null || userProvider.isNearbyEstablishmentsLoading
                                ? const Expanded(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: kMainGreen,
                                      ),
                                    ),
                                  )
                                : userProvider.displayedEstablishments!.isEmpty
                                    ? _buildNoEstablishmentFoundMessage()
                                    : _buildEstablishmentCards(),
                          ],
                        ),
                      ),
                const SizedBox(height: 15),
                _buildBottomNavigationBar()
              ]),
            ),
          ),
        ),
      );
    }

    return Container(
      color: kScaffoldBackground,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kScaffoldBackground,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildTopBar(),
              ),
              const SizedBox(height: 15),
              _buildSearchBar(),
              const SizedBox(height: 15),
              isAddressUndefined
                  ? _buildAddressUndefinedMessage()
                  : Expanded(
                      child: Column(
                        children: [
                          userProvider.isFavoritesNull()
                              ? const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: kMainGreen,
                                    ),
                                  ),
                                )
                              : userProvider.isFavoritesEmpty()
                                  ? _buildNoFavoritesMessage()
                                  : _buildFavoriteCards()
                        ],
                      ),
                    ),
              const SizedBox(height: 15),
              _buildBottomNavigationBar()
            ]),
          ),
        ),
      ),
    );
  }
}
