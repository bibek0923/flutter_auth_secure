part of 'site_listing_cubit.dart';

@immutable
sealed class SiteListingState {}
sealed class SiteListingActionState{}
final class SiteListingInitial extends SiteListingState {

}
class SiteListingLoading extends SiteListingState{ }

class SiteListingSuccessfullyFetched extends SiteListingState{
final SiteListEntity siteListEntity;

SiteListingSuccessfullyFetched(this.siteListEntity){print("i am here");}
 }
class SiteListingFailure extends SiteListingState{
  final String errorMessage;

  SiteListingFailure({required this.errorMessage});
}