import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/user_review.dart';

/// Serwis do zarządzania ocenami i komentarzami użytkowników
class UserReviewService {
  factory UserReviewService() => _instance;
  UserReviewService._internal();
  static final UserReviewService _instance = UserReviewService._internal();

  List<UserReview> _reviews = [];
  bool _isLoaded = false;

  /// Załaduj oceny z pliku JSON
  Future<void> loadReviews() async {
    if (_isLoaded) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'lib/data/user_reviews.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString) as List<dynamic>;
      final List<dynamic> reviewsJson = jsonData;

      _reviews = reviewsJson
          .map((json) => UserReview.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoaded = true;
    } catch (e) {
      debugPrint('Błąd ładowania ocen: $e');
      _reviews = [];
    }
  }

  /// Pobierz wszystkie oceny
  Future<List<UserReview>> getAllReviews() async {
    await loadReviews();
    return List.from(_reviews);
  }

  /// Pobierz oceny dla określonego odpadu
  Future<List<UserReview>> getReviewsForWaste(String wasteId) async {
    await loadReviews();
    return _reviews
        .where(
          (review) => review.itemId == wasteId && review.itemType == 'waste',
        )
        .toList();
  }

  /// Pobierz oceny dla określonej lokalizacji
  Future<List<UserReview>> getReviewsForLocation(String locationId) async {
    await loadReviews();
    return _reviews
        .where(
          (review) =>
              review.itemId == locationId && review.itemType == 'location',
        )
        .toList();
  }

  /// Pobierz oceny użytkownika
  Future<List<UserReview>> getUserReviews(String userId) async {
    await loadReviews();
    return _reviews.where((review) => review.userId == userId).toList();
  }

  /// Pobierz oceny według oceny (1-5 gwiazdek)
  Future<List<UserReview>> getReviewsByRating(int rating) async {
    await loadReviews();
    return _reviews.where((review) => review.rating == rating).toList();
  }

