package d2data
{
   import utils.ReadOnlyData;
   
   public class EffectsListWrapper extends ReadOnlyData
   {
       
      
      public function EffectsListWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
   }
}
