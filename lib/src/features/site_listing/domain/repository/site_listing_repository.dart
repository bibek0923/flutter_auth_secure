import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/site_listing/domain/entities/site_listing_response_entity.dart';

abstract class SiteListingRepository {
 Future<Either<Failure , SiteListEntity>> getSiteLists (); 
} 