package d2network
{
   public class PlayerStatusExtended extends PlayerStatus
   {
       
      
      public function PlayerStatusExtended(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get message() : String
      {
         return _target.message;
      }
   }
}
