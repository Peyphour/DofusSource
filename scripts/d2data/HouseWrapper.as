package d2data
{
   import utils.ReadOnlyData;
   
   public class HouseWrapper extends ReadOnlyData
   {
       
      
      public function HouseWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get houseId() : int
      {
         return _target.houseId;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get description() : String
      {
         return _target.description;
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
      
      public function get isOnSale() : Boolean
      {
         return _target.isOnSale;
      }
      
      public function get gfxId() : int
      {
         return _target.gfxId;
      }
      
      public function get defaultPrice() : uint
      {
         return _target.defaultPrice;
      }
      
      public function get guildIdentity() : GuildWrapper
      {
         return secure(_target.guildIdentity);
      }
      
      public function get isSaleLocked() : Boolean
      {
         return _target.isSaleLocked;
      }
   }
}
