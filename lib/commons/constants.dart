import 'package:flutter/foundation.dart';

const String kApiUrl = kReleaseMode ? 'https://DNS.COM' : 'http://localhost:3000';

enum EstablishmentType { restaurant, activity }

enum EstablishmentSwiped { liked, disliked }

enum BottomNavigation { home, favorites }
