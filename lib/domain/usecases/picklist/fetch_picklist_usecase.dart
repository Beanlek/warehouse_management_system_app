import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/domain/entities/picklist/picklist_wrapper.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class FetchPickListUseCase {
  final PicklistRepository _picklistRepository;

  FetchPickListUseCase(this._picklistRepository);
  
  Future<Result<PicklistWrapper, AppError>> execute(String? status, int page) async {
    final String? token = await TokenUtil.getToken();
    debugPrint('Fetching site list with token: $token');
    return await _picklistRepository.fetchPickList(token ?? '', status ?? '', page);
  }
}