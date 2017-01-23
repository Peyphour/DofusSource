package d2network
{
   public class ObjectEffectInteger extends ObjectEffect
   {
       
      
      public function ObjectEffectInteger(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : uint
      {
         return _target.value;
      }
   }
}
