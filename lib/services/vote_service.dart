import 'package:cloud_firestore/cloud_firestore.dart';
import 'vote_stream.dart';

class VoteService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<bool> submitVote(String movie) async {
    try {
      // Tambah vote di Firestore secara transaction agar aman
      final docRef = _firestore.collection('votes').doc(movie);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final currentCount = snapshot.exists ? snapshot['count'] as int : 0;
        transaction.set(docRef, {'count': currentCount + 1});
      });

      // Update local stream supaya chart realtime
      VoteStream.addVote(movie);

      return true;
    } catch (e) {
      print('Vote error: $e');
      return false;
    }
  }
}
