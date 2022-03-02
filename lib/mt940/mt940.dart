class Mt940Conversion {
  String testmt940 =
      """{1:F01BCDCCDKIAXXX0000000000}{2:I940BCDCCDKIXXXXN}{4::20:34824:25:0013000000855917:28C:152/1:60F:C210703USD76242,38:61:2107030703D298,01NTRF434433
  :86:PAIEMENT PENSION ALIMENTAIRE JUIN 2021
  :61:2107030703D4930,NTRF434661
  :86:OV13100675 PAIEMENT FACTURE JA00132021
  :61:2107030703D8334,NTRF434796  
  :86:MAD FAV LUNDA NGANDU ALEX
  :61:2107030703D366,18NTRF435273  
  :86:OV 13100685 PAIEMENT VSR WANGGUODIAN NP HK0290662
  :61:2107030703D6,39NTRF435506 :86:CION D'INTERVNP HK0290662 TFM:
  61:2107030703D5,NTRF435688:86:STATEMENT PRINTING CHARGES    
  :61:2107030703D0,80NTRF435688:86:VAT CHARGE
  :62F:C210703USD62302,:64:C210703USD2832352,54""";

  String getTransactionRefNumber(String message) {
    var first = RegExp(r'(\:+["20"]+\:+([0-9]))\d+');
    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    print("Transaction Reference Number is " + transactionref);

    return transactionref;
  }

  String getAccountIdentification(String message) {
    var first = RegExp(r'(\:+["25"]+\:+([0-9]))\d+');
    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    print("Account Identification Number is " + transactionref);

    return transactionref;
  }

  String getStatementNumberandSequence(String message) {
    var first = RegExp(r'(\:+["28C"]+\:+([0-9])+\/)\d+');
    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    print("Statement Number is " + transactionref);

    return transactionref;
  }

  String getOpeningBalance(String message) {
    var first = RegExp(r'(\:+["60F"]+\:+([A-Za-z0-9])+?,)\w+');
    String type = "debit";
    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);
    if (transactionref.startsWith("C")) {
      type = "Credit";
    }

    print("Opening Balance Number with type $type is " + transactionref);

    return transactionref;
  }

  String getStatementLine(String message) {
    var first = RegExp(r'(\:+["61"]+\:+([A-Za-z0-9])+?,)\w+');

    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    print("Statement Line is " + transactionref);

    return transactionref;
  }

  String getClosingBalance(String message) {
    var first = RegExp(r'(\:+["62F"]+\:+([A-Za-z0-9]))\w+');

    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    String BalanceDate = transactionref.substring(1, 7);
    String CurrencyCode = transactionref.substring(7, 10);
    String FinalClosingBalance = transactionref.substring(10);

    return transactionref;
  }

  String getCurrencyCode(String message) {
    var first = RegExp(r'(\:+["62F"]+\:+([A-Za-z0-9]))\w+');

    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);
    String CurrencyCode = transactionref.substring(7, 10);
    return CurrencyCode;
  }

  String getClosingAvailableBalance(String message) {
    var first = RegExp(r'(\:+["64"]+\:+([A-Za-z0-9])+?,)\w+');

    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    String balancedate = transactionref.substring(1, 7);
    String currencycode = transactionref.substring(7, 10);
    String finalclosingbal = transactionref.substring(10);

    print("Closing Available Balance is " + transactionref);

    return transactionref;
  }

  String getStatementLineNarrative(String message) {
    var first = RegExp(r'(\:+["86"]+\:+.* )\w+');

    String valuegiven = first.firstMatch(message)!.group(0).toString();
    int indexvalue = valuegiven.lastIndexOf(":");
    String transactionref = valuegiven.substring(indexvalue + 1);

    return transactionref;
  }
}
