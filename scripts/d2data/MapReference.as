package d2data
{
   import utils.ReadOnlyData;
   
   public class MapReference extends ReadOnlyData
   {
       
      
      public function MapReference(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
      
      public function get cellId() : int
      {
         return _target.cellId;
      }
   }
}
