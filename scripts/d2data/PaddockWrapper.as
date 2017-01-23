package d2data
{
   import utils.ReadOnlyData;
   
   public class PaddockWrapper extends ReadOnlyData
   {
       
      
      public function PaddockWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get maxOutdoorMount() : uint
      {
         return _target.maxOutdoorMount;
      }
      
      public function get maxItems() : uint
      {
         return _target.maxItems;
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
      
      public function get guildId() : int
      {
         return _target.guildId;
      }
      
      public function get guildIdentity() : GuildWrapper
      {
         return secure(_target.guildIdentity);
      }
      
      public function get isSaleLocked() : Boolean
      {
         return _target.isSaleLocked;
      }
      
      public function get isAbandonned() : Boolean
      {
         return _target.isAbandonned;
      }
   }
}
