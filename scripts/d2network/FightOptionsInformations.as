package d2network
{
   import utils.ReadOnlyData;
   
   public class FightOptionsInformations extends ReadOnlyData
   {
       
      
      public function FightOptionsInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get isSecret() : Boolean
      {
         return _target.isSecret;
      }
      
      public function get isRestrictedToPartyOnly() : Boolean
      {
         return _target.isRestrictedToPartyOnly;
      }
      
      public function get isClosed() : Boolean
      {
         return _target.isClosed;
      }
      
      public function get isAskingForHelp() : Boolean
      {
         return _target.isAskingForHelp;
      }
   }
}
