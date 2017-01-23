package d2api
{
   public class TimeApi
   {
       
      
      public function TimeApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getTimestamp() : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getUtcTimestamp() : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getClock(param1:Number = 0, param2:Boolean = false, param3:Boolean = false) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getClockNumbers() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getDate(param1:Number = 0, param2:Boolean = false, param3:Boolean = false) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getDofusDate(param1:Number = 0) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getDofusDay(param1:Number = 0) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getDofusMonth(param1:Number = 0) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getDofusYear(param1:Number = 0) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getDurationTimeSinceEpoch(param1:Number = 0) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getDuration(param1:Number, param2:Boolean = false) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getShortDuration(param1:Number, param2:Boolean = false) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getTimezoneOffset() : Number
      {
         return 0;
      }
   }
}
