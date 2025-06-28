import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/model/WalletAppModel.dart';

class WACategoriesComponent extends StatefulWidget {
  static String tag = '/WACategoriesComponent';

  final WATransactionModel? categoryModel;

  const WACategoriesComponent({super.key, this.categoryModel});

  @override
  WACategoriesComponentState createState() => WACategoriesComponentState();
}

class WACategoriesComponentState extends State<WACategoriesComponent> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: boxDecorationRoundedWithShadow(16, backgroundColor: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: widget.categoryModel!.color!.withOpacity(0.1)),
                child: ImageIcon(AssetImage(widget.categoryModel!.image!), size: 24, color: widget.categoryModel!.color!),
              ),
              SizedBox(width: 10),
              Text(widget.categoryModel!.title!, style: boldTextStyle()),
            ]
          ),
          Container(
            width: 80,
            height: 35,
            alignment: Alignment.center,
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.circular(30),
              backgroundColor: widget.categoryModel!.color!.withOpacity(0.1),
            ),
            child: Text(widget.categoryModel!.balance!, maxLines: 1, style: boldTextStyle(size: 12, color: widget.categoryModel!.color!)),
          ),
        ]
      ),
    );
  }
}
