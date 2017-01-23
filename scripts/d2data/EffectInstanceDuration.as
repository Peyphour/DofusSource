package d2data
{
   public class EffectInstanceDuration extends EffectInstance
   {
       
      
      public function EffectInstanceDuration(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get days() : uint
      {
         return _target.days;
      }
      
      public function get hours() : uint
      {
         return _target.hours;
      }
      
      public function get minutes() : uint
      {
         return _target.minutes;
      }
   }
}
