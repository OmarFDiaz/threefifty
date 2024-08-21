import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData({required String collection, required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateData({required String collection, required String docId, required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteData({required String collection, required String docId}) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getData({required String collection}) {
    return _firestore.collection(collection).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({required String collection, required String docId}) async {
    return await _firestore.collection(collection).doc(docId).get();
  }
}
