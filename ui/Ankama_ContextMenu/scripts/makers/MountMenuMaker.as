package makers
{
   import d2actions.MountHarnessColorsUpdateRequest;
   import d2actions.MountHarnessDissociateRequest;
   import d2actions.MountInformationInPaddockRequest;
   import d2actions.MountToggleRidingRequest;
   import d2actions.OpenMount;
   
   public class MountMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function MountMenuMaker()
      {
         super();
      }
      
      private function onDetails(param1:Object) : void
      {
         Api.system.sendAction(new MountInformationInPaddockRequest(param1.id));
      }
      
      private function onOpenMountOptions() : void
      {
         Api.system.sendAction(new OpenMount());
      }
      
      private function onEquipMount() : void
      {
         Api.system.sendAction(new MountToggleRidingRequest());
      }
      
      private function onHarnessDissociate() : void
      {
         Api.system.sendAction(new MountHarnessDissociateRequest());
      }
      
      private function onUseHarnessColors(param1:Boolean) : void
      {
         Api.system.sendAction(new MountHarnessColorsUpdateRequest(param1));
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc6_:Object = null;
         var _loc7_:* = false;
         Api.ui.hideTooltip();
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc5_:Object = Api.social.getGuild();
         if(param1.hasOwnProperty("ownerName"))
         {
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.mount.mountOf",param1.ownerName)));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.viewMountDetails"),this.onDetails,[param2[0]],disabled));
         }
         else
         {
            _loc6_ = Api.player.getMount();
            _loc7_ = _loc6_.harnessGID == 0;
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc6_.name));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.options"),this.onOpenMountOptions,null,disabled));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.equip"),this.onEquipMount,null,disabled));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.harness.dissociate"),this.onHarnessDissociate,null,disabled || _loc7_));
            if(_loc6_.useHarnessColors)
            {
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.harness.useMountColors"),this.onUseHarnessColors,[false],disabled || _loc7_));
            }
            else
            {
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.harness.useHarnessColors"),this.onUseHarnessColors,[true],disabled || _loc7_));
            }
         }
         return _loc3_;
      }
   }
}
