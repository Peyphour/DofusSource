package makers
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.PresetWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import d2actions.MimicryObjectEraseRequest;
   import d2actions.MountInfoRequest;
   import d2actions.WrapperObjectDissociateRequest;
   import d2enums.DataStoreEnum;
   import d2hooks.InsertHyperlink;
   import d2hooks.InsertRecipeHyperlink;
   import d2hooks.OpenBook;
   import d2hooks.OpenFeed;
   import d2hooks.OpenLivingObject;
   import d2hooks.OpenRecipe;
   import d2hooks.OpenSet;
   import flash.geom.Rectangle;
   
   public class ItemMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      private var _itemToFree:ItemWrapper;
      
      private var _shortcutColor:String;
      
      public function ItemMenuMaker()
      {
         super();
         this._shortcutColor = (Api.system.getConfigEntry("colors.contextmenu.shortcut") as String).replace("0x","#");
      }
      
      private function askRecipesItem(param1:Object) : void
      {
         Api.system.dispatchHook(OpenRecipe,param1);
      }
      
      private function askBestiary(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.monsterId = 0;
         _loc2_.monsterSearch = param1.name;
         _loc2_.monsterIdsList = param1.dropMonsterIds;
         _loc2_.forceOpen = true;
         Api.system.dispatchHook(d2hooks.OpenBook,"bestiaryTab",_loc2_);
      }
      
      private function askSetItem(param1:Object) : void
      {
         Api.system.dispatchHook(OpenSet,param1);
      }
      
      private function askLivingObjectItem(param1:Object) : void
      {
         Api.system.dispatchHook(OpenLivingObject,param1);
      }
      
      private function dissociateWrapperObjectItem(param1:Object) : void
      {
         this._itemToFree = param1 as ItemWrapper;
         Api.system.sendAction(new WrapperObjectDissociateRequest(this._itemToFree.objectUID,this._itemToFree.position));
      }
      
      private function dissociateMimicryObjectItem(param1:Object) : void
      {
         this._itemToFree = param1 as ItemWrapper;
         Api.modCommon.openPopup(Api.ui.getText("ui.popup.warning"),Api.ui.getText("ui.mimicry.confirmFreePopup",param1.name),[Api.ui.getText("ui.common.yes"),Api.ui.getText("ui.common.no")],[this.onConfirmFree,this.onCancel],this.onConfirmFree,this.onCancel);
      }
      
      private function displayChatItem(param1:Object) : void
      {
         Api.system.dispatchHook(InsertHyperlink,param1);
      }
      
      private function displayChatRecipe(param1:Object) : void
      {
         Api.system.dispatchHook(InsertRecipeHyperlink,param1.objectGID);
      }
      
      private function viewMountDetails(param1:Object) : void
      {
         Api.system.sendAction(new MountInfoRequest(param1));
      }
      
      private function viewCompanionDetails() : void
      {
         Api.system.sendAction(new d2actions.OpenBook("companionTab"));
      }
      
      public function feedItem(param1:Object) : void
      {
         Api.system.dispatchHook(OpenFeed,param1);
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:Item = null;
         Api.ui.hideTooltip();
         var _loc3_:Boolean = true;
         if(param2 && param2[0])
         {
            if(param2[0].hasOwnProperty("ownedItem"))
            {
               if(param2[0].ownedItem)
               {
                  _loc3_ = false;
               }
            }
         }
         var _loc4_:Array = new Array();
         var _loc5_:String = !!param2?param2.length > 1 && param2[1] is String?param2[1]:null:null;
         var _loc6_:Boolean = Api.jobs.getRecipe(param1.objectGID) || Api.jobs.getRecipesList(param1.objectGID).length;
         if(param1.hasOwnProperty("isCertificate") && param1.isCertificate)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mount.viewMountDetails"),this.viewMountDetails,[param1],disabled));
         }
         if(param1.hasOwnProperty("typeId") && param1.typeId == 169)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.infos"),this.viewCompanionDetails,null,disabled));
         }
         if(param1.hasOwnProperty("isEquipment") && param1.isEquipment && param1.hasOwnProperty("type") && param1.type.superTypeId == 12)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.feed"),this.feedItem,[param1],disabled || _loc3_));
         }
         if(!(param1 is PresetWrapper) && param1 is ItemWrapper && _loc6_)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.craft.associateReceipts"),this.askRecipesItem,[param1],disabled));
         }
         if(param1.hasOwnProperty("dropMonsterIds") && param1.dropMonsterIds && param1.dropMonsterIds.length > 0)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.bestiary"),this.askBestiary,[param1],disabled));
         }
         else if(param1.hasOwnProperty("containerIds") && param1.containerIds && param1.containerIds.length > 0)
         {
            for each(_loc8_ in param1.containerIds)
            {
               _loc9_ = Api.data.getItem(_loc8_);
               if(_loc9_ && _loc9_.hasOwnProperty("dropMonsterIds") && _loc9_.dropMonsterIds && _loc9_.dropMonsterIds.length > 0)
               {
                  _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.bestiary"),this.askBestiary,[_loc9_],disabled));
                  break;
               }
            }
         }
         if(param1.hasOwnProperty("belongsToSet") && param1.belongsToSet)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.set"),this.askSetItem,[param1],disabled));
         }
         if(param1.hasOwnProperty("isLivingObject") && param1.isLivingObject)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.item.manageItem"),this.askLivingObjectItem,[param1],disabled));
         }
         if(param1.hasOwnProperty("isObjectWrapped") && param1.isObjectWrapped)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.item.dissociate"),this.dissociateWrapperObjectItem,[param1],disabled || _loc3_));
         }
         else if(param1.hasOwnProperty("isMimicryObject") && param1.isMimicryObject && _loc5_ != "itemBoxPop")
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.mimicry.free"),this.dissociateMimicryObjectItem,[param1],disabled || _loc3_));
         }
         if(_loc4_.length)
         {
            _loc4_.push(ContextMenu.static_createContextMenuSeparatorObject());
         }
         var _loc7_:* = Api.ui.getUi("chat");
         if(_loc7_ && !(param1 is PresetWrapper) && param1 is ItemWrapper)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.craft.displayChatItem") + " <font color=\'" + this._shortcutColor + "\'>(Shift + " + Api.ui.getText("ui.mouse.click") + ")</font>",this.displayChatItem,[param1],disabled));
         }
         if(_loc7_ && !(param1 is PresetWrapper) && param1 is ItemWrapper && _loc6_)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.craft.displayChatRecipe"),this.displayChatRecipe,[param1],disabled));
         }
         if((!_loc5_ || _loc5_.indexOf("_pin@") == -1) && (param1 is Item || param1 is ItemWrapper))
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.tooltip.pin") + " <font color=\'" + this._shortcutColor + "\'>(Shift)</font>",this.pinTooltip,[param1]));
         }
         return _loc4_;
      }
      
      private function pinTooltip(param1:*) : void
      {
         var _loc4_:String = null;
         var _loc2_:* = new Object();
         var _loc3_:ItemTooltipSettings = Api.system.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(_loc3_ == null)
         {
            _loc3_ = Api.tooltip.createItemSettings();
            Api.system.setData("itemTooltipSettings",_loc3_,DataStoreEnum.BIND_ACCOUNT);
         }
         var _loc5_:* = Api.system.getObjectVariables(_loc3_);
         for each(_loc4_ in _loc5_)
         {
            _loc2_[_loc4_] = _loc3_[_loc4_];
         }
         _loc2_.pinnable = true;
         Api.ui.showTooltip(param1,new Rectangle(20,20,0,0),false,"standard",0,0,0,null,null,_loc2_,null,true,4,1,"storage");
      }
      
      protected function onConfirmFree() : void
      {
         Api.system.sendAction(new MimicryObjectEraseRequest(this._itemToFree.objectUID,this._itemToFree.position));
      }
      
      protected function onCancel() : void
      {
      }
   }
}
