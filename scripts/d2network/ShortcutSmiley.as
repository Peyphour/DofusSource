package d2network
{
   public class ShortcutSmiley extends Shortcut
   {
       
      
      public function ShortcutSmiley(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get smileyId() : uint
      {
         return _target.smileyId;
      }
   }
}
