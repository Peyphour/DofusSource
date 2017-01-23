package ui
{
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.Dungeon;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.OpenBook;
   import d2actions.PrismsListRegister;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.LocationEnum;
   import d2enums.PrismListenEnum;
   import d2enums.PrismStateEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.StatesEnum;
   import d2hooks.KeyDown;
   import d2hooks.MapDisplay;
   import d2hooks.MapHintsFilter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class CartographyUi extends CartographyBase
   {
      
      private static const INTEGRATION_MODE:Boolean = false;
      
      private static var _conquestInformationsIsActive:Boolean = false;
      
      private static const HINT_SEARCH_TYPE:uint = 1;
      
      private static const HINT_GROUP_SEARCH_TYPE:uint = 5;
      
      private static const SUBAREA_SEARCH_TYPE:uint = 2;
      
      private static const MONSTER_SEARCH_TYPE:uint = 3;
      
      private static const ITEM_SEARCH_TYPE:uint = 4;
      
      private static const SEARCH_AREAS:String = "searchAreas";
      
      private static const SEARCH_AREAS_FLAGS:String = "searchAreasFlags";
      
      private static const SEARCH_HINTS:String = "searchHints";
      
      private static const RESOURCES_QUANTITY_COLOR:Array = [16642234,16573085,16566143,16493940,16417127,15293534,13519461,10766949];
      
      private static const CONQUEST_FILTERS:String = "mapFiltersConquest";
      
      private static const SEARCH_FILTERS:String = "mapFiltersSearch";
      
      private static const SORT_BY_NAME:uint = 1;
      
      private static const SORT_BY_VULNERABILITY_DATE:uint = 2;
       
      
      public var mainCtr:GraphicContainer;
      
      public var tx_help:Texture;
      
      public var tx_bg_results:TextureBitmap;
      
      public var btnFilterFlags:ButtonContainer;
      
      public var btnFilterPrivate:ButtonContainer;
      
      public var btnFilterTemple:ButtonContainer;
      
      public var btnFilterBidHouse:ButtonContainer;
      
      public var btnFilterCraftHouse:ButtonContainer;
      
      public var btnFilterMisc:ButtonContainer;
      
      public var btnFilterTransport:ButtonContainer;
      
      public var btnFilterConquest:ButtonContainer;
      
      public var btnFilterDungeon:ButtonContainer;
      
      public var btnFilterAll:ButtonContainer;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var btn_sortConquests:ButtonContainer;
      
      public var lblbtnFilterFlags:Label;
      
      public var lblbtnFilterPrivate:Label;
      
      public var lblbtnFilterTemple:Label;
      
      public var lblbtnFilterBidHouse:Label;
      
      public var lblbtnFilterCraftHouse:Label;
      
      public var lblbtnFilterMisc:Label;
      
      public var lblbtnFilterTransport:Label;
      
      public var lblbtnFilterConquest:Label;
      
      public var lblbtnFilterDungeon:Label;
      
      public var lblbtnFilterAll:Label;
      
      public var lbl_tooltip_content:Label;
      
      public var tx_filter_bg:TextureBitmap;
      
      public var territory_filter_close:ButtonContainer;
      
      public var btnSwitch:ButtonContainer;
      
      public var btnBestiary:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_player:ButtonContainer;
      
      public var btn_grid:ButtonContainer;
      
      public var tiSearch:Input;
      
      public var lbl_results:Label;
      
      public var lbl_title:Label;
      
      public var ctr_locTree:GraphicContainer;
      
      public var ctr_quantity:GraphicContainer;
      
      public var ctr_search_bg:GraphicContainer;
      
      public var ctn_tooltip_territories:GraphicContainer;
      
      public var cbx_territory_type:ComboBox;
      
      public var gdZone:Grid;
      
      public var gdSearchAll:Grid;
      
      public var gd_tooltip:Grid;
      
      private var _dataProvider;
      
      private var _searchCriteria:String;
      
      private var _conquestMode:Boolean = false;
      
      private var _gdConquestProvider:Array;
      
      private var _lastAreaShapeDisplayed:Array;
      
      private var _lastLayer:String;
      
      private var _filterCat:Dictionary;
      
      private var _mapViewerBorder:int;
      
      private var _updateConquestAreas:Boolean;
      
      private var _itemsToExpand:Array;
      
      private var _selectedItem:Object;
      
      private var _lastSearch:String;
      
      private var _addEntryHighlight:Boolean;
      
      private var _removeEntryHighlight:Boolean;
      
      private var _searchSelectedItem:Object;
      
      private var _lastSearchSubAreaId:int;
      
      private var _lastSearchSubAreaInfo:String;
      
      private var _searchTimeoutId:uint;
      
      private var _prismsHintGroup:Object;
      
      private var _perceptorsHintGroup:Object;
      
      private var _hintCategoryFiltersListConquest:Array;
      
      private var _hintCategoryFiltersListSearch:Array;
      
      private var _hasResultsInOtherWorldMap:Boolean;
      
      private var _searchHints;
      
      private var _conquestCurrentSorting:uint;
      
      public function CartographyUi()
      {
         this._gdConquestProvider = new Array();
         this._lastAreaShapeDisplayed = new Array();
         this._filterCat = new Dictionary(true);
         this._hintCategoryFiltersListConquest = new Array();
         this._hintCategoryFiltersListSearch = new Array();
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc2_:* = uiApi.getUi("bannerMap");
         if(_loc2_)
         {
            _loc2_.uiClass.hide();
         }
         this.btn_close.soundId = SoundEnum.WINDOW_CLOSE;
         this.btn_player.soundId = SoundEnum.GEN_BUTTON;
         this.btn_grid.soundId = SoundEnum.CHECKBOX_CHECKED;
         mapViewer.finalized = false;
         _conquestInformationsIsActive = _conquestInformationsIsActive || this._conquestMode;
         uiApi.addComponentHook(this.btnFilterFlags,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterFlags,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterFlags,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterPrivate,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterPrivate,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterPrivate,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterTemple,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterTemple,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterTemple,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterBidHouse,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterBidHouse,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterBidHouse,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterCraftHouse,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterCraftHouse,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterCraftHouse,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterMisc,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterMisc,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterMisc,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterTransport,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterTransport,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterTransport,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterConquest,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterConquest,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterConquest,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterDungeon,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterDungeon,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterDungeon,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnFilterAll,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnFilterAll,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnFilterAll,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.tx_filter_bg,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.tx_filter_bg,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnSwitch,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnSwitch,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btnBestiary,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btnBestiary,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btn_player,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btn_player,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btn_grid,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btn_grid,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.tiSearch,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnSwitch,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btnBestiary,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.territory_filter_close,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.cbx_territory_type,ComponentHookList.ON_SELECT_ITEM);
         uiApi.addComponentHook(this.gdZone,ComponentHookList.ON_SELECT_ITEM);
         uiApi.addComponentHook(this.gdZone,ComponentHookList.ON_ITEM_ROLL_OVER);
         sysApi.addHook(KeyDown,this.onKeyDown);
         loadMapFilters(this._hintCategoryFiltersListConquest,CONQUEST_FILTERS);
         loadMapFilters(this._hintCategoryFiltersListSearch,SEARCH_FILTERS);
         this._mapViewerBorder = uiApi.me().getConstant("map_viewer_border");
         this._conquestMode = param1.conquest;
         this.switchToConquest();
         super.main(param1);
         sysApi.dispatchHook(MapDisplay,true);
         this.tiSearch.text = uiApi.getText("ui.common.search.input");
         var _loc4_:uint = RESOURCES_QUANTITY_COLOR.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new Bitmap(new BitmapData(30,20,false,RESOURCES_QUANTITY_COLOR[_loc3_]));
            _loc5_.x = 15;
            _loc5_.y = 8 + _loc3_ * 30;
            this.ctr_quantity.addChild(_loc5_);
            _loc3_++;
         }
         this.gdSearchAll.visible = this.ctr_search_bg.visible = this.ctr_quantity.visible = false;
         this.ctn_tooltip_territories.visible = false;
      }
      
      override protected function initMap() : void
      {
         var _loc1_:PrismSubAreaWrapper = null;
         super.initMap();
         mapViewer.addLayer(SEARCH_AREAS);
         mapViewer.addLayer(SEARCH_AREAS_FLAGS);
         mapViewer.addLayer(SEARCH_HINTS);
         this.btnSwitch.soundId = SoundEnum.TAB;
         this.territory_filter_close.soundId = SoundEnum.TAB;
         soundApi.playSound(SoundTypeEnum.MAP_OPEN);
         this.btnFilterTemple.selected = __hintCategoryFiltersList[1];
         this.btnFilterBidHouse.selected = __hintCategoryFiltersList[2];
         this.btnFilterCraftHouse.selected = __hintCategoryFiltersList[3];
         this.btnFilterMisc.selected = __hintCategoryFiltersList[4];
         this.btnFilterConquest.selected = __hintCategoryFiltersList[5];
         this.btnFilterDungeon.selected = __hintCategoryFiltersList[6];
         this.btnFilterPrivate.selected = __hintCategoryFiltersList[7];
         this.btnFilterFlags.selected = __hintCategoryFiltersList[8];
         this.btnFilterTransport.selected = __hintCategoryFiltersList[9];
         this.lblbtnFilterFlags.width = 1;
         this.lblbtnFilterPrivate.width = 1;
         this.lblbtnFilterTemple.width = 1;
         this.lblbtnFilterBidHouse.width = 1;
         this.lblbtnFilterCraftHouse.width = 1;
         this.lblbtnFilterMisc.width = 1;
         this.lblbtnFilterTransport.width = 1;
         this.lblbtnFilterConquest.width = 1;
         this.lblbtnFilterDungeon.width = 1;
         this.lblbtnFilterAll.width = 1;
         this.btnFilterAll.selected = this.btnFilterTemple.selected || this.btnFilterBidHouse.selected || this.btnFilterCraftHouse.selected || this.btnFilterMisc.selected || this.btnFilterConquest.selected || this.btnFilterDungeon.selected || this.btnFilterPrivate.selected || this.btnFilterFlags.selected || this.btnFilterTransport.selected;
         this._filterCat[this.btnFilterTemple] = "layer_1";
         this._filterCat[this.btnFilterBidHouse] = "layer_2";
         this._filterCat[this.btnFilterCraftHouse] = "layer_3";
         this._filterCat[this.btnFilterMisc] = "layer_4";
         this._filterCat[this.btnFilterConquest] = "layer_5";
         this._filterCat[this.btnFilterDungeon] = "layer_6";
         this._filterCat[this.btnFilterPrivate] = "layer_7";
         this._filterCat[this.btnFilterFlags] = "layer_8";
         this._filterCat[this.btnFilterTransport] = "layer_9";
         if(!__conquestSubAreasInfos)
         {
            if(modCartography.showConquestInformation() || INTEGRATION_MODE)
            {
               this.btnSwitch.disabled = false;
               sysApi.sendAction(new PrismsListRegister("Cartography",PrismListenEnum.PRISM_LISTEN_ALL));
               _conquestInformationsIsActive = true;
            }
            else
            {
               this.btnSwitch.disabled = true;
            }
         }
         else if(modCartography.showConquestInformation())
         {
            this.addAreaShapesFromData(__capturableAreas);
            this.addAreaShapesFromData(__normalAreas);
            this.addAreaShapesFromData(__weakenedAreas);
            this.addAreaShapesFromData(__vulnerableAreas);
            this.addAreaShapesFromData(__sabotagedAreas);
            this.updateConquestSubarea(false);
            for each(_loc1_ in __conquestSubAreasInfos)
            {
               updatePrismIcon(_loc1_);
            }
            mapViewer.showLayer("layer_1",false);
            mapViewer.showLayer("layer_2",false);
            mapViewer.showLayer("layer_3",false);
            mapViewer.showLayer("layer_4",false);
            mapViewer.showLayer("layer_5",true);
            mapViewer.showLayer("layer_6",false);
            mapViewer.showLayer("layer_7",false);
            mapViewer.showLayer("layer_9",false);
            this.btnFilterTemple.selected = false;
            this.btnFilterBidHouse.selected = false;
            this.btnFilterCraftHouse.selected = false;
            this.btnFilterMisc.selected = false;
            this.btnFilterTransport.selected = false;
            this.btnFilterConquest.selected = true;
            this.btnFilterDungeon.selected = false;
            this.btnFilterPrivate.selected = false;
         }
         uiApi.getUi("gameMenu").visible = false;
         sysApi.showWorld(false);
         this.mainCtr.visible = true;
      }
      
      override public function unload() : void
      {
         super.unload();
         _conquestInformationsIsActive = false;
         sysApi.showWorld(true);
         sysApi.dispatchHook(MapDisplay,false);
         uiApi.getUi("gameMenu").visible = true;
         clearTimeout(this._searchTimeoutId);
         if(this._conquestMode)
         {
            saveMapFilters(this._hintCategoryFiltersListConquest,CONQUEST_FILTERS);
         }
         else if(this._searchSelectedItem)
         {
            saveMapFilters(this._hintCategoryFiltersListSearch,SEARCH_FILTERS);
         }
         var _loc1_:* = uiApi.getUi("bannerMap");
         if(_loc1_)
         {
            _loc1_.uiClass.show();
         }
      }
      
      public function updateTooltipLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:ColorTransform = null;
         if(param1)
         {
            _loc4_ = new ColorTransform();
            _loc4_.color = uiApi.me().getConstant(param1.colorKey);
            param2.tx_prism.uri = uiApi.createUri(uiApi.me().getConstant("icon_simple_prism_uri"));
            param2.tx_prism.colorTransform = _loc4_;
            param2.lbl_prism.text = param1.label;
         }
         else
         {
            param2.tx_prism.uri = null;
            param2.lbl_prism.text = "";
         }
      }
      
      public function updateGridLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:ColorTransform = null;
         if(param1)
         {
            _loc4_ = new ColorTransform();
            if(param1.hasOwnProperty("parent") && param1.parent != null && param1.parent.hasOwnProperty("colorKey"))
            {
               _loc4_.color = uiApi.me().getConstant(param1.parent.colorKey);
            }
            param2.tx_area_filter.uri = uiApi.createUri(uiApi.me().getConstant("icon_simple_prism_uri"));
            param2.tx_area_filter.colorTransform = _loc4_;
            param2.lbl_area_filter.text = param1.label;
            param2.lbl_area_filter.colorTransform = _loc4_;
         }
         else
         {
            param2.tx_area_filter.uri = null;
            param2.lbl_area_filter.text = "";
         }
      }
      
      public function updateFilterLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:ColorTransform = null;
         if(param1)
         {
            _loc4_ = new ColorTransform();
            if(this.cbx_territory_type.selectedItem.layer == param1.layer && !param3)
            {
               _loc4_.color = uiApi.me().getConstant(param1.colorKey);
            }
            else
            {
               _loc4_.color = uiApi.me().getConstant(param1.colorKey + "_dark");
            }
            param2.tx_area_filter.colorTransform = _loc4_;
            param2.lbl_area_filter.text = param1.label + " (" + param1.children.length + ")";
            param2.lbl_area_filter.colorTransform = _loc4_;
            if(param1.layer == "AllAreas")
            {
               param2.tx_area_filter.uri = uiApi.createUri(uiApi.me().getConstant("icon_multi_prism_uri"));
               param2.tx_area_filter.width = int(uiApi.me().getConstant("icon_multi_prism_width"));
            }
            else
            {
               param2.tx_area_filter.uri = uiApi.createUri(uiApi.me().getConstant("icon_simple_prism_uri"));
               param2.tx_area_filter.width = int(uiApi.me().getConstant("icon_simple_prism_width"));
            }
         }
      }
      
      private function isSelected(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1;
      }
      
      protected function updateAllFilters(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         if(this._conquestMode)
         {
            _loc2_ = this._hintCategoryFiltersListConquest;
            _loc3_ = CONQUEST_FILTERS;
         }
         else if(this._searchSelectedItem)
         {
            _loc2_ = this._hintCategoryFiltersListSearch;
            _loc3_ = SEARCH_FILTERS;
         }
         else
         {
            _loc2_ = __hintCategoryFiltersList;
            _loc3_ = "mapFilters";
         }
         var _loc4_:* = _loc2_.some(this.isSelected);
         var _loc5_:int = 1;
         while(_loc5_ < _loc2_.length)
         {
            _loc2_[_loc5_] = !_loc4_;
            _loc5_++;
         }
         saveMapFilters(_loc2_,_loc3_);
         for(_loc6_ in this._filterCat)
         {
            _loc6_.selected = !_loc4_;
            if(__layersToShow[this._filterCat[_loc6_]])
            {
               mapViewer.showLayer(this._filterCat[_loc6_],_loc6_.selected);
               mapViewer.updateMapElements();
            }
            _loc7_ = int(this._filterCat[_loc6_].split("_")[1]);
            if(_loc2_ == __hintCategoryFiltersList)
            {
               sysApi.dispatchHook(MapHintsFilter,_loc7_,_loc6_.selected,true);
            }
         }
         this.lblbtnFilterAll.text = !!this.btnFilterAll.selected?uiApi.getText("ui.map.hideAll"):uiApi.getText("ui.map.displayAll");
      }
      
      protected function updateMapFilter(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc2_:int = int(this._filterCat[param1].split("_")[1]);
         if(this._conquestMode)
         {
            _loc3_ = this._hintCategoryFiltersListConquest;
            _loc4_ = CONQUEST_FILTERS;
         }
         else if(this._searchSelectedItem)
         {
            _loc3_ = this._hintCategoryFiltersListSearch;
            _loc4_ = SEARCH_FILTERS;
         }
         else
         {
            _loc3_ = __hintCategoryFiltersList;
            _loc4_ = "mapFilters";
         }
         _loc3_[_loc2_] = param1.selected;
         saveMapFilters(_loc3_,_loc4_);
         if(param1.selected)
         {
            this.btnFilterAll.selected = true;
         }
         else
         {
            this.btnFilterAll.selected = this.btnFilterTemple.selected || this.btnFilterBidHouse.selected || this.btnFilterCraftHouse.selected || this.btnFilterMisc.selected || this.btnFilterConquest.selected || this.btnFilterDungeon.selected || this.btnFilterPrivate.selected || this.btnFilterFlags.selected || this.btnFilterTransport.selected;
         }
         this.lblbtnFilterAll.text = !!this.btnFilterAll.selected?uiApi.getText("ui.map.hideAll"):uiApi.getText("ui.map.displayAll");
         if(__layersToShow[this._filterCat[param1]])
         {
            mapViewer.showLayer(this._filterCat[param1],param1.selected);
            mapViewer.updateMapElements();
         }
         if(_loc3_ == __hintCategoryFiltersList)
         {
            sysApi.dispatchHook(MapHintsFilter,_loc2_,param1.selected,true);
         }
      }
      
      override protected function addCustomFlagWithRightClick(param1:Number, param2:Number) : void
      {
         if(!this.btnFilterFlags.selected)
         {
            this.btnFilterFlags.selected = true;
            this.updateMapFilter(this.btnFilterFlags);
         }
         super.addCustomFlagWithRightClick(param1,param2);
      }
      
      override protected function addConquestItem(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         super.addConquestItem(param1,param2);
         if(param1 && this._conquestMode)
         {
            if(param1.layer != "AllAreas")
            {
               for each(_loc4_ in this._gdConquestProvider)
               {
                  if(_loc4_.layer != "AllAreas" && _loc4_.layer != param1.layer)
                  {
                     _loc5_ = -1;
                     for each(_loc3_ in _loc4_.children)
                     {
                        if(_loc3_.data.id == param2.data.id)
                        {
                           _loc5_ = _loc4_.children.indexOf(_loc3_);
                           break;
                        }
                     }
                     if(_loc5_ != -1)
                     {
                        _loc4_.children.splice(_loc5_,1);
                        break;
                     }
                  }
               }
            }
         }
      }
      
      override protected function onPrismsListInformation(param1:Object) : void
      {
         super.onPrismsListInformation(param1);
         this._gdConquestProvider = new Array();
         this._gdConquestProvider.push(__capturableAreas);
         this._gdConquestProvider.push(__normalAreas);
         this._gdConquestProvider.push(__weakenedAreas);
         this._gdConquestProvider.push(__vulnerableAreas);
         this._gdConquestProvider.push(__sabotagedAreas);
         this._updateConquestAreas = true;
         if(this._conquestMode)
         {
            this.switchConquestMode();
         }
         this.createPrismsSearchGroup(param1);
      }
      
      override protected function onPrismsInfoUpdate(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         super.onPrismsInfoUpdate(param1);
         if(this._conquestMode)
         {
            this._itemsToExpand = new Array();
            for each(_loc2_ in this._gdConquestProvider)
            {
               _loc2_.children.sort(this.compareSubAreaItem);
            }
            _loc3_ = "";
            if(this.cbx_territory_type.selectedItem)
            {
               _loc3_ = this.cbx_territory_type.selectedItem.value.layer;
            }
            if(this.gdZone.selectedItem)
            {
               _loc4_ = this.gdZone.selectedItem.value.data.id;
            }
            this.cbx_territory_type.dataProvider = this._gdConquestProvider;
            if(!this._searchCriteria)
            {
               for each(_loc5_ in this._gdConquestProvider)
               {
                  if(_loc5_.layer == _loc3_)
                  {
                     this.cbx_territory_type.selectedItem = _loc5_;
                     break;
                  }
               }
               this.gdZone.dataProvider = !!this.cbx_territory_type.selectedItem.value.children?this.cbx_territory_type.selectedItem.value.children:new Array();
               for each(_loc5_ in this.gdZone.dataProvider)
               {
                  if(_loc5_.data.id == _loc4_)
                  {
                     this.gdZone.selectedItem = _loc5_;
                     break;
                  }
               }
            }
            else
            {
               this.cbx_territory_type.selectedItem = __allAreas;
               this.gdZone.dataProvider = this.filterSubArea(this._searchCriteria,__allAreas.children);
               for each(_loc5_ in this.gdZone.dataProvider)
               {
                  if(_loc5_.data.id == _loc4_)
                  {
                     this.gdZone.selectedItem = _loc5_;
                     break;
                  }
               }
            }
            if(this._lastLayer)
            {
               this.updateLayerAreaShapes(this._lastLayer);
            }
         }
         this.updatePrismsSearchGroup(param1);
      }
      
      override protected function onTaxCollectorListUpdate() : void
      {
         var _loc2_:TaxCollectorWrapper = null;
         var _loc3_:Object = null;
         super.onTaxCollectorListUpdate();
         if(!this._perceptorsHintGroup)
         {
            this._perceptorsHintGroup = new Object();
            this._perceptorsHintGroup.type = HINT_GROUP_SEARCH_TYPE;
            this._perceptorsHintGroup.name = uiApi.getText("ui.social.guildTaxCollectors");
            this._perceptorsHintGroup.data = new Array();
            this._perceptorsHintGroup.uri = uiApi.me().getConstant("icons") + "1003.png";
         }
         this._perceptorsHintGroup.data.length = 0;
         var _loc1_:Object = socialApi.getTaxCollectors();
         for each(_loc2_ in _loc1_)
         {
            if(dataApi.getSubArea(_loc2_.subareaId).area.superAreaId == superAreaId)
            {
               _loc3_ = new Object();
               _loc3_.id = "_taxCollector" + _loc2_.uniqueId;
               _loc3_.gfx = "1003";
               _loc3_.x = _loc2_.mapWorldX;
               _loc3_.y = _loc2_.mapWorldY;
               _loc3_.name = __hintCaptions["guildPony_" + _loc2_.uniqueId];
               this._perceptorsHintGroup.data.push(_loc3_);
            }
         }
      }
      
      override protected function getSubAreaTooltipPosition() : Point
      {
         var _loc1_:Object = uiApi.getUi("tooltip_cartographyCurrentSubArea");
         __subAreaTooltipPosition.x = (this.btn_close as Object).localToGlobal(new Point(this.btn_close.x,this.btn_close.y)).x - 10 - _loc1_.width;
         __subAreaTooltipPosition.y = 30;
         return __subAreaTooltipPosition;
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         super.onRelease(param1);
         switch(param1)
         {
            case this.btn_player:
               if(mapViewer.zoomFactor >= __minZoom)
               {
                  mapViewer.moveTo(__playerPos.outdoorX,__playerPos.outdoorY);
                  if(!mapViewer.getMapElement("flag_playerPosition"))
                  {
                     addFlag("flag_playerPosition",uiApi.getText("ui.cartography.yourposition"),__playerPos.outdoorX,__playerPos.outdoorY,39423,false,true,false);
                  }
               }
               break;
            case this.btn_grid:
               gridDisplayed = !sysApi.getData("ShowMapGrid",DataStoreEnum.BIND_ACCOUNT);
               sysApi.setData("ShowMapGrid",gridDisplayed,DataStoreEnum.BIND_ACCOUNT);
               mapViewer.showGrid = gridDisplayed;
               break;
            case this.btn_close:
               soundApi.playSound(SoundTypeEnum.MAP_CLOSE);
               uiApi.unloadUi(uiApi.me().name);
               break;
            case this.tiSearch:
               if(uiApi.getText("ui.common.search.input") == this.tiSearch.text)
               {
                  this.tiSearch.text = "";
               }
               break;
            case this.btn_player:
               if(INTEGRATION_MODE)
               {
                  _loc4_ = mapViewer.getOrigineFromPos(__playerPos.outdoorX,__playerPos.outdoorY);
                  this.tiSearch.text = __worldMapInfo.id + "," + _loc4_.x + "," + _loc4_.y + "," + __worldMapInfo.mapWidth + "," + __worldMapInfo.mapHeight;
               }
               else if(!this.btnFilterFlags.selected)
               {
                  this.btnFilterFlags.selected = true;
                  this.updateMapFilter(this.btnFilterFlags);
               }
               break;
            case this.btnFilterTemple:
            case this.btnFilterBidHouse:
            case this.btnFilterCraftHouse:
            case this.btnFilterMisc:
            case this.btnFilterConquest:
            case this.btnFilterDungeon:
            case this.btnFilterPrivate:
            case this.btnFilterFlags:
            case this.btnFilterTransport:
               this.updateMapFilter(param1);
               break;
            case this.btnFilterAll:
               this.updateAllFilters(param1);
               break;
            case this.territory_filter_close:
            case this.btnSwitch:
               this._conquestMode = !this._conquestMode;
               this.switchToConquest();
               uiApi.hideTooltip();
               break;
            case this.btnBestiary:
               sysApi.sendAction(new OpenBook("bestiaryTab"));
               break;
            case this.btn_closeSearch:
               _loc2_ = this.removeSearchMapElements();
               this.gdSearchAll.visible = this.ctr_search_bg.visible = this.ctr_quantity.visible = false;
               this.tiSearch.text = uiApi.getText("ui.common.search.input");
               this.btn_closeSearch.visible = false;
               if(_loc2_)
               {
                  this.showHints(__hintCategoryFiltersList);
                  mapViewer.updateMapElements();
               }
               this._searchSelectedItem = null;
               this._lastSearchSubAreaId = -1;
               clearTimeout(this._searchTimeoutId);
               this._searchCriteria = null;
               if(this.cbx_territory_type.selectedItem && this.cbx_territory_type.selectedItem.hasOwnProperty("children") && this.cbx_territory_type.selectedItem.children)
               {
                  this._dataProvider = this.cbx_territory_type.selectedItem;
               }
               else
               {
                  this._dataProvider = __allAreas;
               }
               if(this._dataProvider == null)
               {
                  this._dataProvider = {"children":new Array()};
               }
               this.searchFilter();
               break;
            case this.btn_sortConquests:
               _loc3_ = new Array();
               _loc3_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.sortBy.alpha"),this.onSortConquest,[SORT_BY_NAME],false,null,this._conquestCurrentSorting != SORT_BY_VULNERABILITY_DATE));
               _loc3_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.prism.sortByVulnerabilityDate"),this.onSortConquest,[SORT_BY_VULNERABILITY_DATE],false,null,this._conquestCurrentSorting == SORT_BY_VULNERABILITY_DATE));
               modContextMenu.createContextMenu(_loc3_);
         }
         if(param1 != this.tiSearch && this.tiSearch && this.tiSearch.text.length == 0)
         {
            this.tiSearch.text = uiApi.getText("ui.common.search.input");
            this.btn_closeSearch.visible = false;
         }
      }
      
      override public function onKeyUp(param1:Object, param2:uint) : void
      {
         super.onKeyUp(param1,param2);
         if(this.tiSearch.haveFocus)
         {
            this._searchCriteria = this.tiSearch.text.toLowerCase();
            if(!this._searchCriteria.length)
            {
               this._searchCriteria = null;
               this.btn_closeSearch.visible = false;
            }
            else
            {
               this.btn_closeSearch.visible = true;
            }
            if(this._conquestMode)
            {
               this.searchFilter();
            }
            else if(param2 != Keyboard.ENTER)
            {
               clearTimeout(this._searchTimeoutId);
               if(this._lastSearch && this._searchCriteria == this._lastSearch)
               {
                  this.gdSearchAll.visible = this.ctr_search_bg.visible = true;
               }
               else
               {
                  this._searchTimeoutId = setTimeout(this.searchAll,500,this._searchCriteria);
               }
            }
         }
      }
      
      public function onKeyDown(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(this.tiSearch.haveFocus && !this._conquestMode && this.gdSearchAll.dataProvider.length > 0)
         {
            _loc3_ = this.gdSearchAll.selectedIndex;
            if(param2 == Keyboard.UP)
            {
               this._removeEntryHighlight = true;
               this.gdSearchAll.updateItem(_loc3_);
               _loc3_--;
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               this.gdSearchAll.selectedIndex = _loc3_;
            }
            else if(param2 == Keyboard.DOWN)
            {
               this._removeEntryHighlight = true;
               this.gdSearchAll.updateItem(_loc3_);
               _loc3_++;
               if(_loc3_ > this.gdSearchAll.dataProvider.length - 1)
               {
                  _loc3_ = this.gdSearchAll.dataProvider.length - 1;
               }
               this.gdSearchAll.selectedIndex = _loc3_;
            }
            else if(param2 == Keyboard.ENTER && this._lastSearch && this._searchCriteria == this._lastSearch)
            {
               this.onSelectItem(this.gdSearchAll,SelectMethodEnum.CLICK,false);
            }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc5_:SuperArea = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:PrismSubAreaWrapper = null;
         var _loc18_:AllianceWrapper = null;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:Object = null;
         var _loc23_:uint = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc4_:Object = param1.selectedItem;
         var _loc6_:Boolean = param1 == this.gdSearchAll && param2 == SelectMethodEnum.CLICK;
         if(param1 == this.cbx_territory_type)
         {
            this._dataProvider = param1.selectedItem.hasOwnProperty("children") && param1.selectedItem.children?param1.selectedItem:{"children":new Array()};
            this.searchFilter();
         }
         if(_loc6_)
         {
            this.removeSearchMapElements();
            __areaShapeDisplayed.length = 0;
            _loc10_ = _loc4_.name.indexOf("\n") != -1?_loc4_.name.split("\n")[0]:_loc4_.name;
            this.tiSearch.text = _loc10_;
            this.tiSearch.caretIndex = -1;
            this.gdSearchAll.visible = this.ctr_search_bg.visible = this.ctr_quantity.visible = false;
            this.showHints(this._hintCategoryFiltersListSearch);
            this._searchSelectedItem = _loc4_;
            this._lastSearchSubAreaId = -1;
         }
         if(param2 == SelectMethodEnum.DOUBLE_CLICK || _loc6_)
         {
            switch(_loc4_.type)
            {
               case "superarea":
                  saveCurrentMapPreset();
                  openNewMap(_loc4_.data.worldmap,MAP_TYPE_SUPERAREA,_loc4_.data);
                  break;
               case "subarea":
                  saveCurrentMapPreset();
                  if(!_loc4_.data.hasCustomWorldMap)
                  {
                     _loc5_ = dataApi.getArea(_loc4_.data.areaId).superArea;
                     if(_currentWorldId != _loc5_.worldmapId)
                     {
                        openNewMap(_loc5_.worldmap,MAP_TYPE_SUPERAREA,_loc5_);
                        __areaShapeDisplayed = new Array();
                        this.showConquestAreaShapes(_loc4_.parent.layer);
                        __lastAreaShape = "shape" + _loc4_.data.id;
                        if(__areaShapeDisplayed.indexOf(_loc4_.parent.layer) == -1)
                        {
                           mapViewer.areaShapeColorTransform(mapViewer.getMapElement(__lastAreaShape),100,1,1,1,1);
                        }
                        else
                        {
                           mapViewer.areaShapeColorTransform(mapViewer.getMapElement(__lastAreaShape),100,1.2,1.2,1.2,2);
                        }
                     }
                  }
                  if(!openNewMap(_loc4_.data.worldmap,MAP_TYPE_SUBAREA,_loc4_.data))
                  {
                     _loc9_ = mapApi.getSubAreaCenter(_loc4_.data.id);
                     if(_loc9_)
                     {
                        mapViewer.moveTo(_loc9_.x,_loc9_.y);
                     }
                  }
                  break;
               case "area":
                  break;
               case HINT_SEARCH_TYPE:
               case SUBAREA_SEARCH_TYPE:
                  if(_loc4_.data is Hint)
                  {
                     _loc11_ = _loc4_.data.x;
                     _loc12_ = _loc4_.data.y;
                     mapViewer.addIcon(SEARCH_HINTS,"search_hint" + _loc4_.data.id,__hintIconsRootPath + _loc4_.data.gfx + ".png",_loc4_.data.x,_loc4_.data.y,__iconScale,_loc4_.data.name,true);
                  }
                  else if(_loc4_.data is SubArea)
                  {
                     _loc9_ = mapApi.getSubAreaCenter(_loc4_.data.id);
                     if(_loc9_)
                     {
                        _loc11_ = _loc9_.x;
                        _loc12_ = _loc9_.y;
                        _loc15_ = 3355443;
                        _loc16_ = 1096297;
                        _loc17_ = socialApi.getPrismSubAreaById(_loc4_.data.id);
                        if(_loc17_ && _loc17_.mapId != -1)
                        {
                           _loc18_ = !_loc17_.alliance?socialApi.getAlliance():_loc17_.alliance;
                           _loc15_ = _loc16_ = _loc18_.backEmblem.color;
                        }
                        this.showSearchSubArea(_loc4_.data.id,_loc15_,_loc16_);
                        showAreaShape(SEARCH_AREAS,true);
                     }
                  }
                  mapViewer.updateMapElements();
                  mapViewer.moveTo(_loc11_,_loc12_);
                  break;
               case MONSTER_SEARCH_TYPE:
               case ITEM_SEARCH_TYPE:
                  if(_loc4_.resourceSubAreaIds)
                  {
                     this.ctr_quantity.visible = true;
                     _loc19_ = _loc4_.resourceSubAreaIds.length;
                     _loc7_ = 0;
                     while(_loc7_ < _loc19_)
                     {
                        _loc13_ = _loc4_.resourceSubAreaIds[_loc7_];
                        _loc20_ = _loc4_.resourceSubAreaIds[_loc7_ + 1];
                        if(_loc20_ > 0 && _loc20_ <= 5)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[0];
                        }
                        else if(_loc20_ > 5 && _loc20_ <= 10)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[1];
                        }
                        else if(_loc20_ > 10 && _loc20_ <= 25)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[2];
                        }
                        else if(_loc20_ > 25 && _loc20_ <= 50)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[3];
                        }
                        else if(_loc20_ > 50 && _loc20_ <= 100)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[4];
                        }
                        else if(_loc20_ > 100 && _loc20_ <= 250)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[5];
                        }
                        else if(_loc20_ > 250 && _loc20_ <= 500)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[6];
                        }
                        else if(_loc20_ > 500)
                        {
                           _loc21_ = RESOURCES_QUANTITY_COLOR[7];
                        }
                        this.showSearchSubArea(_loc13_,7039851,_loc21_,1,0.8);
                        _loc7_ = _loc7_ + 2;
                     }
                  }
                  else if(_loc4_.subAreasIds)
                  {
                     _loc22_ = _loc4_.type == MONSTER_SEARCH_TYPE?_loc4_.subAreasIds:null;
                     if(!_loc22_)
                     {
                        _loc23_ = _loc4_.subAreasIds.length;
                        _loc7_ = 0;
                        while(_loc7_ < _loc23_)
                        {
                           _loc24_ = _loc4_.subAreasIds[_loc7_ + 1];
                           _loc25_ = _loc7_ + 2 + _loc24_;
                           _loc8_ = _loc7_ + 2;
                           while(_loc8_ < _loc25_)
                           {
                              this.showSearchSubArea(_loc4_.subAreasIds[_loc8_]);
                              _loc8_++;
                           }
                           _loc7_ = _loc7_ + _loc24_;
                           _loc7_ = _loc7_ + 2;
                        }
                     }
                     else
                     {
                        for each(_loc13_ in _loc22_)
                        {
                           this.showSearchSubArea(_loc13_);
                        }
                     }
                  }
                  showAreaShape(SEARCH_AREAS,true);
                  mapViewer.updateMapElements();
                  break;
               case HINT_GROUP_SEARCH_TYPE:
                  for each(_loc14_ in _loc4_.data)
                  {
                     mapViewer.addIcon(SEARCH_HINTS,"search_hint" + _loc14_.id,__hintIconsRootPath + _loc14_.gfx + ".png",_loc14_.x,_loc14_.y,__iconScale,_loc14_.name,true);
                  }
                  mapViewer.updateMapElements();
            }
         }
         else if(param1 == this.gdSearchAll && (param2 == SelectMethodEnum.MANUAL || param2 == SelectMethodEnum.AUTO))
         {
            this._addEntryHighlight = true;
            this.gdSearchAll.updateItem(param1.selectedIndex);
         }
         else if(_loc4_ && _loc4_.type == "areaShape")
         {
            if(_currentWorldId != __startWorldMapInfo.id)
            {
               openPlayerCurrentMap();
               this._lastLayer = null;
               __areaShapeDisplayed = new Array();
            }
            if(this._lastLayer != _loc4_.layer)
            {
               this.updateLayerAreaShapes(_loc4_.layer);
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:PrismSubAreaWrapper = null;
         var _loc7_:AllianceWrapper = null;
         var _loc8_:* = null;
         uiApi.hideTooltip();
         if(param2.data && param2.data.data && param2.data.type == "subarea")
         {
            _loc5_ = param2.data.data.id;
            _loc3_ = "shape" + _loc5_;
            if(_loc3_ != __lastAreaShape)
            {
               _loc4_ = mapViewer.getMapElement(__lastAreaShape);
               if(_loc4_)
               {
                  if(__areaShapeDisplayed.indexOf(_loc4_.layer) == -1)
                  {
                     mapViewer.areaShapeColorTransform(_loc4_,100,1,1,1,0);
                  }
                  else
                  {
                     mapViewer.areaShapeColorTransform(_loc4_,100,1,1,1,1);
                  }
               }
               __lastAreaShape = _loc3_;
               _loc4_ = mapViewer.getMapElement(__lastAreaShape);
               if(_loc4_)
               {
                  if(__areaShapeDisplayed.indexOf(_loc4_.layer) == -1)
                  {
                     mapViewer.areaShapeColorTransform(_loc4_,100,1,1,1,1);
                  }
                  else
                  {
                     mapViewer.areaShapeColorTransform(_loc4_,100,1.2,1.2,1.2,1.5);
                  }
               }
            }
            _loc6_ = socialApi.getPrismSubAreaById(_loc5_);
            if(_loc6_ && (_loc6_.mapId != -1 || _loc6_.alliance))
            {
               _loc7_ = !_loc6_.alliance?socialApi.getAlliance():_loc6_.alliance;
               _loc8_ = "[" + _loc7_.allianceTag + "]";
               if(_loc6_.state == PrismStateEnum.PRISM_STATE_WEAKENED || _loc6_.state == PrismStateEnum.PRISM_STATE_SABOTAGED)
               {
                  _loc8_ = _loc8_ + (" " + uiApi.getText("ui.prism.startVulnerability") + uiApi.getText("ui.common.colon") + timeApi.getDate(_loc6_.nextVulnerabilityDate * 1000) + " " + _loc6_.vulnerabilityHourString);
               }
               uiApi.showTooltip(uiApi.textTooltipInfo(_loc8_),param2.container,false,"standard",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,3,null,null,null,"ConquestPrismInfo");
            }
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         super.onRollOver(param1);
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:int = 400;
         switch(param1)
         {
            case this.btn_player:
               if(INTEGRATION_MODE)
               {
                  _loc2_ = "[INTEGRATION MODE] Calcul worldId,origineX,origineY,mapWidth,mapHeight";
               }
               _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
               _loc4_ = LocationEnum.POINT_TOPRIGHT;
               _loc2_ = uiApi.getText("ui.map.player");
               break;
            case this.btn_grid:
               _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
               _loc4_ = LocationEnum.POINT_TOPRIGHT;
               _loc2_ = uiApi.getText("ui.option.displayGrid");
               break;
            case this.tx_help:
               _loc6_ = uiApi.getVisibleStageBounds();
               this.ctn_tooltip_territories.y = this.ctr_locTree.y + 10;
               if(this.ctr_locTree.x > _loc6_.width / 2)
               {
                  this.ctn_tooltip_territories.x = this.ctr_locTree.x - this.ctn_tooltip_territories.width - 5;
               }
               else
               {
                  this.ctn_tooltip_territories.x = this.ctr_locTree.x + this.ctr_locTree.width + 5;
               }
               _loc7_ = sysApi.getActiveFontType() == "smallScreen"?uint(7):uint(5);
               this.lbl_tooltip_content.fullWidth(0,_loc7_);
               this.lbl_tooltip_content.x = this.ctn_tooltip_territories.width / 2 - this.lbl_tooltip_content.width / 2 - _loc7_;
               this.gd_tooltip.x = this.gd_tooltip.y = 0;
               uiApi.me().processLocation(uiApi.me().getElementById("gd_tooltip"));
               this.gd_tooltip.x = this.gd_tooltip.x + _loc7_;
               this.ctn_tooltip_territories.height = this.gd_tooltip.y + this.gd_tooltip.height - this.ctn_tooltip_territories.y;
               this.ctn_tooltip_territories.visible = true;
               break;
            case this.btnSwitch:
               _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
               _loc4_ = LocationEnum.POINT_TOPRIGHT;
               if(!this._conquestMode)
               {
                  _loc2_ = uiApi.getText("ui.map.showConquest");
               }
               else
               {
                  _loc2_ = uiApi.getText("ui.map.hideConquest");
               }
               break;
            case this.btnBestiary:
               _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
               _loc4_ = LocationEnum.POINT_TOPRIGHT;
               _loc2_ = uiApi.getText("ui.common.bestiary");
               break;
            case btn_zoomIn:
               _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
               _loc4_ = LocationEnum.POINT_TOPRIGHT;
               _loc2_ = uiApi.getText("ui.common.zoomin");
               break;
            case btn_zoomOut:
               _loc3_ = LocationEnum.POINT_BOTTOMRIGHT;
               _loc4_ = LocationEnum.POINT_TOPRIGHT;
               _loc2_ = uiApi.getText("ui.common.zoomout");
               break;
            case this.btnFilterTemple:
            case this.btnFilterBidHouse:
            case this.btnFilterCraftHouse:
            case this.btnFilterMisc:
            case this.btnFilterConquest:
            case this.btnFilterDungeon:
            case this.btnFilterPrivate:
            case this.btnFilterFlags:
            case this.btnFilterTransport:
            case this.btnFilterAll:
            case this.tx_filter_bg:
               _loc8_ = uiApi.me().getConstant("filter_menu_opened_width");
               this.tx_filter_bg.width = _loc8_;
               this.lblbtnFilterFlags.width = _loc8_ - 50;
               this.lblbtnFilterPrivate.width = _loc8_ - 50;
               this.lblbtnFilterTemple.width = _loc8_ - 50;
               this.lblbtnFilterBidHouse.width = _loc8_ - 50;
               this.lblbtnFilterCraftHouse.width = _loc8_ - 50;
               this.lblbtnFilterMisc.width = _loc8_ - 50;
               this.lblbtnFilterTransport.width = _loc8_ - 50;
               this.lblbtnFilterConquest.width = _loc8_ - 50;
               this.lblbtnFilterDungeon.width = _loc8_ - 50;
               this.lblbtnFilterAll.width = _loc8_ - 50;
               this.lblbtnFilterFlags.text = uiApi.getText("ui.cartography.flags");
               this.lblbtnFilterPrivate.text = uiApi.getText("ui.common.possessions");
               this.lblbtnFilterTemple.text = uiApi.getText("ui.map.temple");
               this.lblbtnFilterBidHouse.text = uiApi.getText("ui.map.bidHouse");
               this.lblbtnFilterCraftHouse.text = uiApi.getText("ui.map.craftHouse");
               this.lblbtnFilterMisc.text = uiApi.getText("ui.common.misc");
               this.lblbtnFilterTransport.text = uiApi.getText("ui.cartography.transport");
               this.lblbtnFilterConquest.text = uiApi.getText("ui.map.conquest");
               this.lblbtnFilterDungeon.text = uiApi.getText("ui.map.dungeon");
               this.lblbtnFilterAll.text = !!this.btnFilterAll.selected?uiApi.getText("ui.map.hideAll"):uiApi.getText("ui.map.displayAll");
               break;
            case this.gdSearchAll:
            case this.ctr_search_bg:
            case this.ctr_quantity:
               __showMapAreaShape = false;
               rollOutMapAreaShape(__lastAreaShape);
               if(param1 == this.ctr_quantity)
               {
                  _loc2_ = uiApi.getText("ui.search.resourceEstimatedQuantity");
                  _loc5_ = 500;
               }
         }
         if(param1.name.indexOf("tx_itemType") != -1 && param1.uri)
         {
            if(param1.uri.fileName == "success_cat_5.png")
            {
               _loc2_ = uiApi.getText("ui.common.collectableResource");
            }
            else if(param1.uri.fileName == "success_cat_6.png")
            {
               _loc2_ = uiApi.getText("ui.common.questItem");
            }
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_,null,null,_loc5_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      override public function onRollOut(param1:Object) : void
      {
         super.onRollOut(param1);
         switch(param1)
         {
            case this.btnBestiary:
            case this.btnSwitch:
               break;
            case this.tx_help:
               this.ctn_tooltip_territories.visible = false;
               break;
            case this.btnFilterTemple:
            case this.btnFilterBidHouse:
            case this.btnFilterCraftHouse:
            case this.btnFilterMisc:
            case this.btnFilterConquest:
            case this.btnFilterDungeon:
            case this.btnFilterPrivate:
            case this.btnFilterFlags:
            case this.btnFilterTransport:
            case this.btnFilterAll:
            case this.tx_filter_bg:
               this.tx_filter_bg.width = uiApi.me().getConstant("filter_menu_closed_width");
               this.lblbtnFilterFlags.text = "";
               this.lblbtnFilterPrivate.text = "";
               this.lblbtnFilterTemple.text = "";
               this.lblbtnFilterBidHouse.text = "";
               this.lblbtnFilterCraftHouse.text = "";
               this.lblbtnFilterMisc.text = "";
               this.lblbtnFilterTransport.text = "";
               this.lblbtnFilterConquest.text = "";
               this.lblbtnFilterDungeon.text = "";
               this.lblbtnFilterAll.text = "";
               this.lblbtnFilterFlags.width = 1;
               this.lblbtnFilterPrivate.width = 1;
               this.lblbtnFilterTemple.width = 1;
               this.lblbtnFilterBidHouse.width = 1;
               this.lblbtnFilterCraftHouse.width = 1;
               this.lblbtnFilterMisc.width = 1;
               this.lblbtnFilterTransport.width = 1;
               this.lblbtnFilterConquest.width = 1;
               this.lblbtnFilterDungeon.width = 1;
               this.lblbtnFilterAll.width = 1;
         }
      }
      
      override protected function onMapHintsFilter(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:* = null;
         super.onMapHintsFilter(param1,param2,param3);
         if(!param3)
         {
            for(_loc4_ in this._filterCat)
            {
               if(this._filterCat[_loc4_] == "layer_" + param1)
               {
                  _loc4_.selected = param2;
               }
            }
         }
      }
      
      override protected function toggleHints() : void
      {
         var _loc2_:* = null;
         super.toggleHints();
         var _loc1_:Boolean = mapViewer.allLayersVisible;
         for(_loc2_ in this._filterCat)
         {
            _loc2_.selected = _loc1_;
         }
      }
      
      override public function onFocusChange(param1:Object) : void
      {
         super.onFocusChange(param1);
         if(param1 && this.gdSearchAll.visible && param1 != this.tiSearch && (!param1 || !(this.gdSearchAll as Object).contains(param1)))
         {
            this.onRelease(this.btn_closeSearch);
         }
      }
      
      public function updateSearchEntryLine(param1:Object, param2:*, param3:Boolean) : void
      {
         param2.btn_line.y = 1;
         if(param1)
         {
            if(this._removeEntryHighlight)
            {
               param2.btn_line.state = StatesEnum.STATE_NORMAL;
               this._removeEntryHighlight = false;
               return;
            }
            if(this._addEntryHighlight)
            {
               param2.btn_line.state = StatesEnum.STATE_OVER;
               this._addEntryHighlight = false;
               return;
            }
            param2.btn_line.state = StatesEnum.STATE_NORMAL;
            if(param1.uri)
            {
               param2.tx_result_icon.x = param2.tx_result_icon.y = 5;
               param2.tx_result_icon.uri = uiApi.createUri(param1.uri);
            }
            param2.lbl_result_name.text = param1.label;
            if(param1.typeUri)
            {
               param2.tx_itemType.uri = uiApi.createUri(param1.typeUri);
            }
            else
            {
               param2.tx_itemType.uri = null;
            }
         }
         else
         {
            param2.btn_line.state = StatesEnum.STATE_NORMAL;
            param2.tx_result_icon.uri = null;
            param2.lbl_result_name.text = "";
            param2.tx_itemType.uri = null;
         }
      }
      
      override public function onMapRollOver(param1:Object, param2:int, param3:int, param4:SubArea = null) : void
      {
         var _loc5_:SubArea = null;
         var _loc6_:SubArea = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         if(this._searchSelectedItem && (this._searchSelectedItem.type == MONSTER_SEARCH_TYPE || this._searchSelectedItem.type == ITEM_SEARCH_TYPE))
         {
            _loc10_ = getSubAreaFromCoords(param2,param3);
            if(_loc10_ && mapViewer.getMapElement("search_shape" + _loc10_[0].id))
            {
               _loc5_ = _loc10_[0];
               _loc7_ = _loc10_[1];
            }
            if(__currentMapElement)
            {
               if(__currentMapElement.id.indexOf("search_hint") != -1)
               {
                  _loc6_ = dataApi.getSubArea(__currentMapElement.id.split("search_hint")[1]);
               }
               _loc8_ = __currentMapElement.legend;
            }
         }
         super.onMapRollOver(param1,param2,param3,_loc5_);
         var _loc9_:String = "";
         if(_loc5_ && !_loc6_)
         {
            _loc11_ = this._lastSearchSubAreaId == _loc5_.id?this._lastSearchSubAreaInfo:null;
            if(!_loc11_)
            {
               _loc11_ = this.getSubAreaInfoStr(_loc5_,_loc7_);
               this._lastSearchSubAreaId = _loc5_.id;
               this._lastSearchSubAreaInfo = _loc11_;
            }
            _loc9_ = _loc9_ + _loc11_;
         }
         if(_loc6_)
         {
            _loc9_ = _loc9_ + this.getSubAreaInfoStr(_loc6_,_loc6_.name);
         }
         if(_loc5_ || _loc6_)
         {
            tooltipApi.update("cartographyCurrentSubArea","search",this._searchSelectedItem,null,_loc9_);
         }
      }
      
      override public function onCloseUi(param1:String) : Boolean
      {
         if(this.gdSearchAll.visible)
         {
            this.onRelease(this.btn_closeSearch);
            sysApi.removeFocus();
            return true;
         }
         return super.onCloseUi(param1);
      }
      
      private function switchToConquest() : void
      {
         this.tiSearch.text = "";
         this.btn_closeSearch.visible = false;
         if(!this._conquestMode)
         {
            this.ctr_locTree.visible = false;
         }
         else
         {
            this.ctr_locTree.visible = true;
         }
         this.switchConquestMode();
      }
      
      private function switchConquestMode() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(this._conquestMode)
         {
            this.onRelease(this.btn_closeSearch);
            if(this._updateConquestAreas)
            {
               this.updateConquestSubarea();
            }
            __lastAreaShape = "";
            if(this._dataProvider == null)
            {
               this._dataProvider = __allAreas;
            }
            this.searchFilter();
            this._lastLayer = "AllAreas";
            showAreaShape(NORMAL_AREAS,true);
            showAreaShape(WEAKENED_AREAS,true);
            showAreaShape(VULNERABLE_AREAS,true);
            showAreaShape(VILLAGES_AREAS,true);
            showAreaShape(CAPTURABLE_AREAS,true);
            showAreaShape(SABOTAGED_AREAS,true);
            this.showHints(this._hintCategoryFiltersListConquest);
            _loc1_ = new Array();
            for each(_loc2_ in this._gdConquestProvider)
            {
               _loc1_.push(_loc2_);
            }
            this.cbx_territory_type.dataProvider = _loc1_;
            this.cbx_territory_type.selectedIndex = 0;
            this.lbl_title.text = uiApi.getText("ui.common.territory") + " (" + __allAreas.children.length + ")";
         }
         else
         {
            if(__worldMapInfo && __worldMapInfo.id != __startWorldMapInfo.id)
            {
               openPlayerCurrentMap();
            }
            __lastAreaShape = "";
            this._lastLayer = "";
            showAreaShape(NORMAL_AREAS,false);
            showAreaShape(WEAKENED_AREAS,false);
            showAreaShape(VULNERABLE_AREAS,false);
            showAreaShape(VILLAGES_AREAS,false);
            showAreaShape(CAPTURABLE_AREAS,false);
            showAreaShape(SABOTAGED_AREAS,false);
            __areaShapeDisplayed = new Array();
            this.showHints(__hintCategoryFiltersList);
         }
         mapViewer.updateMapElements();
      }
      
      private function showConquestAreaShapes(param1:String) : void
      {
         if(param1 == "AllAreas")
         {
            showAreaShape(NORMAL_AREAS,true);
            showAreaShape(WEAKENED_AREAS,true);
            showAreaShape(VULNERABLE_AREAS,true);
            showAreaShape(VILLAGES_AREAS,true);
            showAreaShape(CAPTURABLE_AREAS,true);
            showAreaShape(SABOTAGED_AREAS,true);
         }
         else
         {
            showAreaShape(param1,true);
         }
      }
      
      private function updateLayerAreaShapes(param1:String) : void
      {
         this._lastLayer = param1;
         this._lastAreaShapeDisplayed = new Array();
         var _loc2_:int = __areaShapeDisplayed.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._lastAreaShapeDisplayed.push(__areaShapeDisplayed[_loc3_]);
            _loc3_++;
         }
         __areaShapeDisplayed = new Array();
         this.showConquestAreaShapes(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(__areaShapeDisplayed.indexOf(this._lastAreaShapeDisplayed[_loc4_]) == -1)
            {
               showAreaShape(this._lastAreaShapeDisplayed[_loc4_],false);
            }
            _loc4_++;
         }
      }
      
      private function addAreaShapesFromData(param1:Object, param2:uint = 0, param3:Number = 1, param4:uint = 0, param5:Number = 0.4, param6:int = 4) : void
      {
         var _loc7_:AllianceWrapper = null;
         var _loc8_:Object = null;
         var _loc9_:SubArea = null;
         var _loc10_:PrismSubAreaWrapper = null;
         for each(_loc8_ in param1.children)
         {
            _loc9_ = _loc8_.data;
            _loc10_ = socialApi.getPrismSubAreaById(_loc9_.id);
            if(_loc10_ && _loc10_.mapId != -1)
            {
               _loc7_ = !_loc10_.alliance?socialApi.getAlliance():_loc10_.alliance;
               mapViewer.addAreaShape(param1.layer,"shape" + _loc9_.id,mapApi.getSubAreaShape(_loc9_.id),_loc7_.backEmblem.color,0.6,_loc7_.backEmblem.color,0.4,param6);
            }
         }
      }
      
      private function updateConquestSubarea(param1:Boolean = true) : void
      {
         var _loc2_:PrismSubAreaWrapper = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         if(!__conquestSubAreasInfos)
         {
            return;
         }
         if(!__allAreas)
         {
            this._gdConquestProvider = new Array();
            __allAreas = {
               "label":uiApi.getText("ui.pvp.conquestAllAreas"),
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":"AllAreas",
               "colorKey":"all_areas_color"
            };
            __normalAreas = {
               "label":uiApi.getText("ui.prism.cartography.normal"),
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":NORMAL_AREAS,
               "colorKey":"normal_areas_color"
            };
            __weakenedAreas = {
               "label":uiApi.getText("ui.prism.cartography.weakened"),
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":WEAKENED_AREAS,
               "colorKey":"weakened_areas_color"
            };
            __vulnerableAreas = {
               "label":uiApi.getText("ui.prism.cartography.vulnerable"),
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":VULNERABLE_AREAS,
               "colorKey":"vulnerable_areas_color"
            };
            __villagesAreas = {
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":VILLAGES_AREAS
            };
            __capturableAreas = {
               "label":uiApi.getText("ui.pvp.conquestCapturableAreas"),
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":CAPTURABLE_AREAS,
               "colorKey":"capturable_areas_color"
            };
            __sabotagedAreas = {
               "label":uiApi.getText("ui.prism.cartography.sabotaged"),
               "children":[],
               "expend":false,
               "type":"areaShape",
               "layer":SABOTAGED_AREAS,
               "colorKey":"sabotaged_areas_color"
            };
            this._gdConquestProvider.unshift(__allAreas);
            this._gdConquestProvider.push(__capturableAreas);
            this._gdConquestProvider.push(__normalAreas);
            this._gdConquestProvider.push(__weakenedAreas);
            this._gdConquestProvider.push(__vulnerableAreas);
            this._gdConquestProvider.push(__sabotagedAreas);
            this._dataProvider = __allAreas;
            _loc4_ = new Array();
            _loc4_.push(__normalAreas);
            _loc4_.push(__weakenedAreas);
            _loc4_.push(__vulnerableAreas);
            _loc4_.push(__capturableAreas);
            _loc4_.push(__sabotagedAreas);
            this.gd_tooltip.dataProvider = _loc4_;
         }
         for each(_loc2_ in __conquestSubAreasInfos)
         {
            updatePrismAndSubareaStatus(_loc2_,param1);
         }
         for each(_loc3_ in this._gdConquestProvider)
         {
            _loc3_.children.sort(this.compareSubAreaItem);
         }
         if(__weakenedAreas.children.length > 0)
         {
            __weakenedAreas.children.sortOn("vulnerabilityDate");
         }
         this._updateConquestAreas = false;
      }
      
      private function compareSubAreaItem(param1:Object, param2:Object) : int
      {
         var _loc3_:int = 0;
         var _loc4_:String = utilApi.noAccent(param1.label);
         var _loc5_:String = utilApi.noAccent(param2.label);
         if(_loc4_ > _loc5_)
         {
            _loc3_ = 1;
         }
         else if(_loc4_ < _loc5_)
         {
            _loc3_ = -1;
         }
         return _loc3_;
      }
      
      private function makeProvider(param1:Object = null, param2:Boolean = false) : *
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc3_:Array = new Array();
         var _loc4_:Object = mapApi.getAllSuperArea();
         for each(_loc5_ in _loc4_)
         {
            _loc3_[_loc5_.id] = {
               "label":_loc5_.name,
               "children":[],
               "expend":param2,
               "type":"superarea",
               "data":_loc5_
            };
         }
         if(!param1)
         {
            if(!__subAreaList)
            {
               __subAreaList = mapApi.getAllSubArea();
            }
            param1 = __subAreaList;
         }
         for each(_loc6_ in param1)
         {
            if(_loc6_)
            {
               _loc7_ = _loc6_.area;
               if(_loc7_ && _loc7_.name && _loc6_ && _loc6_.name && _loc6_.customWorldMap)
               {
                  if(!_loc3_[_loc7_.superAreaId].children[_loc7_.id])
                  {
                     _loc3_[_loc7_.superAreaId].children[_loc7_.id] = {
                        "label":_loc7_.name,
                        "children":[],
                        "parent":_loc3_[_loc7_.superAreaId],
                        "expend":param2,
                        "type":"area",
                        "data":null
                     };
                  }
                  _loc3_[_loc7_.superAreaId].children[_loc7_.id].children.push({
                     "label":_loc6_.name,
                     "children":null,
                     "parent":_loc3_[_loc7_.superAreaId].children[_loc7_.id],
                     "type":"subarea",
                     "data":_loc6_
                  });
               }
            }
         }
         return _loc3_;
      }
      
      private function searchFilter() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._dataProvider.children)
         {
            _loc1_.push(_loc2_);
         }
         if(this._searchCriteria)
         {
            this.gdZone.dataProvider = this.filterSubArea(this._searchCriteria,_loc1_);
         }
         else
         {
            this.gdZone.dataProvider = _loc1_;
         }
      }
      
      private function filterSubArea(param1:String, param2:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:* = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param2)
         {
            if(utilApi.noAccent(_loc4_.label).toLowerCase().indexOf(utilApi.noAccent(param1).toLowerCase()) != -1)
            {
               _loc5_ = new Object();
               for(_loc6_ in _loc4_)
               {
                  if(_loc6_ != "children")
                  {
                     _loc5_[_loc6_] = _loc4_[_loc6_];
                  }
                  else
                  {
                     _loc5_[_loc6_] = this.filterSubArea(param1,_loc4_[_loc6_]);
                  }
               }
               if(_loc5_.children && _loc5_.children.length)
               {
                  _loc5_.expend = true;
               }
               _loc3_.push(_loc5_);
            }
            else
            {
               _loc7_ = this.filterSubArea(param1,_loc4_.children);
               if(_loc7_.length)
               {
                  _loc8_ = new Object();
                  for(_loc9_ in _loc4_)
                  {
                     if(_loc9_ != "children")
                     {
                        _loc8_[_loc9_] = _loc4_[_loc9_];
                     }
                     else
                     {
                        _loc8_[_loc9_] = _loc7_;
                     }
                  }
                  _loc8_.expend = true;
                  _loc3_.push(_loc8_);
               }
            }
         }
         return _loc3_;
      }
      
      override protected function showHints(param1:Array) : void
      {
         super.showHints(param1);
         this.btnFilterTemple.selected = param1[1];
         this.btnFilterBidHouse.selected = param1[2];
         this.btnFilterCraftHouse.selected = param1[3];
         this.btnFilterMisc.selected = param1[4];
         this.btnFilterConquest.selected = param1[5];
         this.btnFilterDungeon.selected = param1[6];
         this.btnFilterPrivate.selected = param1[7];
         this.btnFilterFlags.selected = param1[8];
         this.btnFilterTransport.selected = param1[9];
      }
      
      private function onSortConquest(param1:uint) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._dataProvider.children)
         {
            if(param1 == SORT_BY_VULNERABILITY_DATE)
            {
               _loc2_.push({
                  "label":_loc3_.label,
                  "data":_loc3_.data,
                  "parent":_loc3_.parent,
                  "type":_loc3_.type,
                  "sortLabel":_loc3_.data.undiatricalName,
                  "prismNextVulnerabilityDate":socialApi.getPrismSubAreaById(_loc3_.data.id).nextVulnerabilityDate
               });
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         if(param1 == SORT_BY_NAME)
         {
            utilApi.sortOnString(_loc2_,"label");
         }
         else if(param1 == SORT_BY_VULNERABILITY_DATE)
         {
            _loc2_.sortOn(["prismNextVulnerabilityDate","sortLabel"],[Array.NUMERIC]);
         }
         this.gdZone.dataProvider = _loc2_;
         this._conquestCurrentSorting = param1;
      }
      
      private function searchAll(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(param1 && param1.length > 2)
         {
            _loc2_ = mapApi.getSearchAllResults(param1);
            this._hasResultsInOtherWorldMap = _loc2_.hasResultsInOtherWorldMap;
            this._searchHints = _loc2_.searchHints;
            if(this._perceptorsHintGroup && this._perceptorsHintGroup.data.length > 0)
            {
               _loc3_ = utilApi.noAccent(this._perceptorsHintGroup.name).toLowerCase().indexOf(utilApi.noAccent(param1).toLowerCase());
               if(_loc3_ != -1)
               {
                  this._perceptorsHintGroup.label = this._perceptorsHintGroup.name.substring(0,_loc3_) + "<b>" + this._perceptorsHintGroup.name.substring(_loc3_,param1.length) + "</b>" + this._perceptorsHintGroup.name.substring(_loc3_ + param1.length);
                  _loc2_.results.push(this._perceptorsHintGroup);
               }
            }
            if(this._prismsHintGroup && this._prismsHintGroup.data.length > 0)
            {
               _loc3_ = utilApi.noAccent(this._prismsHintGroup.name).toLowerCase().indexOf(utilApi.noAccent(param1).toLowerCase());
               if(_loc3_ != -1)
               {
                  this._prismsHintGroup.label = this._prismsHintGroup.name.substring(0,_loc3_) + "<b>" + this._prismsHintGroup.name.substring(_loc3_,param1.length) + "</b>" + this._prismsHintGroup.name.substring(_loc3_ + param1.length);
                  _loc2_.results.push(this._prismsHintGroup);
               }
            }
            _loc4_ = _loc2_.results.length * uiApi.me().getConstant("gdSearchAll_slot_height");
            this.gdSearchAll.finalized = false;
            this.gdSearchAll.height = _loc4_ > uiApi.me().getConstant("gdSearchAll_max_height")?Number(uiApi.me().getConstant("gdSearchAll_max_height")):Number(_loc4_);
            this.gdSearchAll.dataProvider = _loc2_.results;
            this.gdSearchAll.selectedIndex = 0;
            this.ctr_search_bg.height = this.gdSearchAll.height + this.gdSearchAll.slotHeight;
            this.ctr_search_bg.width = this.gdSearchAll.height == uiApi.me().getConstant("gdSearchAll_max_height")?Number(this.gdSearchAll.width):Number(this.gdSearchAll.slotWidth);
            if(this.gdSearchAll.dataProvider.length == 0)
            {
               this.lbl_results.text = !this._hasResultsInOtherWorldMap?uiApi.getText("ui.search.noResult"):uiApi.getText("ui.search.resultsInOtherWorldMap");
            }
            else
            {
               _loc5_ = uiApi.processText(uiApi.getText("ui.search.results",this.gdSearchAll.dataProvider.length),"n",this.gdSearchAll.dataProvider.length <= 1);
               if(this._hasResultsInOtherWorldMap)
               {
                  _loc5_ = _loc5_ + ("\n" + uiApi.getText("ui.search.resultsInOtherWorldMap"));
               }
               this.lbl_results.text = _loc5_;
            }
            this.lbl_results.y = this.ctr_search_bg.height - this.lbl_results.textHeight - (this.gdSearchAll.slotHeight / 2 - this.lbl_results.textHeight / 2) - 4;
            this.tx_bg_results.y = this.ctr_search_bg.height;
            this.gdSearchAll.visible = this.ctr_search_bg.visible = true;
            this._lastSearch = param1;
         }
         else
         {
            this.gdSearchAll.visible = this.ctr_search_bg.visible = false;
         }
      }
      
      private function getSubAreaInfoStr(param1:SubArea, param2:String) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc6_:String = "";
         if(this._searchSelectedItem.resourceSubAreaIds)
         {
            _loc5_ = this._searchSelectedItem.resourceSubAreaIds.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(this._searchSelectedItem.resourceSubAreaIds[_loc3_] == param1.id)
               {
                  _loc7_ = this._searchSelectedItem.resourceSubAreaIds[_loc3_ + 1];
                  break;
               }
               _loc3_ = _loc3_ + 2;
            }
            _loc6_ = _loc6_ + (uiApi.getText("ui.common.quantity") + uiApi.getText("ui.common.colon") + _loc7_);
         }
         else if(this._searchSelectedItem.type == ITEM_SEARCH_TYPE && this._searchSelectedItem.subAreasIds)
         {
            _loc5_ = this._searchSelectedItem.subAreasIds.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc8_ = this._searchSelectedItem.subAreasIds[_loc3_];
               _loc9_ = this._searchSelectedItem.subAreasIds[_loc3_ + 1];
               _loc10_ = _loc3_ + 2 + _loc9_;
               _loc4_ = _loc3_ + 2;
               while(_loc4_ < _loc10_)
               {
                  if(this._searchSelectedItem.subAreasIds[_loc4_] == param1.id)
                  {
                     _loc6_ = _loc6_ + ("\n • " + dataApi.getMonsterFromId(_loc8_).name);
                     break;
                  }
                  _loc4_++;
               }
               _loc3_ = _loc3_ + _loc9_;
               _loc3_ = _loc3_ + 2;
            }
            _loc6_ = _loc6_.substr(1,_loc6_.length - 1);
         }
         return _loc6_;
      }
      
      private function showSearchSubArea(param1:int, param2:uint = 3355443, param3:uint = 1096297, param4:Number = 0.6, param5:Number = 0.4) : void
      {
         var _loc9_:Dungeon = null;
         var _loc10_:MapPosition = null;
         var _loc11_:int = 0;
         var _loc12_:Hint = null;
         var _loc13_:Object = null;
         var _loc6_:SubArea = dataApi.getSubArea(param1);
         var _loc7_:String = _loc6_.undiatricalName;
         var _loc8_:int = this.getDungeonId(_loc7_);
         if(_loc8_ > 0)
         {
            if(!mapViewer.getMapElement("search_hint" + param1))
            {
               _loc9_ = dataApi.getDungeon(_loc8_);
               _loc10_ = dataApi.getMapInfo(_loc9_.entranceMapId);
               if(_loc10_)
               {
                  mapViewer.addIcon(SEARCH_HINTS,"search_hint" + param1,__hintIconsRootPath + "422.png",_loc10_.posX,_loc10_.posY,__iconScale,_loc9_.name + " (" + uiApi.getText("ui.common.short.level") + " " + _loc9_.optimalPlayerLevel + ")",true);
               }
            }
         }
         else
         {
            _loc11_ = this.getHintId(_loc7_);
            if(_loc11_ > 0)
            {
               if(!mapViewer.getMapElement("search_hint" + param1))
               {
                  _loc12_ = dataApi.getHintById(_loc11_);
                  mapViewer.addIcon(SEARCH_HINTS,"search_hint" + param1,__hintIconsRootPath + _loc12_.gfx + "png",_loc12_.x,_loc12_.y,__iconScale,_loc12_.name,true);
               }
            }
            else if(!mapViewer.getMapElement("search_shape" + param1))
            {
               mapViewer.addAreaShape(SEARCH_AREAS,"search_shape" + param1,mapApi.getSubAreaShape(param1),param2,param4,param3,param5,4);
               _loc13_ = mapApi.getSubAreaCenter(param1);
               mapViewer.addIcon(SEARCH_AREAS_FLAGS,"search_flag" + param1,null,_loc13_.x,_loc13_.y,2,_loc6_.area.name + " - " + _loc6_.name,true,param3,true,false);
            }
         }
      }
      
      private function removeSearchMapElements() : Boolean
      {
         var _loc3_:Object = null;
         var _loc1_:Object = mapViewer.getMapElementsByLayer(SEARCH_AREAS);
         var _loc2_:Object = mapViewer.getMapElementsByLayer(SEARCH_HINTS);
         for each(_loc3_ in _loc1_)
         {
            mapViewer.removeMapElement(_loc3_);
            mapViewer.removeMapElement(mapViewer.getMapElement("search_flag" + _loc3_.id.split("search_shape")[1]));
         }
         for each(_loc3_ in _loc2_)
         {
            mapViewer.removeMapElement(_loc3_);
         }
         return _loc1_.length > 0 || _loc2_.length > 0;
      }
      
      private function createPrismsSearchGroup(param1:Object) : void
      {
         var _loc2_:PrismSubAreaWrapper = null;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         if(!this._prismsHintGroup)
         {
            this._prismsHintGroup = new Object();
            this._prismsHintGroup.type = HINT_GROUP_SEARCH_TYPE;
            this._prismsHintGroup.name = uiApi.getText("ui.prism.prisms");
            this._prismsHintGroup.data = new Array();
            this._prismsHintGroup.uri = uiApi.me().getConstant("icons") + "420.png";
         }
         this._prismsHintGroup.data.length = 0;
         for each(_loc3_ in param1)
         {
            _loc2_ = _loc3_;
            if(__hintCaptions["prism_" + _loc2_.subAreaId])
            {
               _loc4_ = new Object();
               _loc4_.id = "_prism_" + _loc2_.subAreaId;
               _loc4_.gfx = modCartography.getPrismStateInfo(_loc2_.state).icon;
               _loc4_.x = _loc2_.worldX;
               _loc4_.y = _loc2_.worldY;
               _loc4_.name = __hintCaptions["prism_" + _loc2_.subAreaId];
               this._prismsHintGroup.data.push(_loc4_);
            }
         }
      }
      
      private function updatePrismsSearchGroup(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:PrismSubAreaWrapper = null;
         if(this._searchSelectedItem && this._searchSelectedItem.type == HINT_GROUP_SEARCH_TYPE && this._searchSelectedItem.name == uiApi.getText("ui.prism.prisms"))
         {
            _loc2_ = mapViewer.getMapElementsByLayer(SEARCH_HINTS);
            for each(_loc4_ in param1)
            {
               _loc5_ = socialApi.getPrismSubAreaById(_loc4_);
               for each(_loc3_ in _loc2_)
               {
                  if(_loc3_.id.indexOf("prism_" + _loc4_) != -1)
                  {
                     mapViewer.removeMapElement(_loc3_);
                     mapViewer.addIcon(SEARCH_HINTS,"search_hint_prism_" + _loc4_,__hintIconsRootPath + modCartography.getPrismStateInfo(_loc5_.state).icon + ".png",_loc5_.worldX,_loc5_.worldY,__iconScale,__hintCaptions["prism_" + _loc4_],true);
                  }
               }
            }
            mapViewer.updateMapElements();
         }
      }
      
      private function getDungeonId(param1:String) : int
      {
         var _loc2_:Object = dataApi.queryString(Dungeon,"name",param1);
         if(_loc2_.length > 0)
         {
            return _loc2_[0];
         }
         return 0;
      }
      
      private function getHintId(param1:String) : int
      {
         var _loc2_:Object = dataApi.queryString(Hint,"name",param1);
         if(_loc2_.length > 0)
         {
            return _loc2_[0];
         }
         return 0;
      }
   }
}
