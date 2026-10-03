import '../models/models.dart';

/// In-memory mock data service.
/// Replace this with a real backend (Firebase/REST) in a later phase.
class MockDataService {
  MockDataService._();

  static final MockDataService instance = MockDataService._();

  // ─── Seed data ──────────────────────────────────────────────────────────────

  static final List<CampusItem> _items = [
    CampusItem(
      id: 'item-001',
      title: 'MacBook Pro 14" (Silver)',
      description:
          'Left in the CS lab on the 3rd floor of the Engineering building. '
          'Has a CampusFind sticker on the lid. Charger was also left behind.',
      category: ItemCategory.electronics,
      status: ItemStatus.lost,
      location: 'Engineering Building – CS Lab, 3rd Floor',
      reportedAt: DateTime.now().subtract(const Duration(hours: 3)),
      reportedBy: 'Aditya Sharma',
      contactEmail: 'aditya.sharma@campus.edu',
      tags: ['laptop', 'apple', 'macbook', 'computer'],
    ),
    CampusItem(
      id: 'item-002',
      title: 'Student ID Card – Priya Mehta',
      description:
          'Found a student ID card near the cafeteria entrance. '
          'Name on card: Priya Mehta. Please contact to collect.',
      category: ItemCategory.documents,
      status: ItemStatus.found,
      location: 'Central Cafeteria – Main Entrance',
      reportedAt: DateTime.now().subtract(const Duration(hours: 6)),
      reportedBy: 'Rohan Kapoor',
      contactEmail: 'rohan.kapoor@campus.edu',
      tags: ['id card', 'student card', 'identification'],
    ),
    CampusItem(
      id: 'item-003',
      title: 'Blue JanSport Backpack',
      description:
          'Dark blue backpack with a keychain of a small Pikachu figure. '
          'Contains notebooks and a water bottle. Found near the library entrance.',
      category: ItemCategory.bags,
      status: ItemStatus.found,
      location: 'Main Library – Front Entrance',
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
      reportedBy: 'Sneha Rao',
      contactEmail: 'sneha.rao@campus.edu',
      tags: ['backpack', 'bag', 'blue', 'jansport'],
    ),
    CampusItem(
      id: 'item-004',
      title: 'Black Sony Headphones (WH-1000XM5)',
      description:
          'Noise-cancelling over-ear headphones in a black carrying case. '
          'Left in the reading room of the library. Initials "R.V." written inside.',
      category: ItemCategory.electronics,
      status: ItemStatus.lost,
      location: 'Main Library – Reading Room B',
      reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      reportedBy: 'Rahul Verma',
      contactEmail: 'rahul.verma@campus.edu',
      tags: ['headphones', 'sony', 'audio', 'wireless'],
    ),
    CampusItem(
      id: 'item-005',
      title: 'Honda Activa Key Set',
      description:
          'A set of two keys on a red lanyard. Honda Activa key + room key. '
          'Lost somewhere between the parking lot and the hostel block.',
      category: ItemCategory.keys,
      status: ItemStatus.lost,
      location: 'Parking Lot C / Hostel Block 2',
      reportedAt: DateTime.now().subtract(const Duration(days: 2)),
      reportedBy: 'Karan Nair',
      contactEmail: 'karan.nair@campus.edu',
      tags: ['keys', 'honda', 'scooter', 'lanyard'],
    ),
    CampusItem(
      id: 'item-006',
      title: 'Grey Hoodie (Size M)',
      description:
          'Plain grey hoodie with a small embroidered "NIT" logo on the left chest. '
          'Left on a bench outside the sports complex.',
      category: ItemCategory.clothing,
      status: ItemStatus.found,
      location: 'Sports Complex – Outdoor Benches',
      reportedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      reportedBy: 'Divya Iyer',
      contactEmail: 'divya.iyer@campus.edu',
      tags: ['hoodie', 'grey', 'clothing', 'jacket'],
    ),
    CampusItem(
      id: 'item-007',
      title: 'Scientific Calculator (Casio FX-991)',
      description:
          'Casio FX-991EX classwiz calculator with name "Ananya" written in marker on the back. '
          'Found in classroom 201.',
      category: ItemCategory.electronics,
      status: ItemStatus.returned,
      location: 'Lecture Hall Block – Room 201',
      reportedAt: DateTime.now().subtract(const Duration(days: 3)),
      reportedBy: 'Vikram Singh',
      contactEmail: 'vikram.singh@campus.edu',
      tags: ['calculator', 'casio', 'electronics', 'maths'],
      isResolved: true,
    ),
    CampusItem(
      id: 'item-008',
      title: 'Purple Wallet with Student Cards',
      description:
          'Small purple zip wallet containing two debit cards, a library card, '
          'and some cash. Found near the ATM in the admin block.',
      category: ItemCategory.bags,
      status: ItemStatus.claimed,
      location: 'Admin Block – ATM Lobby',
      reportedAt: DateTime.now().subtract(const Duration(days: 4)),
      reportedBy: 'Meera Joshi',
      contactEmail: 'meera.joshi@campus.edu',
      tags: ['wallet', 'purple', 'cards', 'cash'],
      isResolved: true,
    ),
    CampusItem(
      id: 'item-009',
      title: 'Data Structures & Algorithms Textbook',
      description:
          'CLRS "Introduction to Algorithms" 3rd Edition with extensive highlights. '
          'Left in the seminar room after the algorithms lecture.',
      category: ItemCategory.books,
      status: ItemStatus.found,
      location: 'Seminar Room 3 – CS Department',
      reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      reportedBy: 'Arjun Patel',
      contactEmail: 'arjun.patel@campus.edu',
      tags: ['book', 'textbook', 'algorithms', 'CLRS'],
    ),
    CampusItem(
      id: 'item-010',
      title: 'Fossil Smartwatch (Brown Strap)',
      description:
          'Fossil Gen 6 smartwatch with a brown leather strap and scratched glass. '
          'Lost during the inter-college football tournament.',
      category: ItemCategory.accessories,
      status: ItemStatus.lost,
      location: 'Sports Ground – Football Field',
      reportedAt: DateTime.now().subtract(const Duration(hours: 18)),
      reportedBy: 'Ishaan Malhotra',
      contactEmail: 'ishaan.malhotra@campus.edu',
      tags: ['watch', 'smartwatch', 'fossil', 'brown'],
    ),
    CampusItem(
      id: 'item-011',
      title: 'Prescription Glasses (Black Frame)',
      description:
          'Black-framed prescription glasses in a brown hard case. '
          'Left at a table in the food court. High prescription (-5.5).',
      category: ItemCategory.accessories,
      status: ItemStatus.found,
      location: 'Food Court – Table Area Near Window',
      reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      reportedBy: 'Neha Gupta',
      contactEmail: 'neha.gupta@campus.edu',
      tags: ['glasses', 'spectacles', 'black frame', 'prescription'],
    ),
    CampusItem(
      id: 'item-012',
      title: 'Gym Bag (Nike, Black & Red)',
      description:
          'Nike gym bag, black with red accents, containing gym clothes and a water bottle. '
          'Left in locker room 4 of the sports complex.',
      category: ItemCategory.bags,
      status: ItemStatus.lost,
      location: 'Sports Complex – Locker Room 4',
      reportedAt: DateTime.now().subtract(const Duration(hours: 10)),
      reportedBy: 'Siddharth Reddy',
      contactEmail: 'siddharth.reddy@campus.edu',
      tags: ['gym bag', 'nike', 'bag', 'sports'],
    ),
  ];

