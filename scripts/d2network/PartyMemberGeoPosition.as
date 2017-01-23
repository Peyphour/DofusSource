package d2network
{
   import utils.ReadOnlyData;
   
   public class PartyMemberGeoPosition extends ReadOnlyData
   {
       
      
      public function PartyMemberGeoPosition(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get memberId() : uint
      {
         return _target.memberId;
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
   }
}
