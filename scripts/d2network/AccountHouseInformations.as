package d2network
{
   import utils.ReadOnlyData;
   
   public class AccountHouseInformations extends ReadOnlyData
   {
       
      
      public function AccountHouseInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get houseId() : uint
      {
         return _target.houseId;
      }
      
      public function get modelId() : uint
      {
         return _target.modelId;
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
   }
}
