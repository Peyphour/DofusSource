package d2network
{
   public class GameRolePlayHumanoidInformations extends GameRolePlayNamedActorInformations
   {
       
      
      public function GameRolePlayHumanoidInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get humanoidInfo() : HumanInformations
      {
         return secure(_target.humanoidInfo);
      }
      
      public function get accountId() : uint
      {
         return _target.accountId;
      }
   }
}
