import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:try_app/src/core/errors/error_handler.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/site_listing/data/models/site_listing_respone_model.dart';

abstract class SiteListingRemoteDatasource {
  Future<Either <Failure , SiteListingResponse>> getSiteLists (); 
}

class SiteListingRemoteDatasourceImpl implements SiteListingRemoteDatasource{

final Dio dio;
SiteListingRemoteDatasourceImpl(this.dio);

@override
Future<Either<Failure, SiteListingResponse>> getSiteLists() async{
  try {
 final response = await dio.get('property/properties/');
   return Right(SiteListingResponse.fromJson(response.data));
  }
  on DioException catch(e){
    return(Left(handleDioError(e)));
  }
  }



}