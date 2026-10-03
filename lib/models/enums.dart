/// Status of a lost or found item report
enum ItemStatus {
  lost,
  found,
  claimed,
  returned;

  String get label {
    switch (this) {
      case ItemStatus.lost:
        return 'Lost';
      case ItemStatus.found:
        return 'Found';
      case ItemStatus.claimed:
        return 'Claimed';
      case ItemStatus.returned:
        return 'Returned';
    }
  }
}

/// Broad category for an item
enum ItemCategory {
  electronics,
  clothing,
  accessories,
  books,
  documents,
  keys,
  bags,
  sports,
  other;

  String get label {
    switch (this) {
      case ItemCategory.electronics:
        return 'Electronics';
      case ItemCategory.clothing:
        return 'Clothing';
      case ItemCategory.accessories:
        return 'Accessories';
      case ItemCategory.books:
        return 'Books & Notes';
      case ItemCategory.documents:
        return 'Documents & ID';
      case ItemCategory.keys:
        return 'Keys';
      case ItemCategory.bags:
        return 'Bags & Wallets';
      case ItemCategory.sports:
        return 'Sports & Recreation';
      case ItemCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case ItemCategory.electronics:
        return '💻';
      case ItemCategory.clothing:
        return '👕';
      case ItemCategory.accessories:
        return '⌚';
      case ItemCategory.books:
        return '📚';
      case ItemCategory.documents:
        return '📄';
      case ItemCategory.keys:
        return '🔑';
      case ItemCategory.bags:
        return '👜';
      case ItemCategory.sports:
        return '⚽';
      case ItemCategory.other:
        return '📦';
    }
  }
}
