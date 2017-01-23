package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.DecraftedItemStackInfo;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.CloseInventory;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeReady;
   import d2actions.ExchangeReadyCrush;
   import d2actions.ExchangeRefuse;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.DecraftResult;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeObjectAdded;
   import d2hooks.ExchangeObjectListAdded;
   import d2hooks.ExchangeObjectListModified;
   import d2hooks.ExchangeObjectListRemoved;
   import d2hooks.ExchangeObjectModified;
   import d2hooks.ExchangeObjectRemoved;
   import d2hooks.ShowObjectLinked;
   import flash.utils.Dictionary;
   
   public class RuneMaker
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
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var btn_close:ButtonContainer;
      
      public var runeMakerWindow:GraphicContainer;
      
      public var tx_background:Texture;
      
      public var lbl_subTitle:Label;
      
      public var ctr_content:GraphicContainer;
      
      public var gd_items:Grid;
      
      public var ctr_result:GraphicContainer;
      
      public var gd_results:Grid;
      
      public var lbl_itemsPrice:Label;
      
      public var lbl_runesPrice:Label;
      
      public var lbl_quantityObject:Label;
      
      public var btn_info:ButtonContainer;
      
      public var btn_crush:ButtonContainer;
      
      public var btn_lbl_btn_crush:Label;
      
      public var ctr_runes:GraphicContainer;
      
      public var gd_runes:Grid;
      
      public var lbl_runes:Label;
      
      public var btn_closeRunes:ButtonContainer;
      
      public var ctr_focus:GraphicContainer;
      
      public var cb_effectFocus:ComboBox;
      
      private const _actionIdEligibleRune:Array = [111,112,115,117,118,119,123,124,125,126,128,138,158,160,161,174,176,178,182,210,211,212,213,214,220,225,226,240,241,242,243,244,410,412,414,416,418,420,422,424,426,428,430,752,753];
      
      private var _itemsToCrush:Array;
      
      private var _decraftedItems:Array;
      
      private var _currentState:int = 0;
      
      private var _widthBgState0:int;
      
      private var _widthBgState1:int;
      
      private var _item:Object;
      
      private var _compInteractiveList:Dictionary;
      
      private var _runesLists:Dictionary;
      
      private var _UIDItemForRunesWindow:uint;
      
      public function RuneMaker()
      {
         this._itemsToCrush = new Array();
         this._decraftedItems = new Array();
         this._compInteractiveList = new Dictionary(true);
         this._runesLists = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.disableWorldInteraction(false);
         this.sysApi.addHook(ExchangeObjectModified,this.onExchangeObjectModified);
         this.sysApi.addHook(ExchangeObjectAdded,this.onExchangeObjectAdded);
         this.sysApi.addHook(ExchangeObjectRemoved,this.onExchangeObjectRemoved);
         this.sysApi.addHook(DoubleClickItemInventory,this.onDoubleClickItemInventory);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(ExchangeObjectListAdded,this.onExchangeObjectListAdded);
         this.sysApi.addHook(ExchangeObjectListModified,this.onExchangeObjectListModified);
         this.sysApi.addHook(ExchangeObjectListRemoved,this.onExchangeObjectListRemoved);
         this.sysApi.addHook(DecraftResult,this.onDecraftResult);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_info,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_info,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_runes,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_runes,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.gd_runes,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_runes,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.gd_items.autoSelectMode = 0;
         this.gd_items.dropValidator = this.dropValidatorFunction as Function;
         this.gd_items.processDrop = this.processDropFunction as Function;
         this.gd_items.removeDropSource = this.removeDropSourceFunction as Function;
         this.gd_items.mouseEnabled = true;
         this.gd_items.dataProvider = new Array();
         this._widthBgState0 = int(this.uiApi.me().getConstant("bg_width_state0"));
         this._widthBgState1 = int(this.uiApi.me().getConstant("bg_width_state1"));
         this.ctr_runes.visible = false;
         this.btn_crush.disabled = true;
         this.cb_effectFocus.disabled = true;
         this.cb_effectFocus.dataProvider = [{
            "label":this.uiApi.getText("ui.crush.noFocus"),
            "actionId":0
         }];
         this.cb_effectFocus.selectedIndex = 0;
         this.updateUI(false);
         this.sysApi.disableWorldInteraction();
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
         var _loc4_:Item = null;
         param2.slot_item.allowDrag = true;
         param2.btn_item.removeDropSource = this.removeDropSourceFunction;
         param2.btn_item.processDrop = this.processDropFunction;
         param2.btn_item.dropValidator = this.dropValidatorFunction;
         if(!this._compInteractiveList[param2.slot_item.name])
         {
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OUT);
         }
         this._compInteractiveList[param2.slot_item.name] = param1;
         if(param1)
         {
            param2.btn_item.selected = param3;
            _loc4_ = this.dataApi.getItem(param1.objectGID);
            param2.lbl_itemName.text = param1.shortName;
            param2.slot_item.data = param1;
            param2.tx_backgroundItem.visible = true;
            if(_loc4_.etheral)
            {
               param2.lbl_itemName.cssClass = "itemetheral";
            }
            else if(_loc4_.itemSetId != -1)
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
            param2.lbl_itemName.text = "";
            param2.slot_item.data = null;
            param2.tx_backgroundItem.visible = false;
            param2.btn_item.selected = false;
         }
      }
      
      public function updateResultLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         param2.slot_item.allowDrag = false;
         if(!this._compInteractiveList[param2.slot_item.name])
         {
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OUT);
         }
         this._compInteractiveList[param2.slot_item.name] = param1;
         if(!this._compInteractiveList[param2.btn_seeMore.name])
         {
            this.uiApi.addComponentHook(param2.btn_seeMore,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_seeMore,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_seeMore,ComponentHookList.ON_ROLL_OUT);
         }
         this._compInteractiveList[param2.btn_seeMore.name] = param1;
         if(!this._compInteractiveList[param2.lbl_percent.name])
         {
            this.uiApi.addComponentHook(param2.lbl_percent,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_percent,ComponentHookList.ON_ROLL_OUT);
         }
         this._compInteractiveList[param2.lbl_percent.name] = param1;
         if(!this._compInteractiveList[param2.gd_runes.name])
         {
            this.uiApi.addComponentHook(param2.gd_runes,ComponentHookList.ON_SELECT_ITEM);
            this.uiApi.addComponentHook(param2.gd_runes,ComponentHookList.ON_ITEM_ROLL_OVER);
            this.uiApi.addComponentHook(param2.gd_runes,ComponentHookList.ON_ITEM_ROLL_OUT);
            this.uiApi.addComponentHook(param2.gd_runes,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         }
         this._compInteractiveList[param2.gd_runes.name] = param1;
         if(param1)
         {
            param2.lbl_itemName.text = param1.item.shortName;
            if(param1.item.recipeSlots == 0 && !param1.item.secretRecipe)
            {
               param2.lbl_percent.cssClass = "p4center";
            }
            else if(param1.bonusMin >= 100)
            {
               param2.lbl_percent.cssClass = "boldcenter";
            }
            else
            {
               param2.lbl_percent.cssClass = "center";
            }
            param2.lbl_percent.text = param1.bonusMin + " %";
            param2.slot_item.data = param1.item;
            param2.tx_backgroundItem.visible = true;
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
            param2.gd_runes.dataProvider = param1.runes;
            if(param1.runes.length > 6)
            {
               param2.btn_seeMore.visible = true;
               _loc4_ = "";
               for each(_loc5_ in param1.runes)
               {
                  _loc4_ = _loc4_ + (_loc5_.quantity + " x " + _loc5_.name + " \n");
               }
               this._runesLists[param1.id] = _loc4_;
            }
            else
            {
               param2.btn_seeMore.visible = false;
            }
         }
         else
         {
            param2.lbl_itemName.text = "";
            param2.lbl_percent.text = "";
            param2.slot_item.data = null;
            param2.gd_runes.dataProvider = new Array();
            param2.tx_backgroundItem.visible = false;
            param2.btn_seeMore.visible = false;
         }
      }
      
      public function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(!param2 || this._currentState == 1 || !(param2 is ItemWrapper) || (param2 as ItemWrapper).category != 0)
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
      
      private function updateUI(param1:Boolean = false) : void
      {
         if(!param1)
         {
            this._currentState = 0;
            this.lbl_subTitle.text = "";
            this.runeMakerWindow.width = this._widthBgState0;
            this.uiApi.me().render();
            this.btn_lbl_btn_crush.text = this.uiApi.getText("ui.crush.crushAll");
            this.ctr_content.visible = true;
            this.ctr_result.visible = false;
            this.ctr_runes.visible = false;
            this.ctr_focus.visible = true;
            this.gd_results.dataProvider = new Array();
         }
         else
         {
            this._currentState = 1;
            this.gd_results.dataProvider = this._decraftedItems;
            this.gd_items.dataProvider = new Array();
            this.lbl_subTitle.text = this.uiApi.getText("ui.crush.result");
            this.runeMakerWindow.width = this._widthBgState1;
            this.uiApi.me().render();
            this.btn_lbl_btn_crush.text = this.uiApi.getText("ui.crush.crushOthers");
            this.ctr_content.visible = false;
            this.ctr_result.visible = true;
            this.ctr_focus.visible = false;
         }
      }
      
      private function validateDecraft() : void
      {
         this.sysApi.sendAction(new ExchangeReady(true));
      }
      
      private function updateGrid() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Dictionary = null;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         this.storageApi.releaseHooks();
         this.gd_items.dataProvider = this._itemsToCrush;
         var _loc1_:Array = [{
            "label":this.uiApi.getText("ui.crush.noFocus"),
            "actionId":0
         }];
         if(this._itemsToCrush.length > 0)
         {
            _loc6_ = new Dictionary();
            _loc7_ = 0;
            while(_loc7_ < this._itemsToCrush.length)
            {
               _loc2_ = this._itemsToCrush[_loc7_];
               _loc3_ = _loc2_.effects;
               _loc5_ = _loc2_.possibleEffects;
               if(_loc3_)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc3_.length)
                  {
                     if(this._actionIdEligibleRune.indexOf(_loc3_[_loc11_].effectId) != -1)
                     {
                        if(!_loc6_[_loc3_[_loc11_].effectId])
                        {
                           _loc6_[_loc3_[_loc11_].effectId] = 1;
                        }
                        else
                        {
                           _loc6_[_loc3_[_loc11_].effectId]++;
                        }
                     }
                     _loc11_++;
                  }
               }
               if(_loc5_)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc5_.length)
                  {
                     if(!_loc6_[_loc5_[_loc11_].effectId])
                     {
                        _loc6_[_loc5_[_loc11_].effectId] = 1;
                     }
                     else
                     {
                        _loc6_[_loc5_[_loc11_].effectId]++;
                     }
                     _loc11_++;
                  }
               }
               _loc7_++;
            }
            for(_loc10_ in _loc6_)
            {
               if(_loc6_[_loc10_] == this._itemsToCrush.length * 2)
               {
                  _loc8_ = this.dataApi.getEffect(_loc10_);
                  if(_loc8_)
                  {
                     _loc9_ = this.dataApi.getCharacteristic(_loc8_.characteristic);
                     if(_loc9_)
                     {
                        _loc1_.push({
                           "label":_loc9_.name,
                           "actionId":_loc8_.id
                        });
                     }
                  }
               }
            }
            this.cb_effectFocus.disabled = _loc1_.length < 3;
            this.btn_crush.disabled = false;
         }
         else
         {
            this.cb_effectFocus.disabled = true;
            this.btn_crush.disabled = true;
         }
         this.cb_effectFocus.dataProvider = _loc1_;
         this.cb_effectFocus.selectedIndex = 0;
         this.lbl_quantityObject.text = this.uiApi.getText("ui.crush.distinctItems",this._itemsToCrush.length,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_DECRAFT);
      }
      
      private function compareItemsAveragePrices(param1:Object, param2:Object) : int
      {
         var _loc3_:int = this.averagePricesApi.getItemAveragePrice(param1.objectGID) * param1.quantity;
         var _loc4_:int = this.averagePricesApi.getItemAveragePrice(param2.objectGID) * param2.quantity;
         return _loc3_ < _loc4_?1:_loc3_ > _loc4_?-1:0;
      }
      
      protected function onDecraftResult(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:ItemWrapper = null;
         var _loc5_:Object = null;
         var _loc9_:ItemWrapper = null;
         var _loc10_:DecraftedItemStackInfo = null;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         for each(_loc9_ in this._itemsToCrush)
         {
            for each(_loc10_ in param1)
            {
               if(_loc9_.objectUID == _loc10_.objectUID)
               {
                  _loc2_ = new Array();
                  _loc3_ = _loc10_.runesId.length;
                  _loc11_ = 0;
                  while(_loc11_ < _loc3_)
                  {
                     if(_loc10_.runesQty[_loc11_] > 0)
                     {
                        _loc4_ = this.dataApi.getItemWrapper(_loc10_.runesId[_loc11_],0,0,_loc10_.runesQty[_loc11_]);
                        _loc2_.push(_loc4_);
                        _loc8_ = _loc8_ + this.averagePricesApi.getItemAveragePrice(_loc4_.objectGID) * _loc4_.quantity;
                     }
                     _loc11_++;
                  }
                  _loc2_.sort(this.compareItemsAveragePrices);
                  _loc12_ = _loc10_.bonusMin * 100;
                  if(_loc12_ > 0 && _loc12_ < 1)
                  {
                     _loc12_ = Math.round(_loc12_ * 100);
                     _loc12_ = _loc12_ / 100;
                  }
                  else
                  {
                     _loc12_ = Math.round(_loc12_);
                  }
                  _loc13_ = _loc10_.bonusMax * 100;
                  if(_loc13_ > 0 && _loc13_ < 1)
                  {
                     _loc13_ = Math.round(_loc13_ * 100);
                     _loc13_ = _loc13_ / 100;
                  }
                  else
                  {
                     _loc13_ = Math.round(_loc13_);
                  }
                  _loc5_ = {
                     "id":_loc6_,
                     "item":_loc9_,
                     "bonusMin":_loc12_,
                     "bonusMax":_loc13_,
                     "runes":_loc2_
                  };
                  this._decraftedItems.push(_loc5_);
                  _loc7_ = _loc7_ + this.averagePricesApi.getItemAveragePrice(_loc9_.objectGID) * _loc9_.quantity;
                  _loc6_++;
               }
            }
         }
         this.updateUI(true);
         this.lbl_itemsPrice.text = this.uiApi.getText("ui.crush.itemsEstimatedPrice") + " " + this.utilApi.kamasToString(_loc7_);
         this.lbl_runesPrice.text = this.uiApi.getText("ui.crush.runesEstimatedPrice") + " " + this.utilApi.kamasToString(_loc8_);
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(param1 == this.gd_items)
         {
            _loc4_ = this.gd_items.selectedItem;
            if(!_loc4_ || this._currentState == 1)
            {
               return;
            }
            switch(param2)
            {
               case SelectMethodEnum.DOUBLE_CLICK:
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc4_.objectUID,-1));
                  break;
               case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc4_.objectUID,-_loc4_.quantity));
                  break;
               case SelectMethodEnum.ALT_DOUBLE_CLICK:
                  this._item = _loc4_;
                  this.modCommon.openQuantityPopup(1,this._item.quantity,this._item.quantity,this.onAltValidQty);
            }
         }
         else if(param1.name.indexOf("gd_runes") != -1 || param1 == this.gd_runes)
         {
            if(!this.sysApi.getOption("displayTooltips","dofus") && (param2 == GridItemSelectMethodEnum.CLICK || param2 == GridItemSelectMethodEnum.MANUAL))
            {
               _loc5_ = param1.selectedItem;
               this.sysApi.dispatchHook(ShowObjectLinked,_loc5_);
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         switch(param1)
         {
            case this.btn_close:
               this.sysApi.sendAction(new LeaveDialogRequest());
               break;
            case this.btn_closeRunes:
               this.ctr_runes.visible = false;
               this._UIDItemForRunesWindow = 0;
               break;
            case this.btn_crush:
               if(this._currentState == 0)
               {
                  if(this._itemsToCrush.length > 0)
                  {
                     _loc2_ = 0;
                     if(this.cb_effectFocus.selectedItem)
                     {
                        _loc2_ = this.cb_effectFocus.selectedItem.actionId;
                     }
                     this.sysApi.sendAction(new ExchangeReadyCrush(true,_loc2_));
                     this.storageApi.removeAllItemMasks("exchange");
                  }
               }
               else
               {
                  this._itemsToCrush = new Array();
                  this._decraftedItems = new Array();
                  this._item = null;
                  this._runesLists = new Dictionary(true);
                  this.updateGrid();
                  this.updateUI(false);
               }
               break;
            default:
               if(param1.name.indexOf("btn_seeMore") != -1)
               {
                  _loc3_ = this._compInteractiveList[param1.name];
                  if(this.ctr_runes.visible && this._UIDItemForRunesWindow == _loc3_.item.objectUID)
                  {
                     this.ctr_runes.visible = false;
                  }
                  else
                  {
                     this.ctr_runes.visible = true;
                     this.gd_runes.dataProvider = _loc3_.runes;
                     this.lbl_runes.text = _loc3_.item.name;
                     this._UIDItemForRunesWindow = _loc3_.item.objectUID;
                  }
               }
         }
      }
      
      public function onDoubleClickItemInventory(param1:Object, param2:int = 1) : void
      {
         if(!param1 || this._currentState == 1 || (param1 as ItemWrapper).category != 0)
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
            case this.btn_info:
               _loc2_ = this.uiApi.getText("ui.crush.help");
               break;
            default:
               if(param1.name.indexOf("btn_seeMore") != -1)
               {
                  _loc2_ = this._runesLists[this._compInteractiveList[param1.name].id];
               }
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
         var _loc3_:ItemTooltipSettings = null;
         var _loc4_:* = undefined;
         if(param2.data)
         {
            _loc3_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
            if(!_loc3_)
            {
               _loc3_ = this.tooltipApi.createItemSettings();
               this.sysApi.setData("itemTooltipSettings",_loc3_,DataStoreEnum.BIND_ACCOUNT);
            }
            _loc4_ = param2.data;
            if(!_loc3_.header && !_loc3_.conditions && !_loc3_.effects && !_loc3_.description && !_loc3_.averagePrice)
            {
               _loc4_ = param2.data.name;
            }
            this.uiApi.showTooltip(param2.data,param2.container,false,"standard",7,7,0,"itemName",null,{
               "header":_loc3_.header,
               "conditions":_loc3_.conditions,
               "description":_loc3_.description,
               "averagePrice":_loc3_.averagePrice,
               "showEffects":_loc3_.effects
            },"ItemInfo");
         }
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
         this._itemsToCrush.push(param1);
         this.storageApi.addItemMask(param1.objectUID,"exchange",param1.quantity);
         this.updateGrid();
      }
      
      private function onExchangeObjectListAdded(param1:Object, param2:Object) : void
      {
         var _loc3_:ItemWrapper = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         for each(_loc3_ in param1)
         {
            this._itemsToCrush.push(_loc3_);
            this.storageApi.addItemMask(_loc3_.objectUID,"exchange",_loc3_.quantity);
         }
         this.updateGrid();
      }
      
      private function onExchangeObjectModified(param1:Object, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         for(_loc4_ in this._itemsToCrush)
         {
            if(this._itemsToCrush[_loc4_].objectUID == param1.objectUID)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(_loc3_)
         {
            this._itemsToCrush.splice(_loc3_,1,param1);
            this.storageApi.addItemMask(param1.objectUID,"exchange",param1.quantity);
            this.updateGrid();
         }
      }
      
      private function onExchangeObjectListModified(param1:Object, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:ItemWrapper = null;
         var _loc5_:* = null;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         for each(_loc4_ in param1)
         {
            for(_loc5_ in this._itemsToCrush)
            {
               if(this._itemsToCrush[_loc5_].objectUID == _loc4_.objectUID)
               {
                  _loc3_ = _loc5_;
                  break;
               }
            }
            if(_loc3_)
            {
               this._itemsToCrush.splice(_loc3_,1,_loc4_);
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
         for(_loc4_ in this._itemsToCrush)
         {
            if(this._itemsToCrush[_loc4_].objectUID == param1)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(_loc3_)
         {
            this._itemsToCrush.splice(_loc3_,1);
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
            for(_loc5_ in this._itemsToCrush)
            {
               if(this._itemsToCrush[_loc5_].objectUID == _loc3_)
               {
                  _loc4_ = _loc5_;
                  break;
               }
            }
            if(_loc4_)
            {
               this._itemsToCrush.splice(_loc4_,1);
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
