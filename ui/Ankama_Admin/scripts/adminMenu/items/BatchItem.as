package adminMenu.items
{
   public class BatchItem extends ExecItem
   {
       
      
      public var subItem:Array;
      
      public function BatchItem(param1:int = 0, param2:int = 1)
      {
         this.subItem = [];
         super(param1,param2);
      }
      
      override public function getContextMenuItem(param1:Object) : Object
      {
         return Api.contextMod.createContextMenuItemObject(replace(label,param1),this.execCmdCallback,[param1],false,null,false,true,help);
      }
      
      private function execCmdCallback(param1:Object) : void
      {
         var _loc2_:SendCommandItem = null;
         for each(_loc2_ in this.subItem)
         {
            if(_loc2_)
            {
               _loc2_.callbackFunction.apply(null,_loc2_.getcallbackArgs(param1));
            }
         }
      }
      
      override public function get callbackFunction() : Function
      {
         return this.execCmdCallback;
      }
      
      override public function getcallbackArgs(param1:Object) : Array
      {
         return [param1];
      }
   }
}
