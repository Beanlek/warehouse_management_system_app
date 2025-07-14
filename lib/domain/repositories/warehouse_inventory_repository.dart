abstract class WarehouseInventoryRepository {
  Future fetchWarehouseInventory(String token, String siteId);

  Future fetchSiteList(String token);
}