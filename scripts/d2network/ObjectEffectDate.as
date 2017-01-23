package d2network
{
   public class ObjectEffectDate extends ObjectEffect
   {
       
      
      public function ObjectEffectDate(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get year() : uint
      {
         return _target.year;
      }
      
      public function get month() : uint
      {
         return _target.month;
      }
      
      public function get day() : uint
      {
         return _target.day;
      }
      
      public function get hour() : uint
      {
         return _target.hour;
      }
      
      public function get minute() : uint
      {
         return _target.minute;
      }
   }
}
