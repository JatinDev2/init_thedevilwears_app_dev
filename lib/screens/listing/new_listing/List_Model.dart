class ListModel{
  String listingType;
  String toStyleName;
  String instaHandle;
  String eventCategory;
  String eventDate;
  String productDate;
  String location;
  List<dynamic>? tags;
  String requirement;
  List? images;
  String? userId;
  String? timeStamp;
  Map<String, dynamic>? selectedTags;
  String? createdBy;

  ListModel({
    this.images,
   required this.listingType,
   required this.location,
   required this.eventCategory,
   required this.eventDate,
   required this.instaHandle,
   required this.productDate,
   required this.requirement,
    this.tags,
   required this.toStyleName,
    this.userId,
    this.timeStamp,
    this.selectedTags,
    this.createdBy,
});
}