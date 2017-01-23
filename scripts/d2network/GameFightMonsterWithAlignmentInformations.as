package d2network
{
   public class GameFightMonsterWithAlignmentInformations extends GameFightMonsterInformations
   {
       
      
      public function GameFightMonsterWithAlignmentInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get alignmentInfos() : ActorAlignmentInformations
      {
         return secure(_target.alignmentInfos);
      }
   }
}
