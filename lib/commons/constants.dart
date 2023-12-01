import 'package:flutter/foundation.dart';

const String kApiUrl = kReleaseMode ? 'https://api.yeley.fr' : 'https://api.yeley.fr';

enum EstablishmentType { restaurant, activity }

enum EstablishmentSwiped { liked, disliked }

enum BottomNavigation { home, favorites }
