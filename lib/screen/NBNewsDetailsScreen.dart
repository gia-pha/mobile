import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/model/NBModel.dart';
import 'package:gia_pha_mobile/screen/PurchaseMoreScreen.dart';
import 'package:gia_pha_mobile/utils/NBColors.dart';
import 'package:gia_pha_mobile/utils/NBImages.dart';
import 'package:gia_pha_mobile/utils/NBWidgets.dart';
import 'package:gia_pha_mobile/utils/NBAppWidget.dart';


class NBNewsDetailsScreen extends StatefulWidget {
  static String tag = '/NBNewsDetailsScreen';

  final NBNewsDetailsModel? newsDetails;

  const NBNewsDetailsScreen({super.key, this.newsDetails});

  @override
  NBNewsDetailsScreenState createState() => NBNewsDetailsScreenState();
}

class NBNewsDetailsScreenState extends State<NBNewsDetailsScreen> {
  bool isFollowing = false;

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black),
            onPressed: () {
              finish(context);
            }),
        elevation: 0,
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.newsDetails!.categoryName}', style: boldTextStyle(color: NBPrimaryColor)),
            Row(
              children: [
                Text('${widget.newsDetails!.title}', style: boldTextStyle(size: 20)).expand(flex: 3),
                widget.newsDetails!.isBookmark
                    ? IconButton(
                        icon: Icon(Icons.bookmark),
                        onPressed: () {
                          setState(() {
                            widget.newsDetails!.isBookmark = !widget.newsDetails!.isBookmark;
                          });
                          toasty(context, 'Removed from Bookmark');
                        })
                    : IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {
                          setState(() {
                            widget.newsDetails!.isBookmark = !widget.newsDetails!.isBookmark;
                          });
                          toasty(context, 'Added to Bookmark');
                        }),
              ],
            ),
            16.height,
            commonCacheImageWidget(widget.newsDetails!.image, 200, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(16),
            16.height,
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                'by Jones Hawkins',
                style: boldTextStyle(),
              ),
              subtitle: Text('12 jan 2021', style: secondaryTextStyle()),
              leading: CircleAvatar(
                backgroundImage: AssetImage(NBProfileImage),
              ),
              trailing: AppButton(
                elevation: 0,
                text: isFollowing ? 'Following' : 'Follow',
                onTap: () {
                  setState(() {
                    isFollowing = !isFollowing;
                  });
                },
                color: isFollowing ? grey.withOpacity(0.2) : black,
                textColor: isFollowing ? grey : white,
              ).cornerRadiusWithClipRRect(30),
            ),
            16.height,
            Text('${widget.newsDetails!.details}', style: primaryTextStyle(), textAlign: TextAlign.justify),
            16.height,
            nbAppButtonWidget(context, 'Comment', () {
              PurchaseMoreScreen(true).launch(context);
            }),
            16.height,
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
    );
  }
}
