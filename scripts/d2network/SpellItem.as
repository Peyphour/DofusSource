package d2network
{
   public class SpellItem extends Item
   {
       
      
      public function SpellItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get spellId() : int
      {
         return _target.spellId;
      }
      
      public function get spellLevel() : int
      {
         return _target.spellLevel;
      }
   }
}
