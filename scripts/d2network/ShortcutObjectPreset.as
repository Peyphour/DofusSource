package d2network
{
   public class ShortcutObjectPreset extends ShortcutObject
   {
       
      
      public function ShortcutObjectPreset(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get presetId() : uint
      {
         return _target.presetId;
      }
   }
}
