import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/utils/WAWidgets.dart';

class WAStatisticsComponent extends StatefulWidget {
  static String tag = '/WAStatisticsComponent';

  const WAStatisticsComponent({super.key});

  @override
  WAStatisticsComponentState createState() => WAStatisticsComponentState();
}

class WAStatisticsComponentState extends State<WAStatisticsComponent> {
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
    return Row(
      children: [
        waStatisticsWidget(title: "Income", amount: "\$50,20555", image: 'assets/wa_up_right.png', color: Color(0xFF6C56F9)).expand(),
        16.width,
        waStatisticsWidget(title: "Spent", amount: "\$21,2455", image: 'assets/wa_down_left.png', color: Color(0xFFFF7426)).expand(),
      ],
    ).paddingOnly(left: 16, right: 16);
  }
}
