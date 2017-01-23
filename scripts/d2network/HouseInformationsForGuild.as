package d2network
{
   import utils.ReadOnlyData;
   
   public class HouseInformationsForGuild extends ReadOnlyData
   {
       
      
      public function HouseInformationsForGuild(param1:*, param2:Object)
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
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get skillListIds() : Object
      {
         return secure(_target.skillListIds);
      }
      
      public function get guildshareParams() : uint
      {
         return _target.guildshareParams;
      }
   }
}
