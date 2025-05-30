import 'package:flutter/foundation.dart';

import '../../models/feed.dart';
import '../../services/database/feeddatabase.dart';

class FeedDeductionService {
  final DatabaseServicesForFeed _dbService;

  FeedDeductionService(String userId) : _dbService = DatabaseServicesForFeed(userId);

  // Weekly deduction logic
  Future<void> scheduleWeeklyDeduction(Feed feed) async {
    if (kDebugMode) {
      print('feed-type: ${feed.Type}, feed-itemName: ${feed.itemName}');
    }
    final docSnapshot = await _dbService.infoFromServer(feed.Type, feed.itemName);
    if (docSnapshot.exists) {
      final currentFeed = Feed.fromFireStore(docSnapshot);
      final updatedQuantity = (currentFeed.quantity - (feed.requiredQuantity ?? 10)).clamp(0, currentFeed.quantity);

      await _dbService.infoToServerFeed(Feed(
        itemName: currentFeed.itemName,
        quantity: updatedQuantity,
        Type: feed.Type,
        requiredQuantity: currentFeed.requiredQuantity,
      ));

      if (kDebugMode) {
        print('Weekly consumption deducted of ${feed.itemName} of ${feed.Type}. New quantity: $updatedQuantity');
      }
    }
  }
}
