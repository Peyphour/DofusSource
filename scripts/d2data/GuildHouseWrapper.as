package d2data
{
   import utils.ReadOnlyData;
   
   public class GuildHouseWrapper extends ReadOnlyData
   {
       
      
      public function GuildHouseWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get houseId() : int
      {
         return _target.houseId;
      }
      
      public function get gfxId() : int
      {
         return _target.gfxId;
      }
      
      public function get houseName() : String
      {
         return _target.houseName;
      }
      
      public function get description() : String
      {
         return _target.description;
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
      
      public function get skillListIds() : Object
      {
         return secure(_target.skillListIds);
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get subareaId() : int
      {
         return _target.subareaId;
      }
      
      public function get guildshareParams() : uint
      {
         return _target.guildshareParams;
      }
   }
}
