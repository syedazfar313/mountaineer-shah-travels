import '../core/constants/app_images.dart';
import '../models/tour_category.dart';
import '../models/tour_package.dart';

const String _sampleAvailability =
    'Illustrative availability: sample departures only, not real seat counts.';

const List<String> _domesticExcluded = [
  'Lunch and dinner unless listed',
  'Personal expenses and tips',
  'Travel insurance',
  'Anything not listed under Included',
];

const List<String> _internationalExcluded = [
  'International airfare',
  'Visa fees',
  'Travel insurance',
  'Personal expenses and tips',
  'Anything not listed under Included',
];

/// Sample tour packages for Phase 1. Prices, ratings, dates, and availability
/// are illustrative, not real business data.
final List<TourPackage> mockPackages = [
  TourPackage(
    id: 'hunza-family-escape',
    name: 'Hunza Valley Family Escape',
    destinationId: 'hunza',
    destinationName: 'Hunza',
    description:
        'A relaxed five-day family trip through Karimabad, Attabad Lake, and Passu, with short drives and plenty of free time.',
    coverImageUrl: AppImages.package('hunza-family-escape'),
    durationDays: 5,
    price: 95000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.family,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Travel to Hunza',
        description:
            'Drive along the Karakoram Highway to Karimabad and check in.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Karimabad forts',
        description: 'Visit Baltit Fort and Altit Fort and walk the old bazaar.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Attabad Lake and Passu',
        description:
            'Take a boat ride on Attabad Lake, then see the Passu Cones.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Viewpoint and free time',
        description:
            'Visit a sunset viewpoint and enjoy local orchards and food.',
      ),
      ItineraryDay(
        day: 5,
        title: 'Return journey',
        description: 'Check out and travel back toward Gilgit.',
      ),
    ],
    accommodation: 'Family rooms in mid-range hotels in Karimabad (sample).',
    transport: 'Private air-conditioned vehicle with driver.',
    included: const [
      'Accommodation with breakfast',
      'Private vehicle for the full route',
      'Entry tickets listed in the itinerary',
      'Local trip coordinator',
    ],
    excluded: _domesticExcluded,
    travelDates: [
      DateTime(2027, 5, 15),
      DateTime(2027, 6, 12),
      DateTime(2027, 7, 10),
    ],
    availabilityNote: _sampleAvailability,
    rating: 4.8,
  ),
  TourPackage(
    id: 'kashmir-neelum-honeymoon',
    name: 'Neelum Valley Honeymoon Retreat',
    destinationId: 'kashmir',
    destinationName: 'Kashmir',
    description:
        'Five quiet days in the Neelum Valley with riverside stays, a cable car to Arang Kel, and time for two.',
    coverImageUrl: AppImages.package('kashmir-neelum-honeymoon'),
    durationDays: 5,
    price: 165000,
    currency: 'PKR',
    priceBasis: 'per couple',
    category: TourCategory.honeymoon,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Into the Neelum Valley',
        description:
            'Travel from Muzaffarabad into the valley and check in by the river.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Riverside day',
        description: 'Relaxed walks and viewpoints along the Neelum River.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Arang Kel',
        description:
            'Cross by cable car and take a short hike up to Arang Kel village.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Leisure day',
        description:
            'Free time, with a bonfire dinner arranged at the hotel.',
      ),
      ItineraryDay(
        day: 5,
        title: 'Return journey',
        description: 'Check out and travel back to Muzaffarabad.',
      ),
    ],
    accommodation: 'Private riverside cottage or deluxe room (sample).',
    transport: 'Private vehicle with driver.',
    included: const [
      'Accommodation with breakfast',
      'Private vehicle for the full route',
      'Cable car tickets for Arang Kel',
      'Bonfire dinner on day 4',
    ],
    excluded: _domesticExcluded,
    travelDates: [DateTime(2027, 6, 5), DateTime(2027, 9, 4)],
    availabilityNote: _sampleAvailability,
    rating: 4.7,
  ),
  TourPackage(
    id: 'swat-kalam-group',
    name: 'Swat and Kalam Group Tour',
    destinationId: 'swat',
    destinationName: 'Swat',
    description:
        'A four-day group departure covering Malam Jabba, Kalam, and the forests of the upper valley.',
    coverImageUrl: AppImages.package('swat-kalam-group'),
    durationDays: 4,
    price: 38000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.group,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Drive to Swat',
        description: 'Travel to Swat and settle in at Mingora.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Malam Jabba',
        description: 'Visit Malam Jabba for the chairlift and mountain views.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Kalam and Ushu Forest',
        description:
            'Drive to Kalam, walk in Ushu Forest, and take a jeep toward Mahodand Lake, weather permitting.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Return journey',
        description: 'Check out and travel back.',
      ),
    ],
    accommodation: 'Shared twin rooms in standard hotels (sample).',
    transport: 'Group coach with a local jeep for the upper valley.',
    included: const [
      'Accommodation with breakfast',
      'Group coach and jeep',
      'Tour leader',
    ],
    excluded: _domesticExcluded,
    travelDates: [DateTime(2027, 4, 24), DateTime(2027, 6, 19)],
    availabilityNote: _sampleAvailability,
    rating: 4.5,
  ),
  TourPackage(
    id: 'skardu-deosai-adventure',
    name: 'Skardu and Deosai Adventure',
    destinationId: 'skardu',
    destinationName: 'Skardu',
    description:
        'Six days of lakes, a high plateau crossing at Deosai, and the cold desert of Shigar.',
    coverImageUrl: AppImages.package('skardu-deosai-adventure'),
    durationDays: 6,
    price: 130000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.adventure,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Arrival in Skardu',
        description: 'Arrive, check in, and rest to adjust to the altitude.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Lakes of Skardu',
        description: 'Visit Shangrila and Upper Kachura lakes.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Deosai National Park',
        description:
            'Full-day jeep trip across the Deosai plateau, with a stop at Sheosar Lake.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Shigar Valley',
        description:
            'Visit Shigar Fort and the Katpana Cold Desert.',
      ),
      ItineraryDay(
        day: 5,
        title: 'Optional activity day',
        description:
            'Choose a short hike or river activity (extra cost, subject to weather).',
      ),
      ItineraryDay(
        day: 6,
        title: 'Departure',
        description: 'Check out and transfer for your onward journey.',
      ),
    ],
    accommodation: 'Comfortable hotels and lodges in Skardu (sample).',
    transport: 'Private 4x4 jeep with driver for Deosai, vehicle elsewhere.',
    included: const [
      'Accommodation with breakfast',
      'Private vehicle and Deosai jeep',
      'Deosai park entry',
      'Tour guide',
    ],
    excluded: _domesticExcluded,
    travelDates: [DateTime(2027, 7, 3), DateTime(2027, 8, 7)],
    availabilityNote: _sampleAvailability,
    rating: 4.8,
  ),
  TourPackage(
    id: 'fairy-meadows-trek',
    name: 'Fairy Meadows and Beyal Camp Trek',
    destinationId: 'fairy-meadows',
    destinationName: 'Fairy Meadows',
    description:
        'A four-day guided trek to the meadow beneath Nanga Parbat, with an optional hike to Beyal Camp.',
    coverImageUrl: AppImages.package('fairy-meadows-trek'),
    durationDays: 4,
    price: 62000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.trekking,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Raikot Bridge',
        description:
            'Travel along the Karakoram Highway to Raikot Bridge and ride the jeep track to the trailhead.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Trek to Fairy Meadows',
        description:
            'Trek up to the meadow with views of Nanga Parbat.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Beyal Camp',
        description:
            'Hike to Beyal Camp for closer views, then return to the meadow.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Descent',
        description: 'Trek down, ride the jeep track, and travel back.',
      ),
    ],
    accommodation: 'Wooden huts and camping at Fairy Meadows (sample).',
    transport: 'Vehicle to Raikot Bridge and local jeep on the track.',
    included: const [
      'Hut or camp accommodation',
      'Meals on trek days',
      'Local trekking guide',
      'Jeep track fare',
    ],
    excluded: _domesticExcluded,
    travelDates: [
      DateTime(2027, 6, 11),
      DateTime(2027, 7, 16),
      DateTime(2027, 8, 20),
    ],
    availabilityNote: _sampleAvailability,
    rating: 4.6,
  ),
  TourPackage(
    id: 'karakoram-luxury-circuit',
    name: 'Karakoram Luxury Circuit',
    destinationId: 'hunza',
    destinationName: 'Hunza and Skardu',
    description:
        'Six days linking Skardu and Hunza with premium lodges, private vehicles, and unhurried sightseeing.',
    coverImageUrl: AppImages.package('karakoram-luxury-circuit'),
    durationDays: 6,
    price: 340000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.luxury,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Arrival in Skardu',
        description: 'Private transfer to a premium lodge.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Shangrila and Shigar',
        description: 'Visit Shangrila Lake and Shigar Fort at a relaxed pace.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Deosai by private jeep',
        description: 'Private jeep excursion across the Deosai plateau.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Skardu to Hunza',
        description: 'A long scenic drive to Hunza with comfort stops.',
      ),
      ItineraryDay(
        day: 5,
        title: 'Forts and private dinner',
        description:
            'Visit Baltit and Altit forts, followed by a private dinner.',
      ),
      ItineraryDay(
        day: 6,
        title: 'Attabad Lake and departure',
        description: 'Boat ride on Attabad Lake, then onward transfer.',
      ),
    ],
    accommodation: 'Premium lodges and boutique hotels (sample).',
    transport: 'Private SUV with dedicated driver throughout.',
    included: const [
      'Premium accommodation with breakfast and dinner',
      'Private SUV and driver',
      'Private guide',
      'Entry tickets and boat ride',
    ],
    excluded: _domesticExcluded,
    travelDates: [DateTime(2027, 6, 20), DateTime(2027, 9, 12)],
    availabilityNote: _sampleAvailability,
    rating: 4.9,
  ),
  TourPackage(
    id: 'naran-kaghan-budget',
    name: 'Naran and Kaghan Budget Getaway',
    destinationId: 'naran-kaghan',
    destinationName: 'Naran and Kaghan',
    description:
        'A four-day value trip to the lakes of the Kaghan Valley with shared transport.',
    coverImageUrl: AppImages.package('naran-kaghan-budget'),
    durationDays: 4,
    price: 28000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.budget,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Drive to Naran',
        description:
            'Travel toward Kaghan via Balakot and check in at a guesthouse in Naran.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Lake Saif-ul-Muluk',
        description:
            'Jeep ride to Lake Saif-ul-Muluk and free time by the shore.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Lulusar and Babusar Top',
        description:
            'Visit Lulusar Lake and Babusar Top, weather permitting.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Return journey',
        description: 'Check out and travel back.',
      ),
    ],
    accommodation: 'Shared rooms in budget guesthouses (sample).',
    transport: 'Shared coach, with a jeep to Lake Saif-ul-Muluk.',
    included: const [
      'Accommodation with breakfast',
      'Shared coach and jeep',
      'Trip coordinator',
    ],
    excluded: _domesticExcluded,
    travelDates: [
      DateTime(2027, 6, 25),
      DateTime(2027, 7, 30),
      DateTime(2027, 8, 13),
    ],
    availabilityNote: _sampleAvailability,
    rating: 4.4,
  ),
  TourPackage(
    id: 'dubai-city-and-desert',
    name: 'Dubai City and Desert Holiday',
    destinationId: 'dubai',
    destinationName: 'Dubai',
    description:
        'Five days of skyline views, old Dubai souks, and an evening in the desert.',
    coverImageUrl: AppImages.package('dubai-city-and-desert'),
    durationDays: 5,
    price: 215000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.international,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Arrival',
        description: 'Airport pickup and hotel check-in.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Old Dubai and Marina',
        description:
            'Explore Dubai Creek and the souks, then an evening at Dubai Marina.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Burj Khalifa and Dubai Mall',
        description:
            'Visit the Burj Khalifa observation deck and spend time at Dubai Mall.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Desert safari',
        description: 'Dune drive, camp activities, and dinner in the desert.',
      ),
      ItineraryDay(
        day: 5,
        title: 'Departure',
        description: 'Free morning, then airport drop-off.',
      ),
    ],
    accommodation: '4-star city hotel (sample).',
    transport: 'Airport transfers and private vehicle for tours.',
    included: const [
      'Hotel accommodation with breakfast',
      'Airport transfers',
      'Burj Khalifa observation deck ticket',
      'Desert safari with dinner',
    ],
    excluded: _internationalExcluded,
    travelDates: [
      DateTime(2027, 1, 8),
      DateTime(2027, 2, 12),
      DateTime(2027, 3, 5),
    ],
    availabilityNote: _sampleAvailability,
    rating: 4.6,
  ),
  TourPackage(
    id: 'turkiye-istanbul-cappadocia',
    name: 'Istanbul and Cappadocia Discovery',
    destinationId: 'turkiye',
    destinationName: 'T\u00FCrkiye',
    description:
        'Six days across Istanbul and Cappadocia, with the Bosphorus, old city landmarks, and fairy chimney valleys.',
    coverImageUrl: AppImages.package('turkiye-istanbul-cappadocia'),
    durationDays: 6,
    price: 410000,
    currency: 'PKR',
    priceBasis: 'per person',
    category: TourCategory.international,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Arrival in Istanbul',
        description: 'Airport pickup and hotel check-in.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Old city',
        description:
            'Visit Hagia Sophia, the Blue Mosque, and the Grand Bazaar.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Bosphorus and flight to Cappadocia',
        description:
            'Take a Bosphorus cruise, then fly to Cappadocia.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Cappadocia valleys',
        description:
            'Explore the valleys and fairy chimneys. A hot air balloon ride is optional at extra cost.',
      ),
      ItineraryDay(
        day: 5,
        title: 'Underground city and Avanos',
        description:
            'Visit an underground city and the pottery town of Avanos.',
      ),
      ItineraryDay(
        day: 6,
        title: 'Return and departure',
        description: 'Fly back to Istanbul and transfer to the airport.',
      ),
    ],
    accommodation: '4-star hotels in Istanbul and a cave hotel in Cappadocia (sample).',
    transport: 'Private transfers and domestic flights between the two regions.',
    included: const [
      'Hotel accommodation with breakfast',
      'Airport and city transfers',
      'Domestic flights Istanbul to Cappadocia and back',
      'Bosphorus cruise',
    ],
    excluded: _internationalExcluded,
    travelDates: [DateTime(2027, 4, 17), DateTime(2027, 5, 22)],
    availabilityNote: _sampleAvailability,
    rating: 4.7,
  ),
  TourPackage(
    id: 'maldives-honeymoon',
    name: 'Maldives Island Honeymoon',
    destinationId: 'maldives',
    destinationName: 'Maldives',
    description:
        'Four days at an island resort with lagoon time, a sandbank picnic, and a sunset cruise.',
    coverImageUrl: AppImages.package('maldives-honeymoon'),
    durationDays: 4,
    price: 520000,
    currency: 'PKR',
    priceBasis: 'per couple',
    category: TourCategory.honeymoon,
    itinerary: const [
      ItineraryDay(
        day: 1,
        title: 'Arrival',
        description: 'Arrive in Male and transfer by speedboat to the resort.',
      ),
      ItineraryDay(
        day: 2,
        title: 'Lagoon day',
        description: 'Snorkelling in the lagoon and time at the spa.',
      ),
      ItineraryDay(
        day: 3,
        title: 'Sandbank and sunset',
        description: 'Sandbank picnic, followed by a sunset cruise.',
      ),
      ItineraryDay(
        day: 4,
        title: 'Departure',
        description: 'Check out and transfer back to the airport.',
      ),
    ],
    accommodation: 'Overwater villa at an island resort (sample).',
    transport: 'Speedboat transfers between the airport and resort.',
    included: const [
      'Overwater villa accommodation with breakfast and dinner',
      'Speedboat transfers',
      'Sandbank picnic and sunset cruise',
    ],
    excluded: _internationalExcluded,
    travelDates: [DateTime(2027, 1, 15), DateTime(2027, 2, 19)],
    availabilityNote: _sampleAvailability,
    rating: 4.9,
  ),
];