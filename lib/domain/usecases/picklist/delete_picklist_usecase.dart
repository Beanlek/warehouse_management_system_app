import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';
import 'package:warehouse/domain/usecases/base_use_case.dart';
import 'package:warehouse/shared_preference/token.dart';

@injectable
class DeletePicklistUsecase {
  final PicklistRepository _picklistRepository;

  DeletePicklistUsecase(this._picklistRepository);

  Future<DeletePicklistResult> execute(DeletePicklistParams params) async {
    bool resetResult = false;
    Exception? error;
    String? errorMessage;

    String token = '';
    await TokenUtil.getToken().then((t) => token = t!);

    await _picklistRepository
        .deletePickList(token, params.toJson())
        .then((result) => result.when(success: (response) async {
              resetResult = true;
              debugPrint('Delete picklist successful');
            }, failure: (networkError) {
              error = networkError;
              errorMessage = networkError.localizedErrorMessage;
            }));

    return DeletePicklistResult(
      exception: error,
      result: resetResult,
      errorMessage: errorMessage,
    );
  }
}

class DeletePicklistResult extends UseCaseResult {
  final String? errorMessage;

  DeletePicklistResult({
    super.exception,
    super.result,
    this.errorMessage,
  });
}

class DeletePicklistParams {
  final String picklistId;

  DeletePicklistParams({
    required this.picklistId,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': picklistId,
  };
}