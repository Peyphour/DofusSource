package d2network
{
   import utils.ReadOnlyData;
   
   public class JobCrafterDirectoryEntryPlayerInfo extends ReadOnlyData
   {
       
      
      public function JobCrafterDirectoryEntryPlayerInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get playerName() : String
      {
         return _target.playerName;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get isInWorkshop() : Boolean
      {
         return _target.isInWorkshop;
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
      
      public function get status() : PlayerStatus
      {
         return secure(_target.status);
      }
   }
}
