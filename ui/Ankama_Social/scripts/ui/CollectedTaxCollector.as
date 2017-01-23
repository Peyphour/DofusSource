package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.ShortcutHookListEnum;
   import flash.utils.Dictionary;
   
   public class CollectedTaxCollector
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var socialApi:SocialApi;
      
      public var menuApi:ContextMenuApi;
      
      public var tooltipApi:TooltipApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var ed_pony:EntityDisplayer;
      
      public var lbl_taxCollector_name:Label;
      
      public var lbl_taxCollector_localisation:Label;
      
      public var lbl_taxCollector_xp_text:Label;
      
      public var lbl_taxCollector_xp_value:Label;
      
      public var lbl_totalEstimatedKamas_text:Label;
      
      public var lbl_totalEstimatedKamas_value:Label;
      
      public var lbl_totalPods_value:Label;
      
      public var lbl_taxCollectorOwner_value:Label;
      
      public var btn_sortItemName:ButtonContainer;
      
      public var btn_sortItemQuantity:ButtonContainer;
      
      public var btn_sortEstimatedKamas:ButtonContainer;
      
      public var gd_items:Grid;
      
      private var _collectedTaxCollector:Object;
      
      private var _ascendingSort:Boolean;
      
      private var _sortFieldAssoc:Dictionary;
      
      private var _lastSortType:String;
      
      protected var _componentsList:Dictionary;
      
      public function CollectedTaxCollector()
      {
         this._sortFieldAssoc = new Dictionary();
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         this._collectedTaxCollector = param1;
         var _loc2_:GuildWrapper = this.socialApi.getGuild();
         if(_loc2_)
         {
            _loc8_ = "{714|";
            _loc8_ = _loc8_ + (this.dataApi.getEmblemSymbol(_loc2_.upEmblem.idEmblem).skinId + "|");
            _loc8_ = _loc8_ + ("7=" + _loc2_.backEmblem.color + ",8=" + _loc2_.upEmblem.color + "|110}");
            this.ed_pony.look = this.sysApi.getEntityLookFromString(_loc8_);
         }
         this.lbl_taxCollector_name.text = this._collectedTaxCollector.firstName + " " + this._collectedTaxCollector.lastName;
         var _loc3_:SubArea = this.dataApi.getSubArea(this._collectedTaxCollector.subareaId);
         this.lbl_taxCollector_localisation.text = _loc3_.name + " ({taxcollectorPosition," + this._collectedTaxCollector.mapWorldX + "," + this._collectedTaxCollector.mapWorldY + "," + _loc3_.worldmap.id + "," + this._collectedTaxCollector.uniqueId + "::" + this._collectedTaxCollector.mapWorldX + "," + this._collectedTaxCollector.mapWorldY + "})";
         this.lbl_taxCollector_xp_text.text = this.uiApi.getText("ui.common.experiencePoint") + " " + this.uiApi.getText("ui.common.colon");
         this.lbl_taxCollector_xp_value.text = this.utilApi.kamasToString(this._collectedTaxCollector.experience,"");
         var _loc4_:Array = new Array();
         var _loc5_:uint = 0;
         for each(_loc6_ in this._collectedTaxCollector.collectedItems)
         {
            _loc7_ = new Object();
            _loc7_.item = this.dataApi.getItemWrapper(_loc6_.objectGID,0,0,_loc6_.quantity);
            _loc7_.itemName = _loc7_.item.name;
            _loc7_.itemQuantity = _loc7_.item.quantity;
            _loc7_.averagePrice = this.averagePricesApi.getItemAveragePrice(_loc6_.objectGID) * _loc6_.quantity;
            _loc4_.push(_loc7_);
            _loc5_ = _loc5_ + _loc7_.averagePrice;
         }
         this.gd_items.dataProvider = _loc4_;
         this.lbl_totalEstimatedKamas_text.text = this.uiApi.getText("ui.exchange.estimatedValue") + " " + this.uiApi.getText("ui.common.colon");
         this.lbl_totalEstimatedKamas_value.text = this.utilApi.kamasToString(_loc5_,"K");
         this.lbl_totalPods_value.text = this.utilApi.kamasToString(this._collectedTaxCollector.pods,"");
         this.lbl_taxCollectorOwner_value.text = "{player," + this._collectedTaxCollector.callerName + "," + this._collectedTaxCollector.callerId + "}";
         this._sortFieldAssoc[this.btn_sortItemName] = "itemName";
         this._sortFieldAssoc[this.btn_sortItemQuantity] = "itemQuantity";
         this._sortFieldAssoc[this.btn_sortEstimatedKamas] = "averagePrice";
         this._ascendingSort = true;
         this._lastSortType = "averagePrice";
         this.onRelease(this.btn_sortEstimatedKamas);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onCloseUi);
      }
      
      public function updateItemLine(param1:Object, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.slot_item.name])
         {
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.slot_item.name] = param1;
         if(param1)
         {
            param2.slot_item.data = param1.item;
            param2.lbl_item_name.text = "{item," + param1.item.objectGID + "::" + param1.itemName + "}";
            param2.lbl_item_quantity.text = param1.itemQuantity;
            param2.lbl_estimated_kamas.text = this.utilApi.kamasToString(param1.averagePrice,"");
         }
         else
         {
            param2.slot_item.data = null;
            param2.lbl_item_name.text = "";
            param2.lbl_item_quantity.text = "";
            param2.lbl_estimated_kamas.text = "";
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_close:
               this.onCloseUi(null);
               break;
            case this.btn_sortItemName:
            case this.btn_sortItemQuantity:
            case this.btn_sortEstimatedKamas:
               _loc2_ = this._sortFieldAssoc[param1];
               this._ascendingSort = _loc2_ != this._lastSortType?true:!this._ascendingSort;
               this.gd_items.dataProvider = this.utilApi.sort(this.gd_items.dataProvider,_loc2_,this._ascendingSort,_loc2_ != "itemName");
               this._lastSortType = _loc2_;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:ItemTooltipSettings = null;
         if(param1.name.indexOf("slot_") != -1)
         {
            _loc2_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
            if(_loc2_ == null)
            {
               _loc2_ = this.tooltipApi.createItemSettings();
               this.sysApi.setData("itemTooltipSettings",_loc2_,DataStoreEnum.BIND_ACCOUNT);
            }
            this.uiApi.showTooltip(param1.data,param1,false,"standard",3,3,0,null,null,_loc2_);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.name.indexOf("slot_") != -1)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      public function onCloseUi(param1:String) : Boolean
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
         return true;
      }
   }
}