  /// Pobierz pozytywne oceny (4-5 gwiazdek)
  Future<List<UserReview>> getPositiveReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isPositive).toList();
  }

  /// Pobierz negatywne oceny (1-2 gwiazdki)
  Future<List<UserReview>> getNegativeReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isNegative).toList();
  }

  /// Pobierz weryfikowane oceny
  Future<List<UserReview>> getVerifiedReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isVerified).toList();
  }

  /// Pobierz oceny z tagami
  Future<List<UserReview>> getReviewsWithTags() async {
    await loadReviews();
    return _reviews.where((review) => review.hasTags).toList();
  }

  /// Pobierz oceny ze zdjęciami
  Future<List<UserReview>> getReviewsWithPhotos() async {
    await loadReviews();
    return _reviews.where((review) => review.hasPhoto).toList();
  }

  /// Pobierz świeże oceny (ostatnie 7 dni)
  Future<List<UserReview>> getFreshReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isFresh).toList();
  }

  /// Pobierz szczegółowe oceny
  Future<List<UserReview>> getDetailedReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isDetailedComment).toList();
  }

  /// Pobierz pomocne oceny
  Future<List<UserReview>> getHelpfulReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isHelpful).toList();
  }

  /// Pobierz godne uwagi oceny
  Future<List<UserReview>> getNotableReviews() async {
    await loadReviews();
    return _reviews.where((review) => review.isNotable).toList();
  }

  /// Pobierz oceny według tagu
  Future<List<UserReview>> getReviewsByTag(String tag) async {
    await loadReviews();
    return _reviews.where((review) => review.hasTag(tag)).toList();
  }

  /// Pobierz oceny zawierające określone słowo
  Future<List<UserReview>> getReviewsContainingWord(String word) async {
    await loadReviews();
    return _reviews.where((review) => review.containsWord(word)).toList();
  }

  /// Pobierz średnią ocenę dla odpadu
  Future<double> getAverageRatingForWaste(String wasteId) async {
    final reviews = await getReviewsForWaste(wasteId);
    if (reviews.isEmpty) return 0.0;

    final sum = reviews.fold(0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }

  /// Pobierz średnią ocenę dla lokalizacji
  Future<double> getAverageRatingForLocation(String locationId) async {
    final reviews = await getReviewsForLocation(locationId);
    if (reviews.isEmpty) return 0.0;

    final sum = reviews.fold(0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }

  /// Pobierz statystyki ocen
  Future<Map<String, dynamic>> getReviewStats() async {
    await loadReviews();

    final totalReviews = _reviews.length;
    final positiveReviews = _reviews.where((r) => r.isPositive).length;
    final negativeReviews = _reviews.where((r) => r.isNegative).length;
    final neutralReviews = _reviews.where((r) => r.isNeutral).length;
    final verifiedReviews = _reviews.where((r) => r.isVerified).length;
    final reviewsWithPhotos = _reviews.where((r) => r.hasPhoto).length;
    final detailedReviews = _reviews.where((r) => r.isDetailedComment).length;

    final averageRating = totalReviews > 0
        ? _reviews.fold(0, (sum, r) => sum + r.rating) / totalReviews
        : 0.0;

    return {
      'totalReviews': totalReviews,
      'positiveReviews': positiveReviews,
      'negativeReviews': negativeReviews,
      'neutralReviews': neutralReviews,
      'verifiedReviews': verifiedReviews,
      'reviewsWithPhotos': reviewsWithPhotos,
      'detailedReviews': detailedReviews,
      'averageRating': averageRating,
      'positivePercentage': totalReviews > 0
          ? (positiveReviews / totalReviews * 100).round()
          : 0,
      'negativePercentage': totalReviews > 0
          ? (negativeReviews / totalReviews * 100).round()
          : 0,
      'verifiedPercentage': totalReviews > 0
          ? (verifiedReviews / totalReviews * 100).round()
          : 0,
    };
  }

  /// Pobierz najnowsze oceny
  Future<List<UserReview>> getLatestReviews({int count = 10}) async {
    await loadReviews();
    final sorted = List<UserReview>.from(_reviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(count).toList();
  }

  /// Pobierz najwyżej oceniane odpady
  Future<List<Map<String, dynamic>>> getTopRatedWaste({int count = 10}) async {
    await loadReviews();
    final wasteReviews = <String, List<UserReview>>{};

    for (final review in _reviews) {
      if (review.itemType == 'waste') {
        wasteReviews.putIfAbsent(review.itemId, () => []).add(review);
      }
    }

    final wasteRatings = <String, double>{};
    for (final entry in wasteReviews.entries) {
      final sum = entry.value.fold(0, (sum, r) => sum + r.rating);
      wasteRatings[entry.key] = sum / entry.value.length;
    }

    final sorted = wasteRatings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(count)
        .map(
          (e) => {
            'wasteId': e.key,
            'averageRating': e.value,
            'reviewCount': wasteReviews[e.key]!.length,
          },
        )
        .toList();
  }

  /// Pobierz najwyżej oceniane lokalizacje
  Future<List<Map<String, dynamic>>> getTopRatedLocations({
    int count = 10,
  }) async {
    await loadReviews();
    final locationReviews = <String, List<UserReview>>{};

    for (final review in _reviews) {
      if (review.itemType == 'location') {
        locationReviews.putIfAbsent(review.itemId, () => []).add(review);
      }
    }

    final locationRatings = <String, double>{};
    for (final entry in locationReviews.entries) {
      final sum = entry.value.fold(0, (sum, r) => sum + r.rating);
      locationRatings[entry.key] = sum / entry.value.length;
    }

    final sorted = locationRatings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(count)
        .map(
          (e) => {
            'locationId': e.key,
            'averageRating': e.value,
            'reviewCount': locationReviews[e.key]!.length,
          },
        )
        .toList();
  }

  /// Pobierz rekomendacje na podstawie ocen
  Future<List<UserReview>> getRecommendations(
    String userId, {
    int count = 5,
  }) async {
    await loadReviews();
    final userReviews = await getUserReviews(userId);

    if (userReviews.isEmpty) {
      return await getHelpfulReviews();
    }

    // Znajdź podobnych użytkowników na podstawie ocen
    final similarUsers = <String, int>{};
    for (final review in _reviews) {
      if (review.userId != userId) {
        final userReview = userReviews.firstWhere(
          (r) => r.itemId == review.itemId,
          orElse: () => UserReview(
            id: '',
            userId: '',
            userName: '',
            itemId: '',
            itemType: '',
            rating: 0,
            comment: '',
            createdAt: DateTime.now(),
          ),
        );

        if (userReview.rating > 0) {
          final similarity = 5 - (userReview.rating - review.rating).abs();
          similarUsers[review.userId] =
              (similarUsers[review.userId] ?? 0) + similarity;
        }
      }
    }

    // Pobierz oceny podobnych użytkowników
    final recommendations = <UserReview>[];
    final sortedUsers = similarUsers.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final user in sortedUsers.take(3)) {
      final userReviews = await getUserReviews(user.key);
      for (final review in userReviews) {
        if (!userReviews.any((r) => r.itemId == review.itemId) &&
            review.isPositive &&
            !recommendations.any((r) => r.itemId == review.itemId)) {
          recommendations.add(review);
          if (recommendations.length >= count) break;
        }
      }
      if (recommendations.length >= count) break;
    }

    return recommendations.take(count).toList();
  }

  /// Pobierz trendy w ocenach
  Future<Map<String, dynamic>> getReviewTrends() async {
    await loadReviews();
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final lastMonth = now.subtract(const Duration(days: 30));

    final recentReviews = _reviews
        .where((r) => r.createdAt.isAfter(lastWeek))
        .toList();
    final monthlyReviews = _reviews
        .where((r) => r.createdAt.isAfter(lastMonth))
        .toList();

    final recentPositive = recentReviews.where((r) => r.isPositive).length;
    final recentNegative = recentReviews.where((r) => r.isNegative).length;
    final monthlyPositive = monthlyReviews.where((r) => r.isPositive).length;
    final monthlyNegative = monthlyReviews.where((r) => r.isNegative).length;

    return {
      'recentReviews': recentReviews.length,
      'recentPositive': recentPositive,
      'recentNegative': recentNegative,
      'monthlyReviews': monthlyReviews.length,
      'monthlyPositive': monthlyPositive,
      'monthlyNegative': monthlyNegative,
      'positiveTrend': recentPositive > monthlyPositive / 4,
      'negativeTrend': recentNegative > monthlyNegative / 4,
    };
  }
}
