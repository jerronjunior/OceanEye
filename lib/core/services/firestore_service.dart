import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Generic method to add a document
  Future<String> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      final docRef = await _db.collection(collectionPath).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add document: $e');
    }
  }

  // Generic method to set a document with a specific ID
  Future<void> setDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(docId).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  // Generic method to get a document
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) async {
    try {
      return await _db.collection(collectionPath).doc(docId).get();
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  // Generic method to update a document
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Generic method to delete a document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _db.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Generic method to get a collection stream
  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }
}
