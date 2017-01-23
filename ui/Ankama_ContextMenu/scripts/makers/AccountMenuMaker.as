package makers
{
   import d2enums.WebLocationEnum;
   import d2hooks.OpenWebPortal;
   
   public class AccountMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function AccountMenuMaker()
      {
         super();
      }
      
      protected function onAnkaboxMessage(param1:String) : void
      {
         Api.system.dispatchHook(OpenWebPortal,WebLocationEnum.WEB_LOCATION_ANKABOX_SEND_MESSAGE,false,[param1]);
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.ankaboxMessage"),this.onAnkaboxMessage,[param1.id],disabled));
         return _loc3_;
      }
   }
}
