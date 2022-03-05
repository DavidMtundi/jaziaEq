import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:jazia/Smsfunctions/GetMessages.dart';

class FirestoreQueries {
  CheckRegex checkRegex = CheckRegex();
  //String fingerprintid="";

  Future updatedSave(String msgtype, String amount, String status, String date,
      String id) async {
    final savemessages = FirebaseFirestore.instance.collection("users").doc(id);
    await savemessages
        .collection("transactions")
        .doc(msgtype)
        .collection(status)
        .doc(date.substring(0, 9))
        .update({
      'amount': FieldValue.arrayUnion([amount]),
      'date': date.substring(0, 9)
    });
  }

  ///msg type is the
  Future savecustomMessages(String msgtype, List<SmsMessage> transactions,
      String status, String id) async {
    for (int i = 0; i < transactions.length; i++) {
      try {
        final amount = checkRegex.getAmount(transactions[i].body.toString());
        final savemessages =
            FirebaseFirestore.instance.collection("users").doc(id);
        savemessages
            .collection("transactions")
            .doc(msgtype)
            .collection(status)
            .doc(transactions[i].date.toString())
            .set({
          'amount': FieldValue.arrayUnion([amount]),
        },SetOptions(merge:true));
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
