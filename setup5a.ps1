Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\core\constants\app_images.dart' @'
/// One place for every image reference, so remote URLs can later be swapped
/// for bundled assets or Firebase Storage URLs without touching any widget.
///
/// An empty string means "no image yet": [AppImage] then shows its branded
/// fallback. To add a photo, put its URL in the map below, keyed by id.
abstract final class AppImages {
  static const Map<String, String> _destinations = {
    // 'hunza': 'https://...',
  };

  static String destination(String id) => _destinations[id] ?? '';
}
'@

W 'lib\mock_data\mock_destinations.dart' @'
import '../core/constants/app_images.dart';
import '../models/destination.dart';

/// Sample destinations for Phase 1. Replaced by Firestore data in Phase 2.
final List<Destination> mockDestinations = [
  // ---------------- Pakistan ----------------
  Destination(
    id: 'hunza',
    name: 'Hunza',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'Old forts, apricot orchards, and peaks of the Karakoram.',
    description:
        'A high mountain valley in Gilgit-Baltistan along the Karakoram Highway, known for Baltit and Altit forts, Attabad Lake, and the Passu Cones.',
    imageUrl: AppImages.destination('hunza'),
    highlights: const ['Baltit and Altit forts', 'Attabad Lake', 'Passu Cones'],
    bestSeason: 'April to October',
  ),
  Destination(
    id: 'skardu',
    name: 'Skardu',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'Lakes, deserts, and the gateway to the great Karakoram peaks.',
    description:
        'The main town of Baltistan, set on the Indus River. Visitors come for Shangrila and Satpara lakes, Shigar Fort, Katpana Cold Desert, and the high plateau of Deosai National Park.',
    imageUrl: AppImages.destination('skardu'),
    highlights: const [
      'Deosai National Park',
      'Shangrila (Lower Kachura) Lake',
      'Shigar Fort',
    ],
    bestSeason: 'May to September',
  ),
  Destination(
    id: 'gilgit',
    name: 'Gilgit',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'The crossroads of the northern mountains.',
    description:
        'The regional capital of Gilgit-Baltistan and the junction for journeys to Hunza, Skardu, and Naltar Valley. A good base along the Karakoram Highway.',
    imageUrl: AppImages.destination('gilgit'),
    highlights: const ['Kargah Buddha', 'Naltar Valley', 'Karakoram Highway'],
    bestSeason: 'April to October',
  ),
  Destination(
    id: 'fairy-meadows',
    name: 'Fairy Meadows',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'A green meadow beneath Nanga Parbat.',
    description:
        'A high alpine meadow reached by a jeep track and a trek from Raikot Bridge, with close views of Nanga Parbat, one of the highest peaks in the world.',
    imageUrl: AppImages.destination('fairy-meadows'),
    highlights: const [
      'Nanga Parbat views',
      'Raikot Bridge jeep track',
      'Base camp trek',
    ],
    bestSeason: 'May to September',
  ),
  Destination(
    id: 'naran-kaghan',
    name: 'Naran and Kaghan',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'Alpine lakes and green valleys of the Kaghan Valley.',
    description:
        'A popular summer valley in Khyber Pakhtunkhwa with Lake Saif-ul-Muluk, Lulusar Lake, and Babusar Top.',
    imageUrl: AppImages.destination('naran-kaghan'),
    highlights: const ['Lake Saif-ul-Muluk', 'Lulusar Lake', 'Babusar Top'],
    bestSeason: 'June to September',
  ),
  Destination(
    id: 'swat',
    name: 'Swat',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'Green valleys, rivers, and easy mountain getaways.',
    description:
        'A valley in Khyber Pakhtunkhwa with the hill resorts of Malam Jabba and Kalam, forested slopes, and the Swat River.',
    imageUrl: AppImages.destination('swat'),
    highlights: const ['Malam Jabba', 'Kalam Valley', 'Mahodand Lake'],
    bestSeason: 'April to October',
  ),
  Destination(
    id: 'murree',
    name: 'Murree',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'A quick hill station escape from Islamabad.',
    description:
        'A hill station in the hills near Islamabad, popular for cool weather, Mall Road, and winter snow. Easy for short trips.',
    imageUrl: AppImages.destination('murree'),
    highlights: const ['Mall Road', 'Patriata chairlift', 'Winter snowfall'],
    bestSeason: 'March to June, and December to February for snow',
  ),
  Destination(
    id: 'kashmir',
    name: 'Kashmir',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'River valleys, forests, and quiet mountain villages.',
    description:
        'Azad Jammu and Kashmir offers the Neelum Valley, Arang Kel, and Ratti Gali Lake, with forested hills and clear mountain rivers.',
    imageUrl: AppImages.destination('kashmir'),
    highlights: const ['Neelum Valley', 'Arang Kel', 'Ratti Gali Lake'],
    bestSeason: 'April to October',
  ),

  // ---------------- International ----------------
  Destination(
    id: 'dubai',
    name: 'Dubai',
    country: 'United Arab Emirates',
    region: DestinationRegion.international,
    tagline: 'Skyline views, desert evenings, and world-class shopping.',
    description:
        'A modern city of record-setting towers, beaches, malls, and desert safaris, with frequent flights from Pakistan.',
    imageUrl: AppImages.destination('dubai'),
    highlights: const ['Burj Khalifa', 'Desert safari', 'Dubai Marina'],
    bestSeason: 'November to March',
  ),
  Destination(
    id: 'saudi-arabia',
    name: 'Saudi Arabia',
    country: 'Saudi Arabia',
    region: DestinationRegion.international,
    tagline: 'Pilgrimage journeys and heritage destinations.',
    description:
        'Umrah and ziyarat packages for Makkah and Madinah, plus heritage destinations such as AlUla and the capital, Riyadh.',
    imageUrl: AppImages.destination('saudi-arabia'),
    highlights: const [
      'Umrah packages',
      'Makkah and Madinah',
      'AlUla heritage sites',
    ],
    bestSeason: 'November to March',
  ),
  Destination(
    id: 'turkiye',
    name: 'T\u00FCrkiye',
    country: 'T\u00FCrkiye',
    region: DestinationRegion.international,
    tagline: 'Where Europe meets Asia: Istanbul, Cappadocia, and the coast.',
    description:
        'Historic Istanbul, the fairy chimneys of Cappadocia, the terraces of Pamukkale, and the beaches of Antalya in one trip.',
    imageUrl: AppImages.destination('turkiye'),
    highlights: const ['Istanbul old city', 'Cappadocia', 'Pamukkale'],
    bestSeason: 'April to June, and September to October',
  ),
  Destination(
    id: 'malaysia',
    name: 'Malaysia',
    country: 'Malaysia',
    region: DestinationRegion.international,
    tagline: 'City towers, islands, and highland tea country.',
    description:
        'Kuala Lumpur and the Petronas Towers, the beaches of Langkawi, the street food of Penang, and the cool air of Genting and Cameron Highlands.',
    imageUrl: AppImages.destination('malaysia'),
    highlights: const ['Petronas Towers', 'Langkawi', 'Penang street food'],
    bestSeason: 'December to April',
  ),
  Destination(
    id: 'thailand',
    name: 'Thailand',
    country: 'Thailand',
    region: DestinationRegion.international,
    tagline: 'Beaches, temples, and lively city nights.',
    description:
        'Bangkok for temples and markets, Phuket and Krabi for beaches, and Chiang Mai for mountains and culture.',
    imageUrl: AppImages.destination('thailand'),
    highlights: const ['Bangkok', 'Phuket and Krabi', 'Chiang Mai'],
    bestSeason: 'November to February',
  ),
  Destination(
    id: 'azerbaijan',
    name: 'Azerbaijan',
    country: 'Azerbaijan',
    region: DestinationRegion.international,
    tagline: 'A modern Caspian capital and old Silk Road towns.',
    description:
        'Baku combines the walled Old City with the Flame Towers, while Gabala and Gobustan offer mountains and ancient rock art.',
    imageUrl: AppImages.destination('azerbaijan'),
    highlights: const ['Baku Old City', 'Flame Towers', 'Gabala mountains'],
    bestSeason: 'April to June, and September to October',
  ),
  Destination(
    id: 'maldives',
    name: 'Maldives',
    country: 'Maldives',
    region: DestinationRegion.international,
    tagline: 'Turquoise lagoons and private island resorts.',
    description:
        'Coral atolls with overwater villas, snorkelling, and diving, ideal for honeymoons and quiet beach holidays.',
    imageUrl: AppImages.destination('maldives'),
    highlights: const [
      'Overwater villas',
      'Snorkelling and diving',
      'Sandbank picnics',
    ],
    bestSeason: 'November to April',
  ),
  Destination(
    id: 'europe',
    name: 'Europe',
    country: 'Multiple countries',
    region: DestinationRegion.international,
    tagline: 'Classic cities, alpine views, and historic landmarks.',
    description:
        'Multi-country itineraries through cities such as Paris, Rome, and Zurich. A Schengen visa is usually required and is arranged separately from the tour package.',
    imageUrl: AppImages.destination('europe'),
    highlights: const ['Paris', 'Swiss Alps', 'Rome'],
    bestSeason: 'May to September',
  ),
];
'@

