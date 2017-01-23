package makers
{
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.PortalInformation;
   import d2actions.NpcGenericActionRequest;
   import d2actions.PortalUseRequest;
   import d2hooks.MouseShiftClick;
   
   public class PortalMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public var _portalId:int;
      
      public var _areaName:String;
      
      public function PortalMenuMaker()
      {
         super();
      }
      
      private function onPortalTalk(param1:Number) : void
      {
         Api.system.sendAction(new NpcGenericActionRequest(param1,3));
      }
      
      private function onPortalUse() : void
      {
         Api.modCommon.openPopup(Api.ui.getText("ui.popup.warning"),Api.ui.getText("ui.dimension.confirmTeleport",this._areaName),[Api.ui.getText("ui.common.yes"),Api.ui.getText("ui.common.no")],[this.onValid],this.onValid);
      }
      
      protected function onValid() : void
      {
         Api.system.sendAction(new PortalUseRequest(this._portalId));
      }
      
      private function insertLink(param1:String) : void
      {
         Api.system.dispatchHook(MouseShiftClick,{
            "data":"Map",
            "params":{
               "x":Api.player.currentMap().outdoorX,
               "y":Api.player.currentMap().outdoorY,
               "worldMapId":Api.player.currentSubArea().worldmap.id,
               "elementName":param1 + " "
            }
         });
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc5_:String = null;
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc6_:PortalInformation = param1.portal;
         this._portalId = _loc6_.portalId;
         var _loc7_:Area = Api.data.getArea(_loc6_.areaId);
         if(_loc7_)
         {
            this._areaName = _loc7_.name;
         }
         else
         {
            this._areaName = "???";
         }
         _loc5_ = Api.ui.getText("ui.dimension.portal",this._areaName);
         _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc5_));
         if(!param2.rightClick)
         {
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.talk"),this.onPortalTalk,[param2.entity.id]));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.use"),this.onPortalUse,null,disabled || _loc4_));
         }
         else
         {
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.chat.insertCoordinates"),this.insertLink,[_loc5_],disabled));
         }
         return _loc3_;
      }
   }
}
