package d2network
{
   public class GameRolePlayTreasureHintInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayTreasureHintInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get npcId() : uint
      {
         return _target.npcId;
      }
   }
}
