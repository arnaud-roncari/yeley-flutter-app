import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/providers/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRestaurant = true;
  final _switchController = ValueNotifier<bool>(true);
  final GlobalKey _kmInkWellKey = GlobalKey();
  int _range = 5;

  @override
  void initState() {
    super.initState();

    _switchController.addListener(() {
      setState(() {
        isRestaurant = _switchController.value;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<UsersProvider>().getAddress();
    });
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Image.asset("assets/yeley_logo_45.png"),
        const Spacer(),
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
                await context.read<UsersProvider>().deleteAccount(context);
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
                  Navigator.pushNamed(context, '/address-form');
                  // TODO si adresse vide, demander au user de mettre une adresse
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
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
                        userProvider.address == null ? "" : userProvider.address!.fullAddress,
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
                        onTap: () {
                          setState(() {
                            _range = 5;
                          });
                        },
                        child: const Text(
                          '5',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 10,
                        onTap: () {
                          setState(() {
                            _range = 10;
                          });
                        },
                        child: const Text(
                          '10',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 15,
                        onTap: () {
                          setState(() {
                            _range = 15;
                          });
                        },
                        child: const Text(
                          '15',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 20,
                        onTap: () {
                          setState(() {
                            _range = 20;
                          });
                        },
                        child: const Text(
                          '25',
                          style: kRegular16,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 50,
                        onTap: () {
                          setState(() {
                            _range = 50;
                          });
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
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
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

  @override
  Widget build(BuildContext context) {
    // TODO  afficher illustration si aucun etablishement returned
    return SafeArea(
        child: Scaffold(
      backgroundColor: kScaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          _buildTopBar(),
          const SizedBox(height: 15),
          _buildSearchBar(),
        ]),
      ),
    ));
  }
}
