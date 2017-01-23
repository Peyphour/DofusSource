package d2data
{
   import utils.ReadOnlyData;
   
   public class TeleportDestinationWrapper extends ReadOnlyData
   {
       
      
      public function TeleportDestinationWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get teleporterType() : uint
      {
         return _target.teleporterType;
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
      
      public function get subArea() : SubArea
      {
         return secure(_target.subArea);
      }
      
      public function get destinationType() : uint
      {
         return _target.destinationType;
      }
      
      public function get cost() : uint
      {
         return _target.cost;
      }
      
      public function get spawn() : Boolean
      {
         return _target.spawn;
      }
      
      public function get known() : Boolean
      {
         return _target.known;
      }
      
      public function get subAreaNameId() : uint
      {
         return _target.subAreaNameId;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get hintName() : String
      {
         return _target.hintName;
      }
      
      public function get coord() : String
      {
         return _target.coord;
      }
      
      public function get hintMapId() : uint
      {
         return _target.hintMapId;
      }
      
      public function get category() : int
      {
         return _target.category;
      }
   }
}
