package d2network
{
   import utils.ReadOnlyData;
   
   public class HouseInformationsInside extends ReadOnlyData
   {
       
      
      public function HouseInformationsInside(param1:*, param2:Object)
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
      
      public function get ownerId() : int
      {
         return _target.ownerId;
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
      
      public function get isLocked() : Boolean
      {
         return _target.isLocked;
      }
   }
}
