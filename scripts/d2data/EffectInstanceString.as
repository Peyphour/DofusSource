package d2data
{
   public class EffectInstanceString extends EffectInstance
   {
       
      
      public function EffectInstanceString(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get text() : String
      {
         return _target.text;
      }
   }
}
