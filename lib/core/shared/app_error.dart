
abstract class AppError implements Exception{
  AppError(String s);

  String? get localizedErrorMessage;
}