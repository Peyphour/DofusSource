package d2data
{
   public class EffectInstanceDice extends EffectInstanceInteger
   {
       
      
      public function EffectInstanceDice(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get diceNum() : uint
      {
         return _target.diceNum;
      }
      
      public function get diceSide() : uint
      {
         return _target.diceSide;
      }
   }
}
