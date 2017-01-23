package d2data
{
   public class EffectInstanceInteger extends EffectInstance
   {
       
      
      public function EffectInstanceInteger(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
