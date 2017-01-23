package d2data
{
   import utils.ReadOnlyData;
   
   public class EmblemWrapper extends ReadOnlyData
   {
       
      
      public function EmblemWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get idEmblem() : uint
      {
         return _target.idEmblem;
      }
   }
}
