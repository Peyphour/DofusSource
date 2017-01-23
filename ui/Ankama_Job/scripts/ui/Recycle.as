package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.CloseInventory;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeReady;
   import d2actions.ExchangeRefuse;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeObjectAdded;
   import d2hooks.ExchangeObjectListAdded;
   import d2hooks.ExchangeObjectListModified;
   import d2hooks.ExchangeObjectListRemoved;
   import d2hooks.ExchangeObjectModified;
   import d2hooks.ExchangeObjectRemoved;
   import d2hooks.RecycleResult;
   import flash.utils.Dictionary;
   
   public class Recycle
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var menuApi:ContextMenuApi;
      
      public var soundApi:SoundApi;
      
      public var tooltipApi:TooltipApi;
      
      public var storageApi:StorageApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var socialApi:SocialApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var btn_close:ButtonContainer;
      
      public var gd_items:Grid;
      
      public var lbl_explanation:Label;
      
      public var lbl_distribution:Label;
      
      public var lbl_myTotal:Label;
      
      public var lbl_allianceTotal:Label;
      
      public var lbl_quantityObject:Label;
      
      public var lbl_objectsPrice:Label;
      
      public var lbl_minePrice:Label;
      
      public var lbl_alliancePrice:Label;
      
      public var btn_recycle:ButtonContainer;
      
      public var btn_tabItem:ButtonContainer;
      
      public var btn_tabBonus:ButtonContainer;
      
      public var btn_tabMyNuggets:ButtonContainer;
      
      public var btn_tabAllianceNuggets:ButtonContainer;
      
      public var tx_kama1:Texture;
      
      public var tx_kama2:Texture;
      
      public var tx_kama3:Texture;
      
      public var tx_nugget:Texture;
      
      private var _itemsToRecycle:Array;
      
      private var _recyclingSubareaIds:Array;
      
      private var _item:Object;
      
      private var _compInteractiveList:Dictionary;
      
      private var _estimatedItemsPrice:Number = 0;
      
      private var _nuggetAveragePrice:int;
      
      private var _charNuggetsQuantity:Number = 0;
      
      private var _allianceNuggetsQuantity:Number = 0;
      
      private var _distributionCharPercent:int;
      
      private var _distributionAlliancePercent:int;
      
      private var _modeResult:Boolean = false;
      
      private var ZONE_BONUS:int = 2;
      
      private var NUGGET_ITEM_GID:int = 14635;
      
      public function Recycle()
      {
         this._itemsToRecycle = new Array();
         this._recyclingSubareaIds = new Array();
         this._compInteractiveList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc4_:PrismSubAreaWrapper = null;
         var _loc5_:int = 0;
         var _loc6_:ObjectItem = null;
         var _loc7_:ObjectEffect = null;
         this.sysApi.disableWorldInteraction(false);
         this.sysApi.addHook(ExchangeObjectModified,this.onExchangeObjectModified);
         this.sysApi.addHook(ExchangeObjectAdded,this.onExchangeObjectAdded);
         this.sysApi.addHook(ExchangeObjectRemoved,this.onExchangeObjectRemoved);
         this.sysApi.addHook(DoubleClickItemInventory,this.onDoubleClickItemInventory);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(ExchangeObjectListAdded,this.onExchangeObjectListAdded);
         this.sysApi.addHook(ExchangeObjectListModified,this.onExchangeObjectListModified);
         this.sysApi.addHook(ExchangeObjectListRemoved,this.onExchangeObjectListRemoved);
         this.sysApi.addHook(RecycleResult,this.onRecycleResult);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_tabBonus,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_tabBonus,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_distribution,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_distribution,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_myTotal,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_myTotal,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_allianceTotal,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_allianceTotal,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_tabMyNuggets,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_tabMyNuggets,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_tabAllianceNuggets,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_tabAllianceNuggets,ComponentHookList.ON_ROLL_OUT);
         this.gd_items.autoSelectMode = 0;
         this.gd_items.dropValidator = this.dropValidatorFunction as Function;
         this.gd_items.processDrop = this.processDropFunction as Function;
         this.gd_items.removeDropSource = this.removeDropSourceFunction as Function;
         this.gd_items.mouseEnabled = true;
         this.gd_items.dataProvider = new Array();
         this.btn_recycle.disabled = true;
         this.sysApi.disableWorldInteraction();
         var _loc2_:Item = this.dataApi.getItem(this.NUGGET_ITEM_GID);
         if(_loc2_)
         {
            this.tx_nugget.uri = this.uiApi.createUri(this.uiApi.me().getConstant("item_path") + _loc2_.iconId + ".swf");
         }
         var _loc3_:Object = this.socialApi.getAlliance().prismIds;
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = this.socialApi.getPrismSubAreaById(_loc5_);
            for each(_loc6_ in _loc4_.modulesObjects)
            {
               for each(_loc7_ in _loc6_.effects)
               {
                  if(_loc7_.actionId == 2021)
                  {
                     this._recyclingSubareaIds.push(_loc5_);
                  }
               }
            }
         }
         this._nuggetAveragePrice = this.averagePricesApi.getItemAveragePrice(this.NUGGET_ITEM_GID);
         this._distributionCharPercent = param1[0];
         this._distributionAlliancePercent = param1[1];
         this.lbl_distribution.text = this.uiApi.getText("ui.recycle.distributionDetailed",this._distributionCharPercent,this._distributionAlliancePercent);
         this.updateGrid();
      }
      
      public function unload() : void
      {
         this.storageApi.removeAllItemMasks("exchange");
         this.storageApi.releaseHooks();
         this.sysApi.sendAction(new ExchangeRefuse());
         this.sysApi.sendAction(new CloseInventory());
         this.sysApi.enableWorldInteraction();
      }
      
      public function updateItemLine(param1:*, param2:*, param3:Boolean) : void
      {
         param2.slot_item.allowDrag = true;
         if(!this._compInteractiveList[param2.slot_item.name])
         {
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OUT);
         }
         this._compInteractiveList[param2.slot_item.name] = param1;
         if(!this._compInteractiveList[param2.lbl_areaBonus.name])
         {
            this.uiApi.addComponentHook(param2.lbl_areaBonus,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_areaBonus,ComponentHookList.ON_ROLL_OUT);
         }
         this._compInteractiveList[param2.lbl_areaBonus.name] = param1;
         if(param1)
         {
            param2.slot_item.visible = true;
            param2.lbl_itemName.text = param1.item.shortName;
            if(param1.bonus != 0)
            {
               param2.lbl_areaBonus.text = param1.bonus + "%";
            }
            else
            {
               param2.lbl_areaBonus.text = "-";
            }
            param2.lbl_myNuggets.text = Math.round(param1.charNuggetsQty * 100) / 100;
            param2.lbl_allianceNuggets.text = Math.round(param1.allianceNuggetsQty * 100) / 100;
            param2.slot_item.data = param1.item;
            param2.tx_backgroundItem.visible = true;
            param2.tx_arrow.visible = true;
            if(param1.item.etheral)
            {
               param2.lbl_itemName.cssClass = "itemetheral";
            }
            else if(param1.item.itemSetId != -1)
            {
               param2.lbl_itemName.cssClass = "itemset";
            }
            else
            {
               param2.lbl_itemName.cssClass = "p";
            }
         }
         else
         {
            param2.slot_item.visible = false;
            param2.lbl_itemName.text = "";
            param2.lbl_areaBonus.text = "";
            param2.lbl_myNuggets.text = "";
            param2.lbl_allianceNuggets.text = "";
            param2.slot_item.data = null;
            param2.tx_backgroundItem.visible = false;
            param2.tx_arrow.visible = false;
         }
      }
      
      public function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(!param2 || !(param2 is ItemWrapper))
         {
            return false;
         }
         return true;
      }
      
      public function removeDropSourceFunction(param1:Object) : void
      {
      }
      
      public function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropValidatorFunction(param1,param2,param3))
         {
            this._item = param2;
            if(param2.quantity > 1)
            {
               this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQty);
            }
            else
            {
               this.onValidQty(1);
            }
         }
      }
      
      private function validateDecraft() : void
      {
         this.sysApi.sendAction(new ExchangeReady(true));
      }
      
      private function updateGrid() : void
      {
         this.storageApi.releaseHooks();
         this.gd_items.dataProvider = this._itemsToRecycle;
         if(this._itemsToRecycle.length > 0)
         {
            this._modeResult = false;
            this.lbl_explanation.visible = false;
            this.tx_kama1.visible = true;
            this.tx_kama2.visible = true;
            this.tx_kama3.visible = true;
            this.lbl_quantityObject.text = "" + this._itemsToRecycle.length + "/" + ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT;
            this.btn_recycle.disabled = false;
            this.lbl_myTotal.text = (Math.round(this._charNuggetsQuantity * 100) / 100).toString();
            this.lbl_allianceTotal.text = (Math.round(this._allianceNuggetsQuantity * 100) / 100).toString();
            this.lbl_objectsPrice.text = this._estimatedItemsPrice.toString();
            this.lbl_minePrice.text = Math.floor(this._charNuggetsQuantity * this._nuggetAveragePrice).toString();
            this.lbl_alliancePrice.text = Math.floor(this._allianceNuggetsQuantity * this._nuggetAveragePrice).toString();
         }
         else
         {
            this.lbl_quantityObject.text = "";
            this.btn_recycle.disabled = true;
            this.lbl_myTotal.text = "";
            this.lbl_allianceTotal.text = "";
            this.lbl_objectsPrice.text = "";
            this.lbl_minePrice.text = "";
            this.lbl_alliancePrice.text = "";
            this.lbl_explanation.visible = true;
            this.tx_kama1.visible = false;
            this.tx_kama2.visible = false;
            this.tx_kama3.visible = false;
            this._estimatedItemsPrice = 0;
            this._charNuggetsQuantity = 0;
            this._allianceNuggetsQuantity = 0;
         }
      }
      
      private function compareItemsAveragePrices(param1:Object, param2:Object) : int
      {
         var _loc3_:int = this.averagePricesApi.getItemAveragePrice(param1.objectGID) * param1.quantity;
         var _loc4_:int = this.averagePricesApi.getItemAveragePrice(param2.objectGID) * param2.quantity;
         return _loc3_ < _loc4_?1:_loc3_ > _loc4_?-1:0;
      }
      
      private function prepareItem(param1:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:Object = {
            "item":param1,
            "bonus":0,
            "charNuggetsQty":0,
            "allianceNuggetsQty":0
         };
         var _loc3_:Number = 0;
         for each(_loc4_ in param1.nuggetsBySubarea)
         {
            if(this._recyclingSubareaIds.indexOf(_loc4_[0]) != -1)
            {
               _loc3_ = _loc3_ + this.ZONE_BONUS * _loc4_[1];
            }
            else
            {
               _loc3_ = _loc3_ + _loc4_[1];
            }
         }
         _loc5_ = 0;
         if(param1.nuggetsQuantity > 0)
         {
            _loc5_ = Math.round(_loc3_ / param1.nuggetsQuantity * 100) - 100;
         }
         var _loc6_:Number = _loc3_ * param1.quantity * this._distributionCharPercent / 100;
         var _loc7_:Number = _loc3_ * param1.quantity * this._distributionAlliancePercent / 100;
         _loc2_.bonus = _loc5_;
         _loc2_.charNuggetsQty = _loc6_;
         _loc2_.allianceNuggetsQty = _loc7_;
         return _loc2_;
      }
      
      protected function onRecycleResult(param1:uint, param2:uint) : void
      {
         this._modeResult = true;
         this._itemsToRecycle = new Array();
         this.storageApi.removeAllItemMasks("exchange");
         this.lbl_myTotal.text = this.utilApi.kamasToString(param1,"");
         this.lbl_allianceTotal.text = this.utilApi.kamasToString(param2,"");
         this.updateGrid();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(param1 == this.gd_items)
         {
            _loc4_ = this.gd_items.selectedItem;
            if(!_loc4_)
            {
               return;
            }
            switch(param2)
            {
               case SelectMethodEnum.DOUBLE_CLICK:
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc4_.item.objectUID,-1));
                  break;
               case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc4_.item.objectUID,-_loc4_.item.quantity));
                  break;
               case SelectMethodEnum.ALT_DOUBLE_CLICK:
                  this._item = _loc4_.item;
                  this.modCommon.openQuantityPopup(1,this._item.quantity,this._item.quantity,this.onAltValidQty);
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.sysApi.sendAction(new LeaveDialogRequest());
               break;
            case this.btn_recycle:
               if(this._itemsToRecycle.length > 0)
               {
                  this.sysApi.sendAction(new ExchangeReady(true));
                  this.storageApi.removeAllItemMasks("exchange");
               }
         }
      }
      
      public function onDoubleClickItemInventory(param1:Object, param2:int = 1) : void
      {
         if(!param1)
         {
            return;
         }
         this._item = param1;
         this.onValidQty(param2);
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         if(param2.data == null)
         {
            return;
         }
         var _loc3_:Object = this.menuApi.create(param2.data);
         var _loc4_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(!_loc4_)
         {
            _loc4_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc4_,DataStoreEnum.BIND_ACCOUNT);
         }
         var _loc5_:Boolean = _loc3_.content[0].disabled;
         this.modContextMenu.createContextMenu(_loc3_);
      }
      
      public function onRightClick(param1:Object) : void
      {
         if(param1.data == null)
         {
            return;
         }
         var _loc2_:Object = param1.data;
         if(_loc2_.hasOwnProperty("item") && _loc2_.item)
         {
            _loc2_ = _loc2_.item;
         }
         var _loc3_:Object = this.menuApi.create(_loc2_);
         var _loc4_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(!_loc4_)
         {
            _loc4_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc4_,DataStoreEnum.BIND_ACCOUNT);
         }
         if(_loc3_.content.length > 0)
         {
            this.modContextMenu.createContextMenu(_loc3_);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:Object = null;
         var _loc5_:ItemTooltipSettings = null;
         var _loc6_:Object = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case this.btn_tabBonus:
               _loc2_ = this.uiApi.getText("ui.recycle.bonusHelp");
               break;
            case this.lbl_distribution:
               _loc2_ = this.uiApi.getText("ui.recycle.distributionHelp");
               break;
            case this.lbl_myTotal:
               if(!this._modeResult && this.lbl_myTotal.text != "")
               {
                  _loc2_ = this.uiApi.getText("ui.recycle.myNuggetsHelp");
               }
               break;
            case this.lbl_allianceTotal:
               if(!this._modeResult && this.lbl_allianceTotal.text != "")
               {
                  _loc2_ = this.uiApi.getText("ui.recycle.allianceNuggetsHelp");
               }
               break;
            case this.btn_tabMyNuggets:
               _loc2_ = this.uiApi.getText("ui.recycle.myNuggetsHelp");
               break;
            case this.btn_tabAllianceNuggets:
               _loc2_ = this.uiApi.getText("ui.recycle.allianceNuggetsHelp");
               break;
            default:
               if(param1.name.indexOf("lbl_percent") != -1 && this._compInteractiveList[param1.name])
               {
                  _loc4_ = this._compInteractiveList[param1.name];
                  if(_loc4_.item.recipeSlots == 0 && !_loc4_.item.secretRecipe)
                  {
                     _loc2_ = this.uiApi.getText("ui.crush.lockedCoefficientHelp");
                  }
                  else if(_loc4_.bonusMax != _loc4_.bonusMin)
                  {
                     _loc2_ = _loc4_.bonusMax + " " + this.uiApi.getText("ui.chat.to") + " " + _loc4_.bonusMin + "%";
                  }
               }
               else if(param1.name.indexOf("lbl_areaBonus") != -1)
               {
                  _loc4_ = this._compInteractiveList[param1.name];
                  if(_loc4_ && _loc4_.bonus != 0)
                  {
                     _loc2_ = this.uiApi.getText("ui.recycle.bonusHelp");
                  }
               }
               else if(param1.name.indexOf("slot_item") != -1)
               {
                  _loc5_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
                  if(!_loc5_)
                  {
                     _loc5_ = this.tooltipApi.createItemSettings();
                     this.sysApi.setData("itemTooltipSettings",_loc5_,DataStoreEnum.BIND_ACCOUNT);
                  }
                  if(this._compInteractiveList[param1.name].hasOwnProperty("item") && this._compInteractiveList[param1.name].item)
                  {
                     _loc6_ = this._compInteractiveList[param1.name].item;
                  }
                  else
                  {
                     _loc6_ = this._compInteractiveList[param1.name];
                  }
                  if(!_loc5_.header && !_loc5_.conditions && !_loc5_.effects && !_loc5_.description && !_loc5_.averagePrice)
                  {
                     _loc6_ = _loc6_.name;
                  }
                  this.uiApi.showTooltip(_loc6_,param1,false,"standard",7,7,0,"itemName",null,{
                     "header":_loc5_.header,
                     "conditions":_loc5_.conditions,
                     "description":_loc5_.description,
                     "averagePrice":_loc5_.averagePrice,
                     "showEffects":_loc5_.effects
                  },"ItemInfo");
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.sysApi.sendAction(new LeaveDialogRequest());
               return true;
            default:
               return false;
         }
      }
      
      private function onValidQty(param1:Number) : void
      {
         this.sysApi.sendAction(new ExchangeObjectMove(this._item.objectUID,param1));
      }
      
      private function onAltValidQty(param1:Number) : void
      {
         this.sysApi.sendAction(new ExchangeObjectMove(this._item.objectUID,-param1));
      }
      
      private function onExchangeObjectAdded(param1:Object, param2:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         this.storageApi.addItemMask(param1.objectUID,"exchange",param1.quantity);
         var _loc3_:Object = this.prepareItem(param1);
         this._itemsToRecycle.push(_loc3_);
         this._estimatedItemsPrice = this._estimatedItemsPrice + this.averagePricesApi.getItemAveragePrice(param1.objectGID) * param1.quantity;
         this._charNuggetsQuantity = this._charNuggetsQuantity + _loc3_.charNuggetsQty;
         this._allianceNuggetsQuantity = this._allianceNuggetsQuantity + _loc3_.allianceNuggetsQty;
         this.sysApi.log(2,"Adding 0 ? " + _loc3_.item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
         this.updateGrid();
      }
      
      private function onExchangeObjectListAdded(param1:Object, param2:Object) : void
      {
         var _loc3_:ItemWrapper = null;
         var _loc4_:Object = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         for each(_loc3_ in param1)
         {
            this.storageApi.addItemMask(_loc3_.objectUID,"exchange",_loc3_.quantity);
            _loc4_ = this.prepareItem(_loc3_);
            this._itemsToRecycle.push(_loc4_);
            this._estimatedItemsPrice = this._estimatedItemsPrice + this.averagePricesApi.getItemAveragePrice(_loc3_.objectGID) * _loc3_.quantity;
            this._charNuggetsQuantity = this._charNuggetsQuantity + _loc4_.charNuggetsQty;
            this._allianceNuggetsQuantity = this._allianceNuggetsQuantity + _loc4_.allianceNuggetsQty;
            this.sysApi.log(2,"Adding 1 ? " + _loc4_.item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
         }
         this.updateGrid();
      }
      
      private function onExchangeObjectModified(param1:Object, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         for(_loc4_ in this._itemsToRecycle)
         {
            if(this._itemsToRecycle[_loc4_].item.objectUID == param1.objectUID)
            {
               _loc3_ = _loc4_;
               _loc5_ = this.averagePricesApi.getItemAveragePrice(param1.objectGID);
               this._estimatedItemsPrice = this._estimatedItemsPrice - _loc5_ * this._itemsToRecycle[_loc4_].item.quantity;
               this._estimatedItemsPrice = this._estimatedItemsPrice + _loc5_ * param1.quantity;
               this._charNuggetsQuantity = this._charNuggetsQuantity - this._itemsToRecycle[_loc4_].charNuggetsQty;
               this._allianceNuggetsQuantity = this._allianceNuggetsQuantity - this._itemsToRecycle[_loc4_].allianceNuggetsQty;
               this.sysApi.log(2,"Modif 1 ? " + this._itemsToRecycle[_loc4_].item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
               break;
            }
         }
         if(_loc3_)
         {
            _loc6_ = this.prepareItem(param1);
            this._itemsToRecycle.splice(_loc3_,1,_loc6_);
            this._charNuggetsQuantity = this._charNuggetsQuantity + _loc6_.charNuggetsQty;
            this._allianceNuggetsQuantity = this._allianceNuggetsQuantity + _loc6_.allianceNuggetsQty;
            this.sysApi.log(2,"Modif 1 ? " + _loc6_.item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
            this.storageApi.addItemMask(param1.objectUID,"exchange",param1.quantity);
            this.updateGrid();
         }
      }
      
      private function onExchangeObjectListModified(param1:Object, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:ItemWrapper = null;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         for each(_loc4_ in param1)
         {
            for(_loc5_ in this._itemsToRecycle)
            {
               if(this._itemsToRecycle[_loc5_].item.objectUID == _loc4_.objectUID)
               {
                  _loc3_ = _loc5_;
                  _loc6_ = this.averagePricesApi.getItemAveragePrice(_loc4_.objectGID);
                  this._estimatedItemsPrice = this._estimatedItemsPrice - _loc6_ * this._itemsToRecycle[_loc5_].item.quantity;
                  this._estimatedItemsPrice = this._estimatedItemsPrice + _loc6_ * _loc4_.quantity;
                  this._charNuggetsQuantity = this._charNuggetsQuantity - this._itemsToRecycle[_loc5_].charNuggetsQty;
                  this._allianceNuggetsQuantity = this._allianceNuggetsQuantity - this._itemsToRecycle[_loc5_].allianceNuggetsQty;
                  this.sysApi.log(2,"Modif ? " + this._itemsToRecycle[_loc5_].item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
                  break;
               }
            }
            if(_loc3_)
            {
               _loc7_ = this.prepareItem(_loc4_);
               this._itemsToRecycle.splice(_loc3_,1,_loc7_);
               this._charNuggetsQuantity = this._charNuggetsQuantity + _loc7_.charNuggetsQty;
               this._allianceNuggetsQuantity = this._allianceNuggetsQuantity + _loc7_.allianceNuggetsQty;
               this.sysApi.log(2,"Modif ? " + _loc7_.item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
               this.storageApi.addItemMask(_loc4_.objectUID,"exchange",_loc4_.quantity);
            }
         }
         this.updateGrid();
      }
      
      private function onExchangeObjectRemoved(param1:int, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
         for(_loc4_ in this._itemsToRecycle)
         {
            if(this._itemsToRecycle[_loc4_].item.objectUID == param1)
            {
               _loc3_ = _loc4_;
               this._estimatedItemsPrice = this._estimatedItemsPrice - this.averagePricesApi.getItemAveragePrice(this._itemsToRecycle[_loc4_].item.objectGID) * this._itemsToRecycle[_loc4_].item.quantity;
               this._charNuggetsQuantity = this._charNuggetsQuantity - this._itemsToRecycle[_loc4_].charNuggetsQty;
               this._allianceNuggetsQuantity = this._allianceNuggetsQuantity - this._itemsToRecycle[_loc4_].allianceNuggetsQty;
               this.sysApi.log(2,"Removing 1 " + this._itemsToRecycle[_loc4_].item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
               break;
            }
         }
         if(_loc3_)
         {
            this._itemsToRecycle.splice(_loc3_,1);
            this.storageApi.removeItemMask(param1,"exchange");
            this.updateGrid();
         }
      }
      
      private function onExchangeObjectListRemoved(param1:Object, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:* = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
         for each(_loc3_ in param1)
         {
            for(_loc5_ in this._itemsToRecycle)
            {
               if(this._itemsToRecycle[_loc5_].item.objectUID == _loc3_)
               {
                  _loc4_ = _loc5_;
                  this._estimatedItemsPrice = this._estimatedItemsPrice - this.averagePricesApi.getItemAveragePrice(this._itemsToRecycle[_loc5_].item.objectGID) * this._itemsToRecycle[_loc5_].item.quantity;
                  this._charNuggetsQuantity = this._charNuggetsQuantity - this._itemsToRecycle[_loc5_].charNuggetsQty;
                  this._allianceNuggetsQuantity = this._allianceNuggetsQuantity - this._itemsToRecycle[_loc5_].allianceNuggetsQty;
                  this.sysApi.log(2,"Removing " + this._itemsToRecycle[_loc5_].item.name + "_estimatedItemsPrice=" + this._estimatedItemsPrice + "_charNuggetsQuantity=" + this._charNuggetsQuantity + "_allianceNuggetsQuantity=" + this._allianceNuggetsQuantity);
                  break;
               }
            }
            if(_loc4_)
            {
               this._itemsToRecycle.splice(_loc4_,1);
               this.storageApi.removeItemMask(_loc3_,"exchange");
            }
         }
         this.updateGrid();
      }
      
      private function onExchangeLeave(param1:Boolean) : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
