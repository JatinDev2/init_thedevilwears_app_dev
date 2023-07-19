class ListModel{
  String listingType;
  String toStyleName;
  String instaHandle;
  String eventCategory;
  String eventDate;
  String productDate;
  String location;
  List<String> tags;
  String requirement;
  List images;

  ListModel({
   required this.images,
   required this.listingType,
   required this.location,
   required this.eventCategory,
   required this.eventDate,
   required this.instaHandle,
   required this.productDate,
   required this.requirement,
   required this.tags,
   required this.toStyleName,
});
}