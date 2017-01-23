package d2network
{
   public class ShortcutObjectItem extends ShortcutObject
   {
       
      
      public function ShortcutObjectItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get itemUID() : int
      {
         return _target.itemUID;
      }
      
      public function get itemGID() : int
      {
         return _target.itemGID;
      }
   }
}
