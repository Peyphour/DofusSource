package d2data
{
   import utils.ReadOnlyData;
   
   public class Area extends ReadOnlyData
   {
       
      
      public function Area(param1:*, param2:Object)
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
      
      public function get superAreaId() : int
      {
         return _target.superAreaId;
      }
      
      public function get containHouses() : Boolean
      {
         return _target.containHouses;
      }
      
      public function get containPaddocks() : Boolean
      {
         return _target.containPaddocks;
      }
      
      public function get bounds() : Object
      {
         return secure(_target.bounds);
      }
      
      public function get worldmapId() : uint
      {
         return _target.worldmapId;
      }
      
      public function get hasWorldMap() : Boolean
      {
         return _target.hasWorldMap;
      }
   }
}
