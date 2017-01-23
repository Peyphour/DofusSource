package d2network
{
   public class HumanOptionEmote extends HumanOption
   {
       
      
      public function HumanOptionEmote(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get emoteId() : uint
      {
         return _target.emoteId;
      }
      
      public function get emoteStartTime() : Number
      {
         return _target.emoteStartTime;
      }
   }
}
