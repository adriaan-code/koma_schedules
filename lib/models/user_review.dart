/// Model reprezentujący ocenę i komentarz użytkownika
class UserReview {
  // dodatkowe metadane

  const UserReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.itemId,
    required this.itemType,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.isVerified = false,
    this.photoUrl,
    this.metadata = const {},
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isVerified: json['isVerified'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }
  final String id;
  final String userId;
  final String userName;
  final String itemId; // ID odpadu lub lokalizacji
  final String itemType; // 'waste' lub 'location'
  final int rating; // 1-5 gwiazdek
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags; // tagi dla lepszego wyszukiwania
  final bool isVerified; // czy użytkownik zweryfikował utylizację
  final String? photoUrl; // URL zdjęcia
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'itemId': itemId,
      'itemType': itemType,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags,
      'isVerified': isVerified,
      'photoUrl': photoUrl,
      'metadata': metadata,
    };
  }

  /// Sprawdź czy ocena jest pozytywna (4-5 gwiazdek)
  bool get isPositive => rating >= 4;

  /// Sprawdź czy ocena jest negatywna (1-2 gwiazdki)
  bool get isNegative => rating <= 2;

  /// Sprawdź czy ocena jest neutralna (3 gwiazdki)
  bool get isNeutral => rating == 3;

  /// Pobierz tekstową reprezentację oceny
  String get ratingText {
    switch (rating) {
      case 1:
        return 'Bardzo zła';
      case 2:
        return 'Zła';
      case 3:
        return 'Średnia';
      case 4:
        return 'Dobra';
      case 5:
        return 'Bardzo dobra';
      default:
        return 'Nieznana';
    }
  }

  /// Pobierz kolor dla oceny
  String get ratingColor {
    switch (rating) {
      case 1:
        return '#FF4444'; // Czerwony
      case 2:
        return '#FF8800'; // Pomarańczowy
      case 3:
        return '#FFBB00'; // Żółty
      case 4:
        return '#88BB00'; // Zielono-żółty
      case 5:
        return '#00BB00'; // Zielony
      default:
        return '#888888'; // Szary
    }
  }

  /// Sprawdź czy ocena została zaktualizowana
  bool get isUpdated => updatedAt != null;

  /// Pobierz czas od utworzenia
  Duration get timeSinceCreated => DateTime.now().difference(createdAt);

  /// Pobierz czas od ostatniej aktualizacji
  Duration? get timeSinceUpdated =>
      updatedAt != null ? DateTime.now().difference(updatedAt!) : null;

  /// Sprawdź czy ocena ma zdjęcie
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Sprawdź czy ocena ma tagi
  bool get hasTags => tags.isNotEmpty;

  /// Sprawdź czy ocena ma metadane
  bool get hasMetadata => metadata.isNotEmpty;

  /// Pobierz skrócony komentarz (pierwsze 100 znaków)
  String get shortComment =>
      comment.length > 100 ? '${comment.substring(0, 100)}...' : comment;

  /// Sprawdź czy komentarz jest długi
  bool get isLongComment => comment.length > 100;

  /// Pobierz liczbę słów w komentarzu
  int get wordCount => comment.split(' ').length;

  /// Sprawdź czy komentarz jest szczegółowy
  bool get isDetailedComment => wordCount > 20;

  /// Pobierz tagi jako tekst
  String get tagsText => tags.join(', ');

  /// Sprawdź czy ocena zawiera określony tag
  bool hasTag(String tag) => tags.contains(tag.toLowerCase());

  /// Sprawdź czy ocena zawiera określone słowo w komentarzu
  bool containsWord(String word) =>
      comment.toLowerCase().contains(word.toLowerCase());

  /// Pobierz metadane jako tekst
  String get metadataText {
    if (metadata.isEmpty) return '';
    return metadata.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }

  /// Sprawdź czy ocena jest świeża (utworzona w ciągu ostatnich 7 dni)
  bool get isFresh => timeSinceCreated.inDays <= 7;

  /// Sprawdź czy ocena jest stara (utworzona więcej niż 30 dni temu)
  bool get isOld => timeSinceCreated.inDays > 30;

  /// Pobierz wiek oceny w dniach
  int get ageInDays => timeSinceCreated.inDays;

  /// Sprawdź czy ocena jest weryfikowana
  bool get isVerifiedReview => isVerified;

  /// Pobierz poziom szczegółowości oceny
  String get detailLevel {
    if (isDetailedComment && hasTags && hasPhoto) {
      return 'Bardzo szczegółowa';
    } else if (isDetailedComment && (hasTags || hasPhoto)) {
      return 'Szczegółowa';
    } else if (isDetailedComment || hasTags || hasPhoto) {
      return 'Średnia';
    } else {
      return 'Podstawowa';
    }
  }

  /// Pobierz ocenę jako emoji
  String get ratingEmoji {
    switch (rating) {
      case 1:
        return '😞';
      case 2:
        return '😐';
      case 3:
        return '😑';
      case 4:
        return '😊';
      case 5:
        return '😍';
      default:
        return '❓';
    }
  }

  /// Sprawdź czy ocena jest pomocna (pozytywna i szczegółowa)
  bool get isHelpful => isPositive && isDetailedComment;

  /// Sprawdź czy ocena jest problematyczna (negatywna i szczegółowa)
  bool get isProblematic => isNegative && isDetailedComment;

  /// Pobierz priorytet oceny (wyższy dla weryfikowanych i szczegółowych)
  int get priority {
    int priority = 0;
    if (isVerified) priority += 10;
    if (isDetailedComment) priority += 5;
    if (hasPhoto) priority += 3;
    if (hasTags) priority += 2;
    if (isFresh) priority += 1;
    return priority;
  }

  /// Sprawdź czy ocena jest godna uwagi
  bool get isNotable => priority >= 8;

  /// Pobierz kategoryzację oceny
  String get category {
    if (isPositive && isDetailedComment) {
      return 'Pozytywna i szczegółowa';
    } else if (isNegative && isDetailedComment) {
      return 'Negatywna i szczegółowa';
    } else if (isPositive) {
      return 'Pozytywna';
    } else if (isNegative) {
      return 'Negatywna';
    } else {
      return 'Neutralna';
    }
  }

  /// Sprawdź czy ocena jest kompletna
  bool get isComplete =>
      comment.isNotEmpty && tags.isNotEmpty && hasPhoto && isVerified;

  /// Pobierz procent kompletności
  double get completenessPercentage {
    int completed = 0;
    const int total = 4;

    if (comment.isNotEmpty) completed++;
    if (tags.isNotEmpty) completed++;
    if (hasPhoto) completed++;
    if (isVerified) completed++;

    return (completed / total) * 100;
  }

  /// Sprawdź czy ocena jest w pełni kompletna
  bool get isFullyComplete => completenessPercentage == 100;

  /// Pobierz poziom jakości oceny
  String get qualityLevel {
    if (isFullyComplete && isDetailedComment) {
      return 'Najwyższa';
    } else if (isComplete && isDetailedComment) {
      return 'Wysoka';
    } else if (isComplete || isDetailedComment) {
      return 'Średnia';
    } else {
      return 'Podstawowa';
    }
  }
}
