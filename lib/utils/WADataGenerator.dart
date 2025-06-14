import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/model/WalletAppModel.dart';

List<String?> waMonthList = <String?>["Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"];
List<String?> waYearList = <String?>["1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2020", "2021"];
List<String?> waOrgList = <String?>["All", "Water", "Gas", "Electricity", "Internet", "Education", "Landline"];
List<String?> amountList = ["500", "1000", "800"];
List<String?> overViewList = ["All", "Weekly", "Yearly", "Daily", "Monthly"];


List<WATransactionModel> waTransactionList() {
  List<WATransactionModel> transactionList = [];
  transactionList.add(WATransactionModel(
    color: Color(0xFFFF7426),
    title: 'Send Money to',
    image: 'assets/wa_bill_pay.png',
    balance: '-\$20,000',
    name: 'James',
    time: 'Today 5:30 PM',
  ));
  transactionList.add(WATransactionModel(
    color: Color(0xFF26C884),
    title: 'Salary from',
    image: 'assets/wa_voucher.png',
    balance: '+\$50,000',
    name: 'Unbox Digital',
    time: 'Today 6:30 PM',
  ));
  return transactionList;
}

List<WATransactionModel> waCategoriesList() {
  List<WATransactionModel> list = [];
  list.add(WATransactionModel(color: Color(0xFF26C884), title: 'Clothes', image: 'assets/wa_clothes.png', balance: '-\$10,000', time: 'Today 12:30 PM'));
  list.add(WATransactionModel(color: Color(0xFFFF7426), title: 'Grocery', image: 'assets/wa_food.png', balance: '-\$8,000', time: 'Today 1:02 PM'));
  return list;
}
