import 'enums.dart';

/// Represents a single lost or found item report on CampusFind
class CampusItem {
  final String id;
  final String title;
  final String description;
  final ItemCategory category;
  final ItemStatus status;
  final String location;
  final DateTime reportedAt;
  final String reportedBy;
  final String? contactEmail;
  final String? imageUrl;
  final List<String> tags;
  final bool isResolved;

  const CampusItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.location,
    required this.reportedAt,
    required this.reportedBy,
    this.contactEmail,
    this.imageUrl,
    this.tags = const [],
    this.isResolved = false,
  });

  bool get isLost => status == ItemStatus.lost;
  bool get isFound => status == ItemStatus.found;
  bool get isClaimed => status == ItemStatus.claimed;
  bool get isReturned => status == ItemStatus.returned;

  CampusItem copyWith({
    String? id,
    String? title,
    String? description,
    ItemCategory? category,
    ItemStatus? status,
    String? location,
    DateTime? reportedAt,
    String? reportedBy,
    String? contactEmail,
    String? imageUrl,
    List<String>? tags,
    bool? isResolved,
  }) {
    return CampusItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      location: location ?? this.location,
      reportedAt: reportedAt ?? this.reportedAt,
      reportedBy: reportedBy ?? this.reportedBy,
      contactEmail: contactEmail ?? this.contactEmail,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isResolved: isResolved ?? this.isResolved,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CampusItem && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CampusItem(id: $id, title: $title, status: $status)';
}
