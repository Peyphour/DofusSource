package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.ItemSet;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.SetUpdate;
   
   public class ItemsSet
   {
       
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var menuApi:ContextMenuApi;
      
      public var dataApi:DataApi;
      
      public var inventoryApi:InventoryApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _set:ItemSet;
      
      private var _serverSet:Object;
      
      private var _items:Array;
      
      private var _selectedItems:Array;
      
      private var _filterType:int = -1;
      
      private var _nbItemsToDisplay:int;
      
      public var gd_bonus:Grid;
      
      public var cb_filter:ComboBox;
      
      public var btn_close:ButtonContainer;
      
      public var btn_bonusObjects:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var slot_0:Slot;
      
      public var slot_1:Slot;
      
      public var slot_2:Slot;
      
      public var slot_3:Slot;
      
      public var slot_4:Slot;
      
      public var slot_5:Slot;
      
      public var slot_6:Slot;
      
      public var slot_7:Slot;
      
      public var tx_itemEquipped_0:Texture;
      
      public var tx_itemEquipped_1:Texture;
      
      public var tx_itemEquipped_2:Texture;
      
      public var tx_itemEquipped_3:Texture;
      
      public var tx_itemEquipped_4:Texture;
      
      public var tx_itemEquipped_5:Texture;
      
      public var tx_itemEquipped_6:Texture;
      
      public var tx_itemEquipped_7:Texture;
      
      public function ItemsSet()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.sysApi.addHook(SetUpdate,this.onSetUpdate);
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_bonusObjects,"onRelease");
         this.uiApi.addComponentHook(this.btn_bonusObjects,"onRollOver");
         this.uiApi.addComponentHook(this.btn_bonusObjects,"onRollOut");
         this.uiApi.addComponentHook(this.cb_filter,"onSelectItem");
         this.uiApi.addComponentHook(this.tx_itemEquipped_0,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_0,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_1,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_1,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_2,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_2,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_3,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_3,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_4,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_4,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_5,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_5,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_6,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_6,"onRollOut");
         this.uiApi.addComponentHook(this.tx_itemEquipped_7,"onRollOver");
         this.uiApi.addComponentHook(this.tx_itemEquipped_7,"onRollOut");
         this.uiApi.addComponentHook(this.slot_0,"onRelease");
         this.uiApi.addComponentHook(this.slot_1,"onRelease");
         this.uiApi.addComponentHook(this.slot_2,"onRelease");
         this.uiApi.addComponentHook(this.slot_3,"onRelease");
         this.uiApi.addComponentHook(this.slot_4,"onRelease");
         this.uiApi.addComponentHook(this.slot_5,"onRelease");
         this.uiApi.addComponentHook(this.slot_6,"onRelease");
         this.uiApi.addComponentHook(this.slot_7,"onRelease");
         this.displaySet(this.dataApi.getItem(param1.item.objectGID).itemSetId);
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("itemBoxSet");
      }
      
      public function updateEffectLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:String = null;
         if(param1)
         {
            _loc4_ = "p";
            if(param1.indexOf("-") == 0)
            {
               _loc4_ = "malus";
            }
            param2.lbl_effect.cssClass = _loc4_;
            param2.lbl_effect.text = param1;
         }
         else
         {
            param2.lbl_effect.text = "";
         }
      }
      
      private function displaySet(param1:int) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         this._items = new Array();
         this._selectedItems = [-1,-1,-1,-1,-1,-1,-1,-1];
         this._set = this.dataApi.getItemSet(param1);
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.playerApi.getEquipment())
         {
            for each(_loc9_ in this._set.items)
            {
               if(_loc9_ == _loc3_.objectGID)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         if(_loc2_.length > 0)
         {
            this._serverSet = this.playerApi.getPlayerSet(_loc2_[0].objectGID);
         }
         if(this._serverSet != null)
         {
            _loc4_ = this._serverSet.setName;
            for each(_loc10_ in this._serverSet.allItems)
            {
               this._items.push(_loc10_);
            }
         }
         else
         {
            _loc4_ = this._set.name;
            for each(_loc11_ in this._set.items)
            {
               this._items.push(_loc11_);
            }
         }
         this.lbl_title.text = _loc4_;
         _loc5_ = this._items.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.uiApi.addComponentHook(this["slot_" + _loc6_],"onRollOver");
            this.uiApi.addComponentHook(this["slot_" + _loc6_],"onRollOut");
            this.uiApi.addComponentHook(this["slot_" + _loc6_],"onRightClick");
            this.uiApi.addComponentHook(this["slot_" + _loc6_],"onRelease");
            this["slot_" + _loc6_].data = this.dataApi.getItemWrapper(this._items[_loc6_]);
            this["tx_itemEquipped_" + _loc6_].visible = false;
            for each(_loc12_ in _loc2_)
            {
               if(_loc12_.objectGID == this._items[_loc6_])
               {
                  this["tx_itemEquipped_" + _loc6_].visible = true;
                  this._selectedItems[_loc6_] = _loc12_.objectGID;
                  this["slot_" + _loc6_].data = this.inventoryApi.getItem(_loc12_.objectUID);
               }
            }
            _loc6_++;
         }
         _loc6_ = _loc6_;
         while(_loc6_ < 8)
         {
            this["slot_" + _loc6_].data = null;
            _loc6_++;
         }
         var _loc7_:Array = new Array();
         var _loc8_:int = 1;
         while(_loc8_ <= _loc5_)
         {
            _loc7_.push({
               "label":_loc8_ + " " + this.uiApi.getText("ui.common.objects"),
               "filterType":_loc8_
            });
            _loc8_++;
         }
         this.cb_filter.dataProvider = _loc7_;
         if(_loc2_.length > 0)
         {
            this.cb_filter.selectedIndex = _loc2_.length - 1;
         }
         else
         {
            this.cb_filter.selectedIndex = _loc5_ - 1;
         }
      }
      
      private function filteredBonus(param1:Boolean = false) : Array
      {
         var _loc5_:EffectInstance = null;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:EffectInstance = null;
         var _loc10_:Array = null;
         var _loc11_:* = undefined;
         var _loc2_:Array = new Array();
         if(this._serverSet)
         {
            if(this._serverSet.setObjects.length == this._filterType)
            {
               for each(_loc6_ in this._serverSet.setEffects)
               {
                  _loc2_.push(_loc6_);
               }
            }
         }
         if(_loc2_.length == 0)
         {
            if(this._set.bonusIsSecret)
            {
               this.sysApi.log(16,"The set bonuses are secrets when this feature is supposed not to be used anymore.");
            }
            else
            {
               _loc7_ = 1;
               for each(_loc8_ in this._set.effects)
               {
                  if(_loc7_ == this._filterType)
                  {
                     if(_loc8_ != null)
                     {
                        for each(_loc9_ in _loc8_)
                        {
                           if(_loc9_ != null)
                           {
                              _loc2_.push(_loc9_);
                           }
                        }
                     }
                  }
                  _loc7_++;
               }
            }
         }
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         if(param1)
         {
            _loc10_ = new Array();
            for each(_loc11_ in this._selectedItems)
            {
               if(_loc11_ != -1)
               {
                  _loc10_.push(_loc11_);
               }
            }
            for each(_loc5_ in this.dataApi.getSetEffects(_loc10_,_loc2_))
            {
               _loc4_.push(_loc5_);
            }
            _loc4_.sortOn("order",Array.NUMERIC);
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.description && _loc5_.description != "")
               {
                  _loc3_.push(_loc5_.description);
               }
            }
         }
         else
         {
            _loc2_.sortOn("order",Array.NUMERIC);
            for each(_loc5_ in _loc2_)
            {
               if(_loc5_ && _loc5_.description && _loc5_.description != "")
               {
                  _loc3_.push(_loc5_.description);
               }
            }
         }
         return _loc3_;
      }
      
      private function switchObjectsMode(param1:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:uint = 0;
         if(param1)
         {
            this.cb_filter.disabled = true;
            _loc3_ = 0;
            while(_loc3_ < 8)
            {
               if(this["tx_itemEquipped_" + _loc3_].visible || this._selectedItems[_loc3_] && this._selectedItems[_loc3_] != -1)
               {
                  this["slot_" + _loc3_].selected = true;
                  this._selectedItems[_loc3_] = this._items[_loc3_];
                  _loc2_++;
               }
               else
               {
                  this._selectedItems[_loc3_] = -1;
                  this["slot_" + _loc3_].selected = false;
               }
               _loc3_++;
            }
            this._filterType = _loc2_;
            this.cb_filter.selectedIndex = _loc2_ - 1;
            this.gd_bonus.dataProvider = this.filteredBonus(true);
         }
         else
         {
            this.cb_filter.disabled = false;
            _loc4_ = 0;
            while(_loc4_ < 8)
            {
               this["slot_" + _loc4_].selected = false;
               if(this._selectedItems[_loc3_] != -1)
               {
                  _loc2_++;
               }
               _loc4_++;
            }
            this.gd_bonus.dataProvider = this.filteredBonus();
         }
      }
      
      private function onSetUpdate(param1:int) : void
      {
         if(this._set.id == param1)
         {
            this.displaySet(param1);
            if(this.btn_bonusObjects.selected)
            {
               this.switchObjectsMode(true);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(param1 == this.btn_bonusObjects)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.set.addObjectBonusText")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
         else if(param1.name.substr(0,16) == "tx_itemEquipped_")
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.set.objectEquipped")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
         else if(param1.data)
         {
            this.uiApi.showTooltip(param1.data,param1,false,"standard",8,0,3,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_bonusObjects:
               this.switchObjectsMode(this.btn_bonusObjects.selected);
               break;
            default:
               if(param1.name.substr(0,4) == "slot" && param1.data)
               {
                  if(this.btn_bonusObjects.selected)
                  {
                     _loc2_ = int(param1.name.substr(5,1));
                     if(this._selectedItems[_loc2_] == -1)
                     {
                        this.sysApi.log(2,"selection de " + param1.data.objectGID);
                        this._selectedItems[_loc2_] = param1.data.objectGID;
                        param1.selected = true;
                        this._filterType++;
                     }
                     else
                     {
                        this._selectedItems[_loc2_] = -1;
                        param1.selected = false;
                        this._filterType--;
                     }
                     this.cb_filter.selectedIndex = this._filterType >= 1?uint(this._filterType - 1):uint(-1);
                     this.gd_bonus.dataProvider = this.filteredBonus(true);
                  }
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.cb_filter && !this.cb_filter.disabled)
         {
            this._filterType = this.cb_filter.value.filterType;
            this.gd_bonus.dataProvider = this.filteredBonus();
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.data)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
   }
}
