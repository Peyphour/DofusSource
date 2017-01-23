package d2network
{
   import utils.ReadOnlyData;
   
   public class AtlasPointsInformations extends ReadOnlyData
   {
       
      
      public function AtlasPointsInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get coords() : Object
      {
         return secure(_target.coords);
      }
   }
}
