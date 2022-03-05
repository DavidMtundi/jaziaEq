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
        .doc(date.substring(0, 10))
        .update({
      'amount': FieldValue.arrayUnion([amount]),
      'date': date.substring(0, 10)
    });
  }

  ///msg type is the
  Future savecustomMessages( List<SmsMessage> transactions,
  String id) async {
    for (int i = 0; i < transactions.length; i++) {
     if(CheckRegex(). getAmount(transactions[i].body.toString())!=0.0){ try {
        final savemessages =
            FirebaseFirestore.instance.collection("users").doc(id);
      await  savemessages
            .collection("transactions")
            .doc( transactions[i].sender.toString(),
)
            .collection(CheckRegex().getStatus(transactions[i].body.toString()))
            .doc(transactions[i].date.toString().substring(0,10))
            .set({
              'uid':id,
              'date':transactions[i].date.toString().substring(0,10),
          'amount': FieldValue.arrayUnion([CheckRegex(). getAmount(transactions[i].body.toString())]),
        },SetOptions(merge:true));
      } catch (e) {
        print(e.toString());
      }}
    }
  }
}
