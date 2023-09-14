import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/rating_and_review.dart';
import 'package:furniture_shop/data/data_source/rating_and_review_data_service.dart';

class RatingAndReviewFirestoreService implements RatingAndReviewDataService {
  CollectionReference reviews =
      FirebaseFirestore.instance.collection('reviews');
  @override
  Future<void> addReview(RatingAndReview review) {
    return reviews
        .doc(review.id)
        .set(review.toJson())
        .then((value) =>
            debugPrint('Added a Rating and Review with ID: ${review.id}'))
        .catchError(
            (error) => debugPrint('Failed to add a Rating and Review: $error'));
  }

  @override

  ///DO NOT USE WHEN USER REQUEST TO DELETE. To delete a review set flag isDeleted = true
  Future<void> deleteReview(RatingAndReview review) {
    return reviews
        .doc(review.id)
        .delete()
        .then((value) =>
            debugPrint('Deleted a Rating and Review with ID: ${review.id}'))
        .catchError((error) =>
            debugPrint('Failed to delete a Rating and Review: $error'));
  }

  @override
  Future<List<RatingAndReview>> getAllReviewsByProduct(String productID) async {
    List<RatingAndReview> reviewList = [];
    await reviews.where('productID', isEqualTo: productID).get().then(
        (querySnapshot) {
      debugPrint('Get all Rating and Reviews by Product successfully');
      reviewList = querySnapshot.docs
          .map(
              (e) => RatingAndReview.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    },
        onError: (error) =>
            debugPrint('Failed to get Rating and Reviews by Product: $error'));
    return Future.value(reviewList);
  }

  @override
  Future<List<RatingAndReview>> getAllReviewsByUser(String userID) async {
    List<RatingAndReview> reviewList = [];
    await reviews.where('userID', isEqualTo: userID).get().then(
        (querySnapshot) {
      debugPrint('Get all Rating and Reviews by UserID successfully');
      reviewList = querySnapshot.docs
          .map(
              (e) => RatingAndReview.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    },
        onError: (error) =>
            debugPrint('Failed to get Rating and Reviews by UserID: $error'));
    return Future.value(reviewList);
  }

  @override
  Future<void> updateReview(
    String reviewID, {
    int? rating,
    String? review,
    bool? deleted,
  }) {
    final updates = {
      if (rating != null) 'rating': rating,
      if (review != null) 'review': review,
      if (deleted != null) 'deleted': deleted,
    };
    if (updates.isNotEmpty) {
      return reviews
          .doc(reviewID)
          .update(updates)
          .then((value) =>
              debugPrint('Updated a Rating and Review with ID: $reviewID'))
          .catchError((error) =>
              debugPrint('Failed to update a Rating and Review: $error'));
    } else {
      debugPrint('Nothing to update');
      return Future.value(null);
    }
  }
}
