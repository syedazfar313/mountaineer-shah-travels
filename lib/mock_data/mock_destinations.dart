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