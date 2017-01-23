package d2data
{
   import utils.ReadOnlyData;
   
   public class CraftsmanWrapper extends ReadOnlyData
   {
       
      
      public function CraftsmanWrapper(param1:*, param2:Object)
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
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get subAreaId() : int
      {
         return _target.subAreaId;
      }
      
      public function get worldPos() : String
      {
         return _target.worldPos;
      }
      
      public function get statusId() : int
      {
         return _target.statusId;
      }
      
      public function get awayMessage() : String
      {
         return _target.awayMessage;
      }
      
      public function get jobId() : int
      {
         return _target.jobId;
      }
      
      public function get jobLevel() : int
      {
         return _target.jobLevel;
      }
      
      public function get minLevelCraft() : int
      {
         return _target.minLevelCraft;
      }
      
      public function get freeCraft() : Boolean
      {
         return _target.freeCraft;
      }
   }
}