W 'lib\repositories\destination_repository.dart' @'
import '../models/destination.dart';

/// Where destination data comes from. Phase 1 uses mock data; Phase 2 will
/// add a Firestore implementation without changing any screen.
abstract interface class DestinationRepository {
  Future<List<Destination>> getAll();

  Future<Destination?> getById(String id);
}
'@

W 'lib\repositories\mock_destination_repository.dart' @'
import '../mock_data/mock_destinations.dart';
import '../models/destination.dart';
import 'destination_repository.dart';

class MockDestinationRepository implements DestinationRepository {
  const MockDestinationRepository();

  @override
  Future<List<Destination>> getAll() async => mockDestinations;

  @override
  Future<Destination?> getById(String id) async {
    for (final destination in mockDestinations) {
      if (destination.id == id) return destination;
    }
    return null;
  }
}
'@

W 'lib\repositories\destination_providers.dart' @'
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/destination.dart';
import 'destination_repository.dart';
import 'mock_destination_repository.dart';

/// The single place to swap mock data for Firebase in Phase 2.
final destinationRepositoryProvider = Provider<DestinationRepository>(
  (ref) => const MockDestinationRepository(),
);

final destinationsProvider = FutureProvider<List<Destination>>(
  (ref) => ref.watch(destinationRepositoryProvider).getAll(),
);

