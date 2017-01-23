package adminMenu.items
{
   public class BasicItem
   {
       
      
      private var _label:String;
      
      public var help:String;
      
      public var rank:int;
      
      public function BasicItem()
      {
         super();
      }
      
      public function getContextMenuItem(param1:Object) : Object
      {
         return Api.contextMod.createContextMenuTitleObject(this.replace(this.label,param1));
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
      }
      
      protected function replace(param1:String, param2:Object) : String
      {
         var _loc3_:* = null;
         for(_loc3_ in param2)
         {
            param1 = param1.split("%" + _loc3_).join(param2[_loc3_]);
         }
         return param1;
      }
   }
}
