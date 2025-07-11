import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:try_app/src/features/site_listing/domain/entities/site_listing_response_entity.dart';
import 'package:try_app/src/features/site_listing/domain/usecases/siteListingUsecase.dart';

part 'site_listing_state.dart';

class SiteListingCubit extends Cubit<SiteListingState> {
  final SitelistingUsecase usecase;

  SiteListingCubit(this.usecase) : super(SiteListingInitial());

  Future<void> getSiteListing () async{
try {
      emit(SiteListingLoading());
      final result = await usecase.call();
      result.fold(
        (failure) => emit(SiteListingFailure(errorMessage: failure.message)),
        (data) => emit(SiteListingSuccessfullyFetched(data)),
      );
    } catch (e) {
      emit(SiteListingFailure(errorMessage: "Unexpected error: ${e.toString()}"));
    }
  }
}
