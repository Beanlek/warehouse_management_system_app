import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class FetchPickListDetailsUseCase {
  final PicklistRepository _picklistRepository;

  FetchPickListDetailsUseCase(this._picklistRepository);
  
  Future<Result<PicklistDetails, AppError>> execute(String picklistId) async {
    final String? token = await TokenUtil.getToken();
    
    return await _picklistRepository.fetchPickListDetails(token ?? '', picklistId);
  }
}