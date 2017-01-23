package d2network
{
   public class ShortcutEmote extends Shortcut
   {
       
      
      public function ShortcutEmote(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get emoteId() : uint
      {
         return _target.emoteId;
      }
   }
}
