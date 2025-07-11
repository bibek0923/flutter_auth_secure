// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:try_app/src/features/site_listing/domain/entities/site_listing_response_entity.dart';

SiteListingResponse siteListingResponseFromJson(String str) =>
    SiteListingResponse.fromJson(json.decode(str));

// String siteListingResponseToJson(SiteListingResponse data) => json.encode(data);

class SiteListingResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PropertyModel> results;

  SiteListingResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  // factory SiteListingResponse.fromJson(Map<String,dynamic> json ) => SiteListingResponse(count: json["count"], next: json["next"], previous: json["previous"], results: List<PropertyModel>.from(json["results"]).map(x)=>PropertyModel.toJson(x).)));
  factory SiteListingResponse.fromJson(Map<String, dynamic> json) =>
    // print(List<PropertyModel>.from(json["results"]));
     SiteListingResponse(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      // results: List<PropertyModel>.from(json["results"]),
    //  results:  List<PropertyModel>.from(json["results"].map((x) => PropertyModel.fromJson(x)))

    results: List<PropertyModel>.from(json["results"].map((x)=>PropertyModel.fromJson(x))),
    // results:(json["results"].map((x)=>PropertyModel.fromJson(x))).toList() its same as before
    );
  

}

class PropertyModel {
  String id;
  final String? title;
  final String? slug;
  final String? purpose;
  final String?  price;
  final bool? priceNegotiable;
  final String? categoryName;
  final String? typeName;
  final int? bedrooms;
  final int? bathrooms;
  final String? totalArea;
  final String? areaUnit;
  final String? city;
  final String? state;
  final String? mainImage;
  final bool? isFeatured;
  final bool? isVerified;
  final bool? isGharchaiyoVerified;
  final DateTime? datePosted;
  final int? daysSincePosted;
  final String? ownerName;
  final String? ownerType;
  PropertyModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.purpose,
    required this.price,
    required this.priceNegotiable,
    required this.categoryName,
    required this.typeName,
    this.bedrooms,
    required this.bathrooms,
    required this.totalArea,
    required this.areaUnit,
    required this.city,
    required this.state,
    required this.mainImage,
    required this.isFeatured,
    required this.isVerified,
    required this.isGharchaiyoVerified,
    required this.datePosted,
    required this.daysSincePosted,
    required this.ownerName,
    required this.ownerType,
  });
  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    purpose: json["purpose"],
    price: json["price"],
    priceNegotiable: json["price_negotiable"],
    categoryName: json["category_name"],
    typeName: json["type_name"],
    bedrooms: json["bedrooms"],
    bathrooms: json["bathrooms"],
    totalArea: json["total_area"],
    areaUnit: json["area_unit"],
    city: json["city"],
    state: json["state"],
    mainImage: json["main_image"],
    isFeatured: json["is_featured"],
    isVerified: json["is_verified"],
    isGharchaiyoVerified: json["is_gharchaiyo_verified"],
    datePosted: json["datePosted"]!=null? DateTime.tryParse(json["date_posted"]):null,
    daysSincePosted: json["days_since_posted"],
    ownerName: json["owner_name"],
    ownerType: json["owner_type"],
  );
}
// mapper

extension SiteListingResponseMapper on SiteListingResponse{
  SiteListEntity toEntity(){
    return SiteListEntity(count: count, results:results.map((x)=>x.toEntity()).toList());
  }
}
extension PropertyModelMapper on PropertyModel{
  PropertyEntity toEntity(){
    return PropertyEntity(title: title ?? '', price: price??'', city: city ?? '', bedrooms: bedrooms ?? 0, bathrooms: bathrooms?? 0, datePosted: datePosted , isVerified: isVerified, totalArea: totalArea , areaUnit: areaUnit, mainImage: mainImage ?? "https://plus.unsplash.com/premium_photo-1750107641929-18d0023d181c?q=80&w=1159&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D");
  }
}