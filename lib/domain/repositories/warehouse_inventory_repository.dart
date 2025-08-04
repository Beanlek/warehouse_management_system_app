abstract class WarehouseInventoryRepository {
  Future fetchWarehouseInventory(String token, String siteId, String active);

  Future fetchSiteList(String token);
}