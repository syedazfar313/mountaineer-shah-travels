import '../mock_data/mock_offers.dart';
import '../models/offer.dart';
import 'offer_repository.dart';

class MockOfferRepository implements OfferRepository {
  const MockOfferRepository();

  @override
  Future<List<Offer>> getAll() async => mockOffers;
}