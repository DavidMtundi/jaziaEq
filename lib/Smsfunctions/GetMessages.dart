import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:jazia/Smsfunctions/firestoreupload.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';

User? user = FirebaseAuth.instance.currentUser;
var regexpMoney =
    RegExp(r'(["ksh""Ksh""KSh""KSH""USD""KES"]+\.?\ ?[0-9]?\,?[0-9])\d+');

var regexpDate = RegExp(r'([0-9]+\/?\.?[0-9]+\/?\.?[0-9])\w+');

List<String> allowedIds = ["MPESA", "KCB", "FamilyBank"];

///add all banks here to check if the person is currently using any bank
List<String> allBanks = ["KCB", "EQUITY", "FamilyBank"];
List<SmsMessage> alltransactions = [];

List<String> banksConfirmed = [];

String deviceFingerprint = "";

class CheckRegex {
  final SmsQuery _query = SmsQuery();

  SmsMessage correctdata = SmsMessage("_address", "_body");
  DateTime now = DateTime.now();
  double totalvalues = 0;
  //FirestoreQueries firestoreQueries = FirestoreQueries();

  ///returns all messages from the allowed senderids
  Future getallMessages() async {
    alltransactions.clear();
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      for (int i = 0; i < allowedIds.length; i++) {
        final messages = await _query.querySms(
            kinds: [SmsQueryKind.inbox], address: allowedIds[i].toString());
        alltransactions += messages;
      }
    } else {
      await Permission.sms.request();
    }
  }

  /// returns sent if the cash is sent, otherwise returns received
  String getStatus(String s) {
    String status = "received";
    if ((s.contains('sent') || (!s.contains('has'))) ||
        (s.contains('paid')) ||
        (s.contains('debited'))) {
      status = "sent";
    }
    return status;
  }

  ///save them to the firestore database
  Future saveToFirestoreDatabase() async {
    //get all messages
    await getallMessages();
    //check if empty or not then
    if (alltransactions.isNotEmpty) {
      //save to the database
      for (var i = 0; i < alltransactions.length; i++) {
        await FirestoreQueries().updatedSave(
            alltransactions[i].sender.toString(),
            getAmount(alltransactions[i].body.toString()).toString(),
            getStatus(alltransactions[i].body.toString()),
            alltransactions[i].date.toString(),
            user!.uid);
      }
    }
  }

  ///gets the user banks
  Future getUserBanks() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      for (int i = 0; i < allBanks.length; i++) {
        final messages = await _query.querySms(
            kinds: [SmsQueryKind.inbox], address: allBanks[i].toString());
        if (messages.length > 1) {
          banksConfirmed.add(allBanks[i].toString());
        }
      }
    } else {
      await Permission.sms.request();
    }
  }

  ///returns the total amount spend, received and sent in a particular month
  double gettotalamountMonth(int months) {
    totalvalues = 0;
    for (int i = 0; i < alltransactions.length; i++) {
      int days =
          int.parse(now.difference(alltransactions[i].date!).inDays.toString());

      if (days <= (29 * months)) {
        try {
          totalvalues += getAmount(alltransactions[i].body.toString());
        } catch (e) {
          totalvalues += 0;
        }
      }
    }

    return totalvalues;
  }

  ///returns all transactions
  List<SmsMessage> getextractedmessages() {
    // print(alltransactions);
    return alltransactions;
  }

  getsms() async {
    await getallMessages().then((value) {
      //  print(getextractedmessages().length);
      getextractedmessages().forEach((sms) {
        print(getAmount(sms.body.toString()));
      });
    });
  }

  ///receives the string with the date then converts it to a useful date
  String formattheDate(String s) {
    String usefuldate =
        s.toString().replaceAll(RegExp(r'[^\w\s]+'), '.') + " 00:00:000";
    DateTime yourDatetime = Jiffy(usefuldate, "dd.MM.yyyy hh:mm:ss").dateTime;
    return yourDatetime.toString();
  }

  ///returns the amount transacted
  double getAmount(String s) {
    double amounttransacted = 0;
    if ((s.contains('sent')) ||
        (s.contains('received')) ||
        (s.contains('transferred')) ||
        (s.contains('paid'))) {
      if (regexpMoney.hasMatch(s.toString())) {
        var moneymatches =
            regexpMoney.firstMatch(s.toString())!.group(0).toString();
        if (moneymatches.startsWith('ks') ||
            (moneymatches.startsWith('KS') ||
                moneymatches.startsWith('KE') ||
                (moneymatches.startsWith('Ks')))) {
          try {
            amounttransacted = double.parse(
                moneymatches.toString().replaceAll(RegExp(r"\D"), ""));
          } catch (e) {
            amounttransacted = 0;
          }
        }
        if (moneymatches.startsWith("USD")) {
          amounttransacted = double.parse(
                  moneymatches.toString().replaceAll(RegExp(r"\D"), "")) *
              100;
        }
      } else {
        amounttransacted = 0;
      }
    }
    return amounttransacted;
  }
}