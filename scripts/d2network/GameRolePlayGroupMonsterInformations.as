package d2network
{
   public class GameRolePlayGroupMonsterInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayGroupMonsterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get staticInfos() : GroupMonsterStaticInformations
      {
         return secure(_target.staticInfos);
      }
      
      public function get creationTime() : Number
      {
         return _target.creationTime;
      }
      
      public function get ageBonusRate() : uint
      {
         return _target.ageBonusRate;
      }
      
      public function get lootShare() : int
      {
         return _target.lootShare;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get keyRingBonus() : Boolean
      {
         return _target.keyRingBonus;
      }
      
      public function get hasHardcoreDrop() : Boolean
      {
         return _target.hasHardcoreDrop;
      }
      
      public function get hasAVARewardToken() : Boolean
      {
         return _target.hasAVARewardToken;
      }
   }
}
