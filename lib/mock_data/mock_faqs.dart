import '../models/faq_item.dart';

/// Sample FAQ content for Phase 1. Replace with the agency's real policies.
const List<FaqItem> mockFaqs = [
  FaqItem(
    id: 'choose-package',
    question: 'How do I choose the right package?',
    answer:
        'Start with the category that fits your group, such as family, honeymoon, or trekking, then compare duration and what is included. Each package lists its itinerary day by day.',
  ),
  FaqItem(
    id: 'customize',
    question: 'Can a trip be customized?',
    answer:
        'In this sample, packages are fixed itineraries. A real agency could explain here how it adjusts dates, hotels, or activities on request.',
  ),
  FaqItem(
    id: 'flights-visas',
    question: 'Are flights and visas included?',
    answer:
        'In the sample international packages, airfare and visa fees are listed under Excluded. Check the Included and Excluded lists on each package before you decide.',
  ),
  FaqItem(
    id: 'best-season',
    question: 'When is the best time to visit northern Pakistan?',
    answer:
        'Most northern destinations are easiest to visit from about April to October. Each destination lists its own best season.',
  ),
  FaqItem(
    id: 'demo-bookings',
    question: 'Does this site take real bookings or payments?',
    answer:
        'No. This is a demonstration website. No booking is submitted and no payment is processed.',
  ),
  FaqItem(
    id: 'cancellations',
    question: 'How do cancellations work?',
    answer:
        'Real terms will be published on the Cancellation Policy page. The text on this demo site is sample content only.',
  ),
];