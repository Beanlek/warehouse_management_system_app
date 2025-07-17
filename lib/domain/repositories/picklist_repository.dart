abstract class PicklistRepository {

  Future fetchPickList(String token, String status);
  Future fetchPickListDetails(String token, String picklistId);
}