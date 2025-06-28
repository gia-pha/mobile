import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/WAStatisticsScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/component/WACategoriesComponent.dart';
import 'package:gia_pha_mobile/model/WalletAppModel.dart';
import 'package:gia_pha_mobile/utils/WADataGenerator.dart';

class WACategoriesScreen extends StatefulWidget {
  static String tag = '/WACategoriesScreen';

  const WACategoriesScreen({super.key});

  @override
  WACategoriesScreenState createState() => WACategoriesScreenState();
}

class WACategoriesScreenState extends State<WACategoriesScreen> {
  List<WATransactionModel> categoriesList = waCategoriesList();

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
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/wa_bg.jpg'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoriesList.length,
              itemBuilder: (context, i) {
                return WACategoriesComponent(categoryModel: categoriesList[i]).onTap(() => WAStatisticsScreen().launch(
                    context,
                    pageRouteAnimation: PageRouteAnimation.Slide,
                  )
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
