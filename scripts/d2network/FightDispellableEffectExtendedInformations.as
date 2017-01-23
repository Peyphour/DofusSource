package d2network
{
   import utils.ReadOnlyData;
   
   public class FightDispellableEffectExtendedInformations extends ReadOnlyData
   {
       
      
      public function FightDispellableEffectExtendedInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get actionId() : uint
      {
         return _target.actionId;
      }
      
      public function get sourceId() : Number
      {
         return _target.sourceId;
      }
      
      public function get effect() : AbstractFightDispellableEffect
      {
         return secure(_target.effect);
      }
   }
}
