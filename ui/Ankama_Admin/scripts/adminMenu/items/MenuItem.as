package adminMenu.items
{
   public class MenuItem extends BasicItem
   {
       
      
      public var children:Array;
      
      public function MenuItem()
      {
         this.children = [];
         super();
      }
      
      override public function getContextMenuItem(param1:Object) : Object
      {
         var _loc3_:BasicItem = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.children)
         {
            _loc2_.push(_loc3_.getContextMenuItem(param1),null,null,false,null,false,true,help);
         }
         return Api.contextMod.createContextMenuItemObject(label,null,null,false,_loc2_,false,true,help);
      }
   }
}
