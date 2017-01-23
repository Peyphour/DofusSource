package d2network
{
   public class GameRolePlayNpcWithQuestInformations extends GameRolePlayNpcInformations
   {
       
      
      public function GameRolePlayNpcWithQuestInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get questFlag() : GameRolePlayNpcQuestFlag
      {
         return secure(_target.questFlag);
      }
   }
}
