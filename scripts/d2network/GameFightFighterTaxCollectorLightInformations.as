package d2network
{
   public class GameFightFighterTaxCollectorLightInformations extends GameFightFighterLightInformations
   {
       
      
      public function GameFightFighterTaxCollectorLightInformations(param1:*, param2:Object)
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
   }
}
