package d2network
{
   public class GameFightCharacterInformations extends GameFightFighterNamedInformations
   {
       
      
      public function GameFightCharacterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get alignmentInfos() : ActorAlignmentInformations
      {
         return secure(_target.alignmentInfos);
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
   }
}
