import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection name
  static const String itemsCollection = 'items';

  /// Create a new item in Firestore
  Future<String> createItem(Item item) async {
    try {
      final docRef = await _firestore
          .collection(itemsCollection)
          .add(item.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  /// Get all items from Firestore
  Stream<List<Item>> getAllItems() {
    try {
      return _firestore
          .collection(itemsCollection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id; // Add document ID
              return Item.fromMap(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  /// Get a specific item by ID
  Future<Item?> getItemById(String itemId) async {
    try {
      final doc = await _firestore
          .collection(itemsCollection)
          .doc(itemId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Item.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get item: $e');
    }
  }

  /// Update an existing item
  Future<void> updateItem(String itemId, Item item) async {
    try {
      await _firestore
          .collection(itemsCollection)
          .doc(itemId)
          .update(item.toMap());
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  /// Delete an item
  Future<void> deleteItem(String itemId) async {
    try {
      await _firestore.collection(itemsCollection).doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  /// Get items by category
  Stream<List<Item>> getItemsByCategory(List<ItemCategory> categories) {
    try {
      final categoryNames = categories.map((c) => c.name).toList();

      return _firestore
          .collection(itemsCollection)
          .where('categories', arrayContainsAny: categoryNames)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Item.fromMap(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to get items by category: $e');
    }
  }

  /// Search items by name or description
  Stream<List<Item>> searchItems(String searchTerm) {
    try {
      final searchTermLower = searchTerm.toLowerCase();

      return _firestore
          .collection(itemsCollection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .where((doc) {
                  final data = doc.data();
                  final name = (data['name'] as String).toLowerCase();
                  final description = (data['description'] as String)
                      .toLowerCase();

                  return name.contains(searchTermLower) ||
                      description.contains(searchTermLower);
                })
                .map((doc) {
                  final data = doc.data();
                  data['id'] = doc.id;
                  return Item.fromMap(data);
                })
                .toList();
          });
    } catch (e) {
      throw Exception('Failed to search items: $e');
    }
  }
}
