package d2network
{
   public class PaddockAbandonnedInformations extends PaddockBuyableInformations
   {
       
      
      public function PaddockAbandonnedInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildId() : int
      {
         return _target.guildId;
      }
   }
}
