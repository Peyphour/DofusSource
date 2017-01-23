package d2network
{
   public class ObjectEffectDice extends ObjectEffect
   {
       
      
      public function ObjectEffectDice(param1:*, param2:Object)
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
      
      public function get diceConst() : uint
      {
         return _target.diceConst;
      }
   }
}
