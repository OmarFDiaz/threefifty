import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logWorkSession(
      {required String userId,
      required DateTime startTime,
      required DateTime endTime,
      required DateTime breakstart,
      required DateTime breakend}) async {
    try {
      final int workDuration = endTime.difference(startTime).inSeconds;
      final int breakDuration = breakend.difference(breakstart).inSeconds;

      // Reference the subcollection 'workSessions' inside the user's document
      CollectionReference workSessions =
          _firestore.collection('users').doc(userId).collection('workSessions');

      // Add a new work session
      await workSessions.add({
        'day':
            '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}',
        'startTime': Timestamp.fromDate(startTime),
        'breakTimeStart': Timestamp.fromDate(endTime),
        'breakTimeEnd': Timestamp.fromDate(endTime),
        'endTime': Timestamp.fromDate(endTime),
        'workduration': workDuration, // Store duration in seconds
        'breakduration': breakDuration // Store duration in seconds
      });

      print("Work session logged successfully!");
    } catch (e) {
      print("Error logging work session: $e");
    }
  }

  Future<void> StartDay(
      {required String userId, required DateTime startTime}) async {
    try {
      // Reference the subcollection 'workSessions' inside the user's document

      final workSessions = _firestore
          .collection('users')
          .doc(userId)
          .collection('workSessions')
          .doc(
              '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}');

      // Add a new work session
      await workSessions.set({
        'startTime': Timestamp.fromDate(startTime),
      });

      print("Work session logged successfully!");
    } catch (e) {
      print("Error logging work session: $e");
    }
  }

  Future<void> StartBreak(
      {required String userId, required DateTime breakTimeStart}) async {
    try {
      // Reference the subcollection 'workSessions' inside the user's document
      final workSessions = _firestore
          .collection('users')
          .doc(userId)
          .collection('workSessions')
          .doc(
              '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}');

      // Add a new work session
      await workSessions.update({
        'breakTimeStart': Timestamp.fromDate(breakTimeStart),
      });

      print("Work session logged successfully!");
    } catch (e) {
      print("Error logging work session: $e");
    }
  }

  Future<void> EndBreak(
      {required String userId, required DateTime breakTimeEnd}) async {
    try {
      // Reference the subcollection 'workSessions' inside the user's document
      CollectionReference workSessions = _firestore
          .collection('users')
          .doc(userId)
          .collection(
              '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}');

      // Add a new work session
      await workSessions.add({
        'breakTimeEnd': Timestamp.fromDate(breakTimeEnd),
      });

      print("Work session logged successfully!");
    } catch (e) {
      print("Error logging work session: $e");
    }
  }

  Future<void> EndDay(
      {required String userId, required DateTime Endtime}) async {
    try {
      // Reference the subcollection 'workSessions' inside the user's document
      final workSessions = _firestore
          .collection('users')
          .doc(userId)
          .collection('workSessions')
          .doc(
              '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}');

      // Add a new work session
      await workSessions.update({
        'endTime': Timestamp.fromDate(Endtime),
      });


      print("Work session logged successfully!");
    } catch (e) {
      print("Error logging work session: $e");
    }
  }
}
