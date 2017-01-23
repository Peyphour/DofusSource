package d2network
{
   public class GameFightMonsterInformations extends GameFightAIInformations
   {
       
      
      public function GameFightMonsterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get creatureGenericId() : uint
      {
         return _target.creatureGenericId;
      }
      
      public function get creatureGrade() : uint
      {
         return _target.creatureGrade;
      }
   }
}
