import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/site_listing/domain/entities/site_listing_response_entity.dart';
import 'package:try_app/src/features/site_listing/domain/repository/site_listing_repository.dart';

class SitelistingUsecase {
final SiteListingRepository repository;
SitelistingUsecase({required this.repository});

Future<Either <Failure , SiteListEntity>> call () async{
  return repository.getSiteLists();
}

}