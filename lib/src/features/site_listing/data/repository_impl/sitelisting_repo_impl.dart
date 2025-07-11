import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/site_listing/data/models/site_listing_respone_model.dart';
import 'package:try_app/src/features/site_listing/data/site_listing_remote_datasource/site_listing_datasource.dart';
import 'package:try_app/src/features/site_listing/domain/entities/site_listing_response_entity.dart';
import 'package:try_app/src/features/site_listing/domain/repository/site_listing_repository.dart';

class SiteListingRepositoryImpl implements SiteListingRepository{
  final SiteListingRemoteDatasource  siteListingRemoteDatasource;

  SiteListingRepositoryImpl({required this.siteListingRemoteDatasource});
@override  
 Future<Either<Failure , SiteListEntity>> getSiteLists () async{
  final response = await siteListingRemoteDatasource.getSiteLists();
 return  response.fold(

    (failure) => Left((failure)),
    (siteListingResponse) => Right(siteListingResponse.toEntity())
  );
 } 
}