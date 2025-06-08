import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/model/NBModel.dart';
import 'package:gia_pha_mobile/screen/NBNewsDetailsScreen.dart';
import 'package:gia_pha_mobile/screen/PurchaseMoreScreen.dart';
import 'package:gia_pha_mobile/utils/NBColors.dart';
import 'package:gia_pha_mobile/utils/NBDataProviders.dart';
import 'package:gia_pha_mobile/utils/NBWidgets.dart';

class NBBookmarkScreen extends StatefulWidget {
  static String tag = '/NBBookmarkScreen';

  const NBBookmarkScreen({super.key});

  @override
  NBBookmarkScreenState createState() => NBBookmarkScreenState();
}

class NBBookmarkScreenState extends State<NBBookmarkScreen> {
  List<String> dropDownItems = ['Most Recent', 'Ascending', 'Descending'];
  List<NBNewsDetailsModel> newsList = nbGetNewsDetails();
  List<NBNewsDetailsModel> bookmarkNewsList = [];

  String? dropDownValue = 'Most Recent';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    for (var element in newsList) {
      if (element.isBookmark) {
        bookmarkNewsList.add(element);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nbAppBarWidget(context, title: 'Bookmark'),
      body: bookmarkNewsList.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sort by', style: primaryTextStyle()),
                      DropdownButton(
                        value: dropDownValue,
                        items: List.generate(dropDownItems.length, (index) {
                          return DropdownMenuItem(
                            value: dropDownItems[index],
                            child: Text('${dropDownItems[index]}', style: boldTextStyle()),
                          );
                        }),
                        onChanged: (dynamic value) {
                          setState(() {
                            dropDownValue = value;
                            toasty(context, dropDownValue);
                          });
                        },
                      ),
                    ],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: bookmarkNewsList.length,
                    itemBuilder: (context, index) {
                      NBNewsDetailsModel mData = bookmarkNewsList[index];
                      return Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('${mData.image}', height: 100, fit: BoxFit.fill).cornerRadiusWithClipRRect(16).expand(flex: 1),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${mData.categoryName}', style: boldTextStyle(color: NBPrimaryColor)),
                                Text('${mData.title}', style: boldTextStyle(), softWrap: true, maxLines: 3),
                                8.height,
                                Text('${mData.date}', style: secondaryTextStyle()),
                              ],
                            ).expand(flex: 2),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    height: 10,
                                    value: 'Remove',
                                    child: Text('Remove', style: boldTextStyle()),
                                  ),
                                ];
                              },
                              onSelected: (dynamic value) {
                                setState(() {
                                  if (value == 'Remove') {
                                    mData.isBookmark = !mData.isBookmark;
                                    bookmarkNewsList.remove(mData);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ).onTap(() {
                        PurchaseMoreScreen(true).launch(context);
                      });
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ],
              ).paddingOnly(left: 16, right: 16),
            )
          : Center(
              child: Text('No Data Found', style: boldTextStyle()),
            ),
    );
  }
}
