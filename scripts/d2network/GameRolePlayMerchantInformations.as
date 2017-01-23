package d2network
{
   public class GameRolePlayMerchantInformations extends GameRolePlayNamedActorInformations
   {
       
      
      public function GameRolePlayMerchantInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get sellType() : uint
      {
         return _target.sellType;
      }
      
      public function get options() : Object
      {
         return secure(_target.options);
      }
   }
}
