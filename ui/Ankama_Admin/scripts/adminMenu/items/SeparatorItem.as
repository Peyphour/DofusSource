package adminMenu.items
{
   public class SeparatorItem extends BasicItem
   {
       
      
      private var _label:String;
      
      public function SeparatorItem()
      {
         super();
      }
      
      override public function getContextMenuItem(param1:Object) : Object
      {
         return Api.contextMod.createContextMenuSeparatorObject();
      }
      
      override public function get label() : String
      {
         return "";
      }
      
      override public function set label(param1:String) : void
      {
      }
      
      override protected function replace(param1:String, param2:Object) : String
      {
         return "";
      }
   }
}
