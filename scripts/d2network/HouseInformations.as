package d2network
{
   import utils.ReadOnlyData;
   
   public class HouseInformations extends ReadOnlyData
   {
       
      
      public function HouseInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get houseId() : uint
      {
         return _target.houseId;
      }
      
      public function get doorsOnMap() : Object
      {
         return secure(_target.doorsOnMap);
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
      
      public function get isOnSale() : Boolean
      {
         return _target.isOnSale;
      }
      
      public function get isSaleLocked() : Boolean
      {
         return _target.isSaleLocked;
      }
      
      public function get modelId() : uint
      {
         return _target.modelId;
      }
   }
}
