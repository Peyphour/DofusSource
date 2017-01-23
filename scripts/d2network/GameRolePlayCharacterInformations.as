package d2network
{
   public class GameRolePlayCharacterInformations extends GameRolePlayHumanoidInformations
   {
       
      
      public function GameRolePlayCharacterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get alignmentInfos() : ActorAlignmentInformations
      {
         return secure(_target.alignmentInfos);
      }
   }
}
