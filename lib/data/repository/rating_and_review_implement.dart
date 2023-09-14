import 'package:furniture_shop/Objects/rating_and_review.dart';
import 'package:furniture_shop/data/data_source/remote/rating_and_review_firestore_service.dart';
import 'package:furniture_shop/data/repository/rating_and_review_repository.dart';

class RatingAndReviewRepositoryImpl implements RatingAndReviewRepository {
  final RatingAndReviewFirestoreService _ratingAndReviewFirestoreService;

  RatingAndReviewRepositoryImpl(
      {RatingAndReviewFirestoreService? ratingAndReviewFirestoreService})
      : _ratingAndReviewFirestoreService = ratingAndReviewFirestoreService ??
            RatingAndReviewFirestoreService();

  @override
  Future<void> addReview(RatingAndReview review) {
    return _ratingAndReviewFirestoreService.addReview(review);
  }

  @override
  Future<void> deleteReview(RatingAndReview review) {
    return _ratingAndReviewFirestoreService.deleteReview(review);
  }

  @override
  Future<List<RatingAndReview>> getAllReviewsByProduct(String productID) {
    return _ratingAndReviewFirestoreService.getAllReviewsByProduct(productID);
  }

  @override
  Future<List<RatingAndReview>> getAllReviewsByUser(String userID) {
    return _ratingAndReviewFirestoreService.getAllReviewsByUser(userID);
  }

  @override
  Future<void> updateReview(
    String reviewID, {
    int? rating,
    String? review,
    bool? deleted,
  }) {
    return _ratingAndReviewFirestoreService.updateReview(
      reviewID,
      rating: rating,
      review: review,
      deleted: deleted,
    );
  }
}
