import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';
import 'package:warehouse/domain/usecases/base_use_case.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class SetPicklistPackAllUsecase {
  final PicklistRepository _picklistRepository;

  SetPicklistPackAllUsecase(this._picklistRepository);

  Future<SetPicklistPackAllResult> execute(SetPicklistPackAllParams params) async {
    bool resetResult = false;
    Exception? error;
    String? errorMessage;
    
    String token = '';
    await TokenUtil.getToken().then((t) => token = t!);

    await _picklistRepository
        .setPicklistPackAll(token, params.toJson())
        .then((result) => result.when(success: (response) async {
              resetResult = true;
              debugPrint('Set picklist to pack all successful');
            }, failure: (networkError) {
              error = networkError;
              errorMessage = networkError.localizedErrorMessage;
            }));

    return SetPicklistPackAllResult(
      exception: error,
      result: resetResult,
      errorMessage: errorMessage,
    );
  }
}

class SetPicklistPackAllResult extends UseCaseResult {
  final String? errorMessage;

  SetPicklistPackAllResult({
    super.exception,
    super.result,
    this.errorMessage,
  });
}

class SetPicklistPackAllParams {
  final String picklistId;

  SetPicklistPackAllParams({
    required this.picklistId,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': picklistId,
  };
}