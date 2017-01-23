package makers
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.network.types.game.prism.AllianceInsiderPrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.AlliancePrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismInformation;
   import d2actions.NpcGenericActionRequest;
   import d2actions.PrismAttackRequest;
   import d2actions.PrismModuleExchangeRequest;
   import d2actions.PrismSetSabotagedRequest;
   import d2actions.PrismUseRequest;
   import d2enums.AlliancePrismModuleTypeEnum;
   import d2enums.PrismStateEnum;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenSocial;
   
   public class PrismMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public var _subAreaId:int;
      
      public function PrismMenuMaker()
      {
         super();
      }
      
      private function onPrismTalk(param1:Number) : void
      {
         Api.system.sendAction(new NpcGenericActionRequest(param1,3));
      }
      
      private function onPrismAttacked() : void
      {
         Api.system.sendAction(new PrismAttackRequest());
      }
      
      private function onPrismTeleport() : void
      {
         Api.system.sendAction(new PrismUseRequest(AlliancePrismModuleTypeEnum.TELEPORTER));
      }
      
      private function onPrismRecycle() : void
      {
         Api.system.sendAction(new PrismUseRequest(AlliancePrismModuleTypeEnum.RECYCLER));
      }
      
      private function onPrismModulesManage() : void
      {
         Api.system.sendAction(new PrismModuleExchangeRequest());
      }
      
      private function onPrismModify() : void
      {
         var _loc1_:int = Api.player.currentSubArea().id;
         Api.system.dispatchHook(OpenSocial,2,1,[_loc1_]);
      }
      
      private function onPrismSabotage(param1:Number) : void
      {
         this._subAreaId = Api.player.currentSubArea().id;
         var _loc2_:String = Api.time.getDate(param1 * 1000) + " " + Api.time.getClock(param1 * 1000);
         Api.modCommon.openPopup(Api.ui.getText("ui.popup.warning"),Api.ui.getText("ui.prism.sabotageConfirm",Api.player.currentSubArea().name,_loc2_),[Api.ui.getText("ui.common.yes"),Api.ui.getText("ui.common.no")],[this.onValidSabotage],this.onValidSabotage);
      }
      
      protected function onValidSabotage() : void
      {
         Api.system.sendAction(new PrismSetSabotagedRequest(this._subAreaId));
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
         var _loc7_:String = null;
         var _loc8_:AllianceInsiderPrismInformation = null;
         var _loc9_:ObjectItem = null;
         var _loc10_:ObjectEffect = null;
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc6_:PrismInformation = param1.prism;
         _loc5_ = Api.social.getAllianceNameAndTag(_loc6_);
         if(param2.rightClick)
         {
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc5_));
            _loc7_ = Api.ui.getText("ui.prism.prismInState",Api.ui.getText("ui.prism.state" + _loc6_.state)) + " " + Api.ui.replaceKey(_loc5_);
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.chat.insertCoordinates"),this.insertLink,[_loc7_],disabled));
            return _loc3_;
         }
         if(_loc6_ is AlliancePrismInformation)
         {
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc5_));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.talk"),this.onPrismTalk,[param2.entity.id]));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.attack"),this.onPrismAttacked,null,disabled || _loc4_ || _loc6_.state != PrismStateEnum.PRISM_STATE_NORMAL));
         }
         else if(_loc6_ is AllianceInsiderPrismInformation)
         {
            _loc8_ = _loc6_ as AllianceInsiderPrismInformation;
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc5_));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.talk"),this.onPrismTalk,[param2.entity.id]));
            if(_loc8_.modulesObjects && _loc8_.modulesObjects.length > 0)
            {
               for each(_loc9_ in _loc8_.modulesObjects)
               {
                  if(_loc9_.objectGID == 14552)
                  {
                     _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.teleport"),this.onPrismTeleport,null,_loc6_.state == PrismStateEnum.PRISM_STATE_VULNERABLE));
                  }
                  else
                  {
                     for each(_loc10_ in _loc9_.effects)
                     {
                        if(_loc10_.actionId == 2021)
                        {
                           _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.recycle.recycle"),this.onPrismRecycle,null,_loc6_.state == PrismStateEnum.PRISM_STATE_VULNERABLE));
                        }
                     }
                  }
               }
            }
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.prism.manageModules"),this.onPrismModulesManage,null,_loc6_.state == PrismStateEnum.PRISM_STATE_VULNERABLE));
            if(Api.social.hasGuildRight(Api.player.id(),"setAlliancePrism"))
            {
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.modify"),this.onPrismModify));
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.prism.sabotage"),this.onPrismSabotage,[_loc8_.nextVulnerabilityDate],_loc6_.state != PrismStateEnum.PRISM_STATE_NORMAL));
            }
         }
         return _loc3_;
      }
   }
}
