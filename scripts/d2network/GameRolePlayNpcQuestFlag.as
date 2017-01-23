package d2network
{
   import utils.ReadOnlyData;
   
   public class GameRolePlayNpcQuestFlag extends ReadOnlyData
   {
       
      
      public function GameRolePlayNpcQuestFlag(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get questsToValidId() : Object
      {
         return secure(_target.questsToValidId);
      }
      
      public function get questsToStartId() : Object
      {
         return secure(_target.questsToStartId);
      }
   }
}
