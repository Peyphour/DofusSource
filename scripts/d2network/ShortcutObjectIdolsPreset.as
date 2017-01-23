package d2network
{
   public class ShortcutObjectIdolsPreset extends ShortcutObject
   {
       
      
      public function ShortcutObjectIdolsPreset(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get presetId() : uint
      {
         return _target.presetId;
      }
   }
}
