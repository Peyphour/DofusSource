package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.quest.treasureHunt.LegendaryTreasureHunt;
   import com.ankamagames.dofus.internalDatacenter.items.QuantifiedItemWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.TreasureHuntLegendaryRequest;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.TreasureHuntTypeEnum;
   import d2hooks.TreasureHuntUpdate;
   
   public class LegendaryHunts
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var jobsApi:JobsApi;
      
      public var inventoryApi:InventoryApi;
      
      public var utilApi:UtilApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _hunts:Array;
      
      private var _availableHunts:Array;
      
      private var _showAll:Boolean = true;
      
      private var _selectedHunt:LegendaryTreasureHunt;
      
      private var _mapItem:QuantifiedItemWrapper;
      
      public var btn_close:ButtonContainer;
      
      public var gd_hunts:Grid;
      
      public var btn_showAll:ButtonContainer;
      
      public var lbl_name:Label;
      
      public var lbl_level:Label;
      
      public var ed_monster:EntityDisplayer;
      
      public var lbl_monsterName:Label;
      
      public var lbl_rewardXp:Label;
      
      public var tx_rewardChest:Texture;
      
      public var lbl_mapRecap:Label;
      
      public var gd_mapPieces:Grid;
      
      public var slot_map:Slot;
      
      public var ctr_map:GraphicContainer;
      
      public var tx_craftMap:Texture;
      
      public var btn_start:ButtonContainer;
      
      public function LegendaryHunts()
      {
         this._hunts = new Array();
         this._availableHunts = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:LegendaryTreasureHunt = null;
         var _loc4_:int = 0;
         this.sysApi.addHook(TreasureHuntUpdate,this.onTreasureHunt);
         this.uiApi.addComponentHook(this.gd_hunts,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_showAll,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.gd_mapPieces,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_mapPieces,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_mapPieces,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_craftMap,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_craftMap,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_map,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.slot_map,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_map,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.btn_showAll.selected = this._showAll;
         this.ed_monster.setAnimationAndDirection("AnimArtwork",1);
         this.ed_monster.view = "turnstart";
         if(param1)
         {
            for each(_loc4_ in param1)
            {
               this._availableHunts.push(_loc4_);
            }
         }
         var _loc2_:Object = this.dataApi.getLegendaryTreasureHunts();
         for each(_loc3_ in _loc2_)
         {
            this._hunts.push(_loc3_);
         }
         this.refreshList();
      }
      
      public function unload() : void
      {
      }
      
      public function updateLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_name.text = param1.name;
            if(this._showAll && param1.id != 0 && this._availableHunts.indexOf(param1.id) == -1)
            {
               param2.lbl_name.cssClass = "disabled";
            }
            else
            {
               param2.lbl_name.cssClass = "p";
            }
            param2.btn_hunt.selected = param3;
            param2.btn_hunt.visible = true;
         }
         else
         {
            param2.lbl_name.text = "";
            param2.btn_hunt.selected = false;
            param2.btn_hunt.visible = false;
         }
      }
      
      private function displayHunt() : void
      {
         var _loc3_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:QuantifiedItemWrapper = null;
         var _loc8_:int = 0;
         this.sysApi.log(2,"go " + this._selectedHunt.id);
         this.lbl_name.text = this._selectedHunt.name;
         this.lbl_level.text = this.uiApi.getText("ui.common.short.level") + " " + this._selectedHunt.level;
         if(this._selectedHunt.monster)
         {
            this.lbl_monsterName.text = "{chatmonster," + this._selectedHunt.monster.id + "::[" + this._selectedHunt.monster.name + "]}";
            this.ed_monster.look = this._selectedHunt.monster.look;
         }
         this.lbl_rewardXp.text = this.utilApi.kamasToString(this._selectedHunt.experienceReward,"");
         var _loc1_:Item = this.dataApi.getItem(this._selectedHunt.chestId);
         if(_loc1_)
         {
            this.tx_rewardChest.uri = this.uiApi.createUri(this.uiApi.me().getConstant("item_path") + _loc1_.iconId + ".swf");
         }
         this._mapItem = this.inventoryApi.getQuantifiedItemByGIDInInventoryOrMakeUpOne(this._selectedHunt.mapItemId);
         this.slot_map.data = this._mapItem;
         var _loc2_:Recipe = this.jobsApi.getRecipe(this._selectedHunt.mapItemId);
         var _loc4_:int = 0;
         var _loc5_:Array = new Array();
         if(_loc2_)
         {
            _loc6_ = _loc2_.ingredients;
            _loc3_ = _loc6_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc3_)
            {
               _loc7_ = this.inventoryApi.getQuantifiedItemByGIDInInventoryOrMakeUpOne(_loc6_[_loc8_].id);
               _loc5_.push(_loc7_);
               if(_loc7_.quantity > 0)
               {
                  _loc4_++;
               }
               _loc8_++;
            }
            this.gd_mapPieces.width = _loc3_ * 46 + 2;
            this.gd_mapPieces.dataProvider = _loc5_;
         }
         this.lbl_mapRecap.text = this.uiApi.processText(this.uiApi.getText("ui.treasureHunt.pieces",_loc4_,_loc3_),"",_loc4_ <= 1);
         this.ctr_map.x = this.gd_mapPieces.x + this.gd_mapPieces.width + 4;
         if(this._availableHunts.indexOf(this._selectedHunt.id) == -1)
         {
            this.btn_start.disabled = true;
         }
         else
         {
            this.btn_start.disabled = false;
         }
      }
      
      private function refreshList() : void
      {
         var _loc1_:Array = null;
         var _loc2_:LegendaryTreasureHunt = null;
         if(this._showAll)
         {
            this.gd_hunts.dataProvider = this._hunts;
         }
         else
         {
            _loc1_ = new Array();
            for each(_loc2_ in this._hunts)
            {
               if(_loc2_ && this._availableHunts.indexOf(_loc2_.id) > -1)
               {
                  _loc1_.push(_loc2_);
               }
            }
            this.gd_hunts.dataProvider = _loc1_;
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.modContextMenu.createContextMenu(this.menuApi.create(param2.data,"item"));
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         if(param1.data)
         {
            this.modContextMenu.createContextMenu(this.menuApi.create(param1.data,"item"));
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_showAll:
               this._showAll = this.btn_showAll.selected;
               this.refreshList();
               break;
            case this.btn_start:
               this.onPopupValid();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         switch(param1)
         {
            case this.slot_map:
               if(param1.data)
               {
                  this.uiApi.showTooltip(param1.data,param1,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,0,"itemName",null,{
                     "showEffects":true,
                     "header":true
                  },"ItemInfo");
               }
               break;
            case this.tx_craftMap:
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.treasureHunt.craftMap")),param1,false,"standard",6,2,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(!param2.data)
         {
            return;
         }
         this.uiApi.showTooltip(param2.data,param1,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,0,"itemName",null,{
            "showEffects":true,
            "header":true
         },"ItemInfo");
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
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
         return true;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.gd_hunts)
         {
            this._selectedHunt = param1.selectedItem;
            this.displayHunt();
         }
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupValid() : void
      {
         if(!this._selectedHunt)
         {
            return;
         }
         this.sysApi.sendAction(new TreasureHuntLegendaryRequest(this._selectedHunt.id));
      }
      
      private function onTreasureHunt(param1:uint) : void
      {
         if(param1 == TreasureHuntTypeEnum.TREASURE_HUNT_LEGENDARY)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
   }
}
