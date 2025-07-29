abstract class PicklistRepository {

  Future fetchPickList(String token, String picklistId, String status, int page);
  Future fetchPickListDetails(String token, String picklistId);
  Future deletePickList(String token, Map<String, dynamic> picklistData);
  Future setPicklistSendForPicking(String token, Map<String, dynamic> picklistData);
  Future setPicklistPackAll(String token, Map<String, dynamic> picklistData);
}