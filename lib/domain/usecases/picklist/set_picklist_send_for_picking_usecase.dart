import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';
import 'package:warehouse/domain/usecases/base_use_case.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class SetPicklistSendForPickingUsecase {
  final PicklistRepository _picklistRepository;

  SetPicklistSendForPickingUsecase(this._picklistRepository);

  Future<SetPicklistSendForPickingResult> execute(SetPicklistSendForPickingParams params) async {
    bool resetResult = false;
    Exception? error;
    String? errorMessage;

    String token = '';
    await TokenUtil.getToken().then((t) => token = t!);

    await _picklistRepository
        .setPicklistSendForPicking(token, params.toJson())
        .then((result) => result.when(success: (response) async {
              resetResult = true;
              debugPrint('Set picklist to send for packing successful');
            }, failure: (networkError) {
              error = networkError;
              errorMessage = networkError.localizedErrorMessage;
            }));

    return SetPicklistSendForPickingResult(
      exception: error,
      result: resetResult,
      errorMessage: errorMessage,
    );
  }
}

class SetPicklistSendForPickingResult extends UseCaseResult {
  final String? errorMessage;

  SetPicklistSendForPickingResult({
    super.exception,
    super.result,
    this.errorMessage,
  });
}

class SetPicklistSendForPickingParams {
  final String picklistId;

  SetPicklistSendForPickingParams({
    required this.picklistId,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': picklistId,
  };
}