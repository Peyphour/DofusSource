package d2data
{
   import utils.ReadOnlyData;
   
   public class Dungeon extends ReadOnlyData
   {
       
      
      public function Dungeon(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get optimalPlayerLevel() : int
      {
         return _target.optimalPlayerLevel;
      }
      
      public function get mapIds() : Object
      {
         return secure(_target.mapIds);
      }
      
      public function get entranceMapId() : int
      {
         return _target.entranceMapId;
      }
      
      public function get exitMapId() : int
      {
         return _target.exitMapId;
      }
   }
}
