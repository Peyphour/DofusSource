package d2network
{
   public class GameRolePlayNpcInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayNpcInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get npcId() : uint
      {
         return _target.npcId;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get specialArtworkId() : uint
      {
         return _target.specialArtworkId;
      }
   }
}
