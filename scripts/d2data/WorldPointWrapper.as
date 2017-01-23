package d2data
{
   public class WorldPointWrapper extends WorldPoint
   {
       
      
      public function WorldPointWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get outdoorMapId() : uint
      {
         return _target.outdoorMapId;
      }
   }
}
