package d2network
{
   public class GameFightTaxCollectorInformations extends GameFightAIInformations
   {
       
      
      public function GameFightTaxCollectorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get firstNameId() : uint
      {
         return _target.firstNameId;
      }
      
      public function get lastNameId() : uint
      {
         return _target.lastNameId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
