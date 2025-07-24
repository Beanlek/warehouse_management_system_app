abstract class PicklistRepository {

  Future fetchPickList(String token, String status);
  Future fetchPickListDetails(String token, String picklistId);
  Future deletePickList(String token, Map<String, dynamic> picklistData);
  Future setPicklistSendForPicking(String token, Map<String, dynamic> picklistData);
  Future setPicklistPackAll(String token, Map<String, dynamic> picklistData);
}