  // ─── Public API ─────────────────────────────────────────────────────────────

  /// All items (unfiltered)
  List<CampusItem> getAllItems() => List.unmodifiable(_items);

  /// Only lost items
  List<CampusItem> getLostItems() =>
      _items.where((i) => i.status == ItemStatus.lost).toList();

  /// Only found items
  List<CampusItem> getFoundItems() =>
      _items.where((i) => i.status == ItemStatus.found).toList();

  /// Recently resolved (returned + claimed)
  List<CampusItem> getResolvedItems() =>
      _items.where((i) => i.isResolved).toList();

  /// Recent items – last 5 by date
  List<CampusItem> getRecentItems({int limit = 6}) {
    final sorted = List<CampusItem>.from(_items)
      ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    return sorted.take(limit).toList();
  }

  /// Search by query string (title, description, tags, location)
  List<CampusItem> search(String query) {
    if (query.trim().isEmpty) return getAllItems();
    final q = query.toLowerCase();
    return _items.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.location.toLowerCase().contains(q) ||
          item.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  /// Filter by category
  List<CampusItem> filterByCategory(ItemCategory category) =>
      _items.where((i) => i.category == category).toList();

  /// Filter by status
  List<CampusItem> filterByStatus(ItemStatus status) =>
      _items.where((i) => i.status == status).toList();

  /// Get a single item by id
  CampusItem? getById(String id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Statistics summary
  Map<String, int> getStats() => {
        'total': _items.length,
        'lost': _items.where((i) => i.status == ItemStatus.lost).length,
        'found': _items.where((i) => i.status == ItemStatus.found).length,
        'returned': _items.where((i) => i.status == ItemStatus.returned).length,
        'claimed': _items.where((i) => i.status == ItemStatus.claimed).length,
      };
}
