package d2data
{
   import utils.ReadOnlyData;
   
   public class MapScrollAction extends ReadOnlyData
   {
       
      
      public function MapScrollAction(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get rightExists() : Boolean
      {
         return _target.rightExists;
      }
      
      public function get bottomExists() : Boolean
      {
         return _target.bottomExists;
      }
      
      public function get leftExists() : Boolean
      {
         return _target.leftExists;
      }
      
      public function get topExists() : Boolean
      {
         return _target.topExists;
      }
      
      public function get rightMapId() : int
      {
         return _target.rightMapId;
      }
      
      public function get bottomMapId() : int
      {
         return _target.bottomMapId;
      }
      
      public function get leftMapId() : int
      {
         return _target.leftMapId;
      }
      
      public function get topMapId() : int
      {
         return _target.topMapId;
      }
   }
}
