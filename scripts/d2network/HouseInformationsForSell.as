package d2network
{
   import utils.ReadOnlyData;
   
   public class HouseInformationsForSell extends ReadOnlyData
   {
       
      
      public function HouseInformationsForSell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get modelId() : uint
      {
         return _target.modelId;
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
      
      public function get ownerConnected() : Boolean
      {
         return _target.ownerConnected;
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get nbRoom() : int
      {
         return _target.nbRoom;
      }
      
      public function get nbChest() : int
      {
         return _target.nbChest;
      }
      
      public function get skillListIds() : Object
      {
         return secure(_target.skillListIds);
      }
      
      public function get isLocked() : Boolean
      {
         return _target.isLocked;
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
   }
}
