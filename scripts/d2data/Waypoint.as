package d2data
{
   import utils.ReadOnlyData;
   
   public class Waypoint extends ReadOnlyData
   {
       
      
      public function Waypoint(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
   }
}
