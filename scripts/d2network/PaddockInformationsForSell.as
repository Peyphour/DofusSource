package d2network
{
   import utils.ReadOnlyData;
   
   public class PaddockInformationsForSell extends ReadOnlyData
   {
       
      
      public function PaddockInformationsForSell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildOwner() : String
      {
         return _target.guildOwner;
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
      
      public function get nbMount() : int
      {
         return _target.nbMount;
      }
      
      public function get nbObject() : int
      {
         return _target.nbObject;
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
   }
}
