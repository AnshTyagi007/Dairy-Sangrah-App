import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/feed.dart';

class DatabaseServicesForFeed {
  final String uid;
  DatabaseServicesForFeed(this.uid);

  FirebaseFirestore db = FirebaseFirestore.instance;

  // Function to add or update feed information in Firestore
  Future<void> infoToServerFeed(Feed feed) async {
    await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(feed.Type) // Feed type (e.g., Paddy, Wheat Straw)
        .collection('Items') // Sub-collection "Items"
        .doc(feed.itemName) // Document representing the item
        .set(feed.toFireStore(), SetOptions(merge: true));
    if (kDebugMode) {
      print('Feed item added or updated: ${feed.itemName}');
    }
  }

  // Function to get a single feed item from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> infoFromServer(String type, String itemName) async {
    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(type) // Feed type (e.g., Paddy, Wheat Straw)
        .collection('Items') // Sub-collection "Items"
        .doc(itemName) // Specific feed item document
        .get();
  }

  // Function to get all feed items for the user from the "Items" sub-collection
  Future<QuerySnapshot<Map<String, dynamic>>> infoFromServerAllFeed(String type) async {
    // Query all items across all feed types
    return await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(type)
        .collection('Items')
        .get(); // Query for all types (Paddy, Wheat Straw, etc.)
  }

  // Function to delete a feed item from Firestore
  Future<void> deleteFeed(String type, String itemName) async {
    await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(type) // Feed type
        .collection('Items') // Sub-collection "Items"
        .doc(itemName) // Specific feed item document
        .delete();
    if (kDebugMode) {
      print('Feed item deleted: $itemName');
    }
  }

  // Function to reduce weekly quantity of a specific feed item
  Future<void> reduceWeeklyQuantity(String type, String itemName) async {
    final feedRef = db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .doc(type) // Feed type
        .collection('Items') // Sub-collection "Items"
        .doc(itemName); // Specific feed item document

    final doc = await feedRef.get();
    if (doc.exists) {
      final feedData = Feed.fromFireStore(doc);
      if (feedData.requiredQuantity != null && feedData.quantity >= feedData.requiredQuantity!) {
        // Calculate the new quantity
        final newQuantity = feedData.quantity - feedData.requiredQuantity!;

        // Update Firestore with the reduced quantity
        await feedRef.update({
          'quantity': newQuantity,
        });

        if (kDebugMode) {
          print('Weekly quantity deducted for $itemName. New quantity: $newQuantity');
        }
      } else {
        if (kDebugMode) {
          print('Insufficient quantity for weekly deduction or no required quantity set.');
        }
      }
    } else {
      if (kDebugMode) {
        print('Feed item not found for weekly deduction.');
      }
    }
  }

  // Function to start the weekly deduction for all feed items
  Future<void> startWeeklyDeductionForAllFeeds() async {
    final querySnapshot = await db
        .collection('User')
        .doc(uid)
        .collection('Feed')
        .get(); // Get all feed types (Paddy, Wheat Straw, etc.)

    // Iterate through all feed types
    for (var feedDoc in querySnapshot.docs) {
      final feedType = feedDoc.id; // Feed type (Paddy, Wheat Straw, etc.)

      final itemQuerySnapshot = await feedDoc.reference.collection('Items').get(); // Get all items for this feed type
      for (var doc in itemQuerySnapshot.docs) {
        final itemName = doc.get('itemName');
        await reduceWeeklyQuantity(feedType, itemName); // Apply weekly deduction
      }
    }
  }
}