final destinationProvider = FutureProvider.family<Destination?, String>(
  (ref, id) => ref.watch(destinationRepositoryProvider).getById(id),
);
'@

W 'test\destination_repository_test.dart' @'
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/models/destination.dart';
import 'package:mountaineer_shah_travels/repositories/mock_destination_repository.dart';

void main() {
  const repository = MockDestinationRepository();

  test('has 8 Pakistan and 8 international destinations', () async {
    final all = await repository.getAll();
    final pakistan =
        all.where((d) => d.region == DestinationRegion.pakistan).length;
    final international =
        all.where((d) => d.region == DestinationRegion.international).length;

    expect(pakistan, 8);
    expect(international, 8);
  });

  test('destination ids are unique', () async {
    final all = await repository.getAll();
    final ids = all.map((d) => d.id).toSet();

    expect(ids.length, all.length);
  });

  test('getById finds a destination and returns null for unknown ids', () async {
    final hunza = await repository.getById('hunza');
    final unknown = await repository.getById('does-not-exist');

    expect(hunza?.name, 'Hunza');
    expect(unknown, isNull);
  });
}
'@

Write-Host ""
$mine = @(
  'lib\core\constants\app_images.dart',
  'lib\mock_data\mock_destinations.dart',
  'lib\repositories\destination_repository.dart',
  'lib\repositories\mock_destination_repository.dart',
  'lib\repositories\destination_providers.dart',
  'test\destination_repository_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5a done."