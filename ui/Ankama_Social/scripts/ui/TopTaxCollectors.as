package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ShortcutHookListEnum;
   import flash.utils.Dictionary;
   
   public class TopTaxCollectors
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var chatApi:ChatApi;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_dungeonTaxCollectors:ButtonContainer;
      
      public var btn_taxCollectors:ButtonContainer;
      
      public var gd_taxCollectors:Grid;
      
      public var lbl_sortGuild:Label;
      
      public var btn_sortGuild:ButtonContainer;
      
      public var lbl_sortEstimatedValue:Label;
      
      public var btn_sortEstimatedValue:ButtonContainer;
      
      public var lbl_sortSubArea:Label;
      
      public var btn_sortSubArea:ButtonContainer;
      
      public var lbl_sortCoordinates:Label;
      
      public var btn_sortCoordinates:ButtonContainer;
      
      private var _dungeonTopTaxCollectors:Array;
      
      private var _topTaxCollectors:Array;
      
      private var _currentDataProvider:Array;
      
      private var _sortFieldAssoc:Dictionary;
      
      private var _ascendingSort:Boolean;
      
      private var _lastSortType:String;
      
      public function TopTaxCollectors()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._dungeonTopTaxCollectors = this.createDataProvider(param1.dungeonTopTaxCollectors);
         this._topTaxCollectors = this.createDataProvider(param1.topTaxCollectors);
         this._sortFieldAssoc = new Dictionary();
         this._sortFieldAssoc[this.btn_sortGuild] = "guildName";
         this._sortFieldAssoc[this.btn_sortEstimatedValue] = "estimatedValue";
         this._sortFieldAssoc[this.btn_sortSubArea] = "location";
         this.lbl_title.text = this.uiApi.getText("ui.social.topTaxCollectors");
         this.btn_dungeonTaxCollectors.selected = true;
         this.gd_taxCollectors.dataProvider = this._currentDataProvider = this._dungeonTopTaxCollectors;
         this.sortDataByEstimatedValueDESC();
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onCloseUi);
      }
      
      public function updateItemLine(param1:Object, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_taxCollectorGuild.text = param1.guildLink;
            param2.lbl_taxCollectorEstimatedValue.text = this.utilApi.kamasToString(param1.estimatedValue,"");
            param2.lbl_taxCollectorSubArea.text = param1.location;
            param2.lbl_taxCollectorCoordinates.text = param1.coordsLink;
            param2.tx_estimatedValue.visible = true;
         }
         else
         {
            param2.lbl_taxCollectorGuild.text = "";
            param2.lbl_taxCollectorEstimatedValue.text = "";
            param2.lbl_taxCollectorSubArea.text = "";
            param2.lbl_taxCollectorCoordinates.text = "";
            param2.tx_estimatedValue.visible = false;
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
            case this.btn_dungeonTaxCollectors:
               this.gd_taxCollectors.dataProvider = this._currentDataProvider = this._dungeonTopTaxCollectors;
               this.sortDataByEstimatedValueDESC();
               this._lastSortType = "estimatedValue";
               break;
            case this.btn_taxCollectors:
               this.gd_taxCollectors.dataProvider = this._currentDataProvider = this._topTaxCollectors;
               this.sortDataByEstimatedValueDESC();
               this._lastSortType = "estimatedValue";
               break;
            case this.btn_sortGuild:
            case this.btn_sortEstimatedValue:
            case this.btn_sortSubArea:
               _loc2_ = this._sortFieldAssoc[param1];
               this._ascendingSort = _loc2_ != this._lastSortType?true:!this._ascendingSort;
               this.gd_taxCollectors.dataProvider = this.utilApi.sort(this.gd_taxCollectors.dataProvider,_loc2_,this._ascendingSort,_loc2_ == "estimatedValue");
               this._lastSortType = _loc2_;
               break;
            case this.btn_sortCoordinates:
               _loc2_ = "coords";
               this._ascendingSort = _loc2_ != this._lastSortType?true:!this._ascendingSort;
               this.gd_taxCollectors.dataProvider = !!this._ascendingSort?this._currentDataProvider.sort(this.sortDataByCoordinates):this._currentDataProvider.sort(this.sortDataByCoordinates,Array.DESCENDING);
               this._lastSortType = "coords";
         }
      }
      
      public function onCloseUi(param1:String) : Boolean
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
         return true;
      }
      
      private function createDataProvider(param1:Object) : Array
      {
         var _loc3_:TaxCollectorWrapper = null;
         var _loc4_:Object = null;
         var _loc5_:SubArea = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc5_ = this.dataApi.getSubArea(_loc3_.subareaId);
            _loc4_ = {
               "guildName":_loc3_.guild.guildName,
               "guildLink":this.chatApi.getGuildLink(_loc3_.guild,_loc3_.guild.guildName),
               "estimatedValue":_loc3_.itemsValue + _loc3_.kamas,
               "location":_loc5_.area.name + " - " + _loc5_.name,
               "coordX":_loc3_.mapWorldX,
               "coordY":_loc3_.mapWorldY,
               "coordsLink":"({taxcollectorPosition," + _loc3_.mapWorldX + "," + _loc3_.mapWorldY + "," + _loc5_.worldmap.id + "," + _loc3_.uniqueId + "::" + _loc3_.mapWorldX + "," + _loc3_.mapWorldY + "})"
            };
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function sortDataByEstimatedValueDESC() : void
      {
         this.gd_taxCollectors.dataProvider = this.utilApi.sort(this.gd_taxCollectors.dataProvider,"estimatedValue",false,true);
         this._ascendingSort = false;
      }
      
      private function sortDataByCoordinates(param1:Object, param2:Object) : int
      {
         var _loc3_:int = 0;
         if(param1.coordX < param2.coordX)
         {
            _loc3_ = -1;
         }
         else if(param1.coordX > param2.coordX)
         {
            _loc3_ = 1;
         }
         else if(param1.coordY < param2.coordY)
         {
            _loc3_ = -1;
         }
         else if(param1.coordY > param2.coordY)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
   }
}
