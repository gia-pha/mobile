import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/component/WATransactionComponent.dart';
import 'package:gia_pha_mobile/component/WAStatisticsChartComponent.dart';
import 'package:gia_pha_mobile/component/WAStatisticsComponent.dart';
import 'package:gia_pha_mobile/model/WalletAppModel.dart';
import 'package:gia_pha_mobile/utils/WADataGenerator.dart';
import 'package:gia_pha_mobile/utils/WAWidgets.dart';

class WAStatisticsScreen extends StatefulWidget {
  static String tag = '/WAStatisticScreen';

  const WAStatisticsScreen({super.key});

  @override
  WAStatisticsScreenState createState() => WAStatisticsScreenState();
}

class WAStatisticsScreenState extends State<WAStatisticsScreen> {
  List<WATransactionModel> transactionList = waTransactionList();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Statistics', style: boldTextStyle(color: Colors.black, size: 20)),
          centerTitle: true,
          elevation: 0.0, systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/wa_bg.jpg'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WAStatisticsComponent(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Overview', style: boldTextStyle(size: 20)),
                    16.height,
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: DropdownButtonFormField(
                        value: overViewList[0],
                        isExpanded: true,
                        decoration: waInputDecoration(bgColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 8)),
                        items: overViewList.map((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!, style: boldTextStyle(size: 14)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),
                  ],
                ).paddingOnly(left: 16, right: 16, top: 16),
                WAStatisticsChartComponent(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transactions', style: boldTextStyle(size: 20)),
                    Icon(Icons.play_arrow, color: Colors.grey),
                  ],
                ).paddingOnly(left: 16, right: 16),
                16.height,
                Column(
                  children: transactionList.map((transactionItem) {
                      return WATransactionComponent(transactionModel: transactionItem);
                    }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
