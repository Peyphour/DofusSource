package d2data
{
   import utils.ReadOnlyData;
   
   public class SpellBomb extends ReadOnlyData
   {
       
      
      public function SpellBomb(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get chainReactionSpellId() : int
      {
         return _target.chainReactionSpellId;
      }
      
      public function get explodSpellId() : int
      {
         return _target.explodSpellId;
      }
      
      public function get wallId() : int
      {
         return _target.wallId;
      }
      
      public function get instantSpellId() : int
      {
         return _target.instantSpellId;
      }
      
      public function get comboCoeff() : int
      {
         return _target.comboCoeff;
      }
   }
}
