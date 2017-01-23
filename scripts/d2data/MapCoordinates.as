package d2data
{
   import utils.ReadOnlyData;
   
   public class MapCoordinates extends ReadOnlyData
   {
       
      
      public function MapCoordinates(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get compressedCoords() : uint
      {
         return _target.compressedCoords;
      }
      
      public function get mapIds() : Object
      {
         return secure(_target.mapIds);
      }
   }
}
