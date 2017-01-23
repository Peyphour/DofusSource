package d2data
{
   import utils.ReadOnlyData;
   
   public class Hint extends ReadOnlyData
   {
       
      
      public function Hint(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get gfx() : uint
      {
         return _target.gfx;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
      
      public function get realMapId() : uint
      {
         return _target.realMapId;
      }
      
      public function get x() : int
      {
         return _target.x;
      }
      
      public function get y() : int
      {
         return _target.y;
      }
      
      public function get outdoor() : Boolean
      {
         return _target.outdoor;
      }
      
      public function get subareaId() : int
      {
         return _target.subareaId;
      }
      
      public function get worldMapId() : int
      {
         return _target.worldMapId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
