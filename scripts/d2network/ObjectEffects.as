package d2network
{
   import utils.ReadOnlyData;
   
   public class ObjectEffects extends ReadOnlyData
   {
       
      
      public function ObjectEffects(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
   }
}
