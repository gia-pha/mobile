class NBNewsDetailsModel {
  String? categoryName;
  String? title;
  String? date;
  String? image;
  String? details;
  bool isBookmark;
  String? time;

  NBNewsDetailsModel({this.categoryName, this.title, this.date, this.image, this.details, this.isBookmark = false, this.time});
}

class NBLanguageItemModel {
  String image;
  String name;

  NBLanguageItemModel(this.image, this.name);
}

class NBMembershipPlanItemModel {
  String timePeriod;
  String price;
  String text;

  NBMembershipPlanItemModel(this.timePeriod, this.price, this.text);
}
