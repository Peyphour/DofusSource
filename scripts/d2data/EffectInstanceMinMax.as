package d2data
{
   public class EffectInstanceMinMax extends EffectInstance
   {
       
      
      public function EffectInstanceMinMax(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get min() : uint
      {
         return _target.min;
      }
      
      public function get max() : uint
      {
         return _target.max;
      }
   }
}
