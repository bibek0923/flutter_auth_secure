class SiteListEntity {
final int count;
  
  final List<PropertyEntity> results;

  SiteListEntity({
    required this.count,
    required this.results,
  });
}
class PropertyEntity {
final String title ;
final  String price;
final String city;
final int bedrooms;
final int bathrooms;
final DateTime? datePosted ;
final bool? isVerified;
final String? totalArea;
final String? areaUnit;
final String mainImage;

  PropertyEntity({required this.title, required this.price, required this.city, required this.bedrooms, required this.bathrooms, required this.datePosted, required this.isVerified, required this.totalArea, required this.areaUnit, required this.mainImage});
}