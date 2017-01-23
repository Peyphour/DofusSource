package d2network
{
   public class ObjectEffectString extends ObjectEffect
   {
       
      
      public function ObjectEffectString(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : String
      {
         return _target.value;
      }
   }
}
