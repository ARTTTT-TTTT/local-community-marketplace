import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class TestDataService {
  static Future<void> addSampleDataToFirebase() async {
    final firestore = FirebaseFirestore.instance;

    // Sample items to add to Firebase
    final sampleItems = [
      Item(
        name: 'iPhone 15 Pro Max',
        description: 'มือสองสภาพดี ใช้งานได้ปกติ มีกล่อง',
        price: 35000,
        imageUrls: ['https://firebasestorage.googleapis.com/placeholder.jpg'],
        categories: [ItemCategory.electronics],
        condition: ItemCondition.secondHandGood,
        sellerType: SellerType.individual,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sellerName: 'นายสมชาย ใจดี',
        location: 'เทศบาลนครหาดใหญ่',
        isActive: true,
      ),
      Item(
        name: 'MacBook Air M2',
        description: 'แล็ปท็อปสำหรับนักศึกษา สภาพเหมือนใหม่',
        price: 45000,
        imageUrls: ['https://firebasestorage.googleapis.com/placeholder2.jpg'],
        categories: [ItemCategory.electronics],
        condition: ItemCondition.secondHandLikeNew,
        sellerType: SellerType.individual,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sellerName: 'ร้าน TechStore',
        location: 'หาดใหญ่',
        isActive: true,
      ),
      Item(
        name: 'เสื้อผ้าแฟชั่น',
        description: 'เสื้อยืดคุณภาพดี ใส่สบาย',
        price: 250,
        imageUrls: ['https://firebasestorage.googleapis.com/placeholder3.jpg'],
        categories: [ItemCategory.menClothing],
        sellerType: SellerType.business,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sellerName: 'Fashion Hub',
        location: 'หาดใหญ่',
        isActive: true,
      ),
      Item(
        name: 'โซฟาหนังแท้',
        description: 'โซฟาหนังแท้ 3 ที่นั่ง สภาพดี',
        price: 8500,
        imageUrls: ['https://firebasestorage.googleapis.com/placeholder4.jpg'],
        categories: [ItemCategory.furniture],
        condition: ItemCondition.secondHandGood,
        sellerType: SellerType.individual,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sellerName: 'คุณมาลี',
        location: 'สงขลา',
        isActive: true,
      ),
    ];

    try {
      for (var item in sampleItems) {
        await firestore.collection('items').add(item.toMap());
        print('Added item: ${item.name}');
      }
      print('✅ Sample data added successfully!');
    } catch (e) {
      print('❌ Error adding sample data: $e');
    }
  }

  static Future<void> clearAllItems() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('items')
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print('✅ All items cleared successfully!');
    } catch (e) {
      print('❌ Error clearing items: $e');
    }
  }
}
