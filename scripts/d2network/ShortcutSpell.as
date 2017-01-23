package d2network
{
   public class ShortcutSpell extends Shortcut
   {
       
      
      public function ShortcutSpell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get spellId() : uint
      {
         return _target.spellId;
      }
   }
}
