import 'package:flutter_test/flutter_test.dart';
import 'package:campus_find/models/models.dart';
import 'package:campus_find/services/mock_data_service.dart';

void main() {
  group('MockDataService', () {
    final service = MockDataService.instance;

    test('returns all items', () {
      expect(service.getAllItems().length, greaterThan(0));
    });

    test('filters lost items correctly', () {
      final lost = service.getLostItems();
      expect(lost.every((i) => i.status == ItemStatus.lost), isTrue);
    });

    test('filters found items correctly', () {
      final found = service.getFoundItems();
      expect(found.every((i) => i.status == ItemStatus.found), isTrue);
    });

    test('search returns relevant results', () {
      final results = service.search('laptop');
      expect(results.isNotEmpty, isTrue);
    });

    test('getById returns correct item', () {
      final item = service.getById('item-001');
      expect(item, isNotNull);
      expect(item!.id, equals('item-001'));
    });

    test('getById returns null for unknown id', () {
      final item = service.getById('does-not-exist');
      expect(item, isNull);
    });

    test('getStats returns expected keys', () {
      final stats = service.getStats();
      expect(stats.containsKey('total'), isTrue);
      expect(stats.containsKey('lost'), isTrue);
      expect(stats.containsKey('found'), isTrue);
      expect(stats.containsKey('returned'), isTrue);
    });
  });

  group('CampusItem model', () {
    final item = CampusItem(
      id: 'test-001',
      title: 'Test Item',
      description: 'A test item description',
      category: ItemCategory.electronics,
      status: ItemStatus.lost,
      location: 'Main Library',
      reportedAt: DateTime(2026, 10, 1),
      reportedBy: 'Test User',
    );

    test('isLost returns true for lost status', () {
      expect(item.isLost, isTrue);
      expect(item.isFound, isFalse);
    });

    test('copyWith changes only specified fields', () {
      final updated = item.copyWith(status: ItemStatus.found);
      expect(updated.status, equals(ItemStatus.found));
      expect(updated.title, equals(item.title));
      expect(updated.id, equals(item.id));
    });

    test('equality is based on id', () {
      final same = item.copyWith(title: 'Different Title');
      expect(item, equals(same));
    });
  });
}
