package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.HouseToSellFilter;
   import d2actions.HouseToSellListRequest;
   import d2actions.LeaveDialogRequest;
   import d2actions.PaddockToSellFilter;
   import d2actions.PaddockToSellListRequest;
   import d2enums.ComponentHookList;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.EstateToSellList;
   import flash.utils.Dictionary;
   
   public class EstateAgency
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var jobsApi:JobsApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _currentPage:uint;
      
      private var _maxPage:uint;
      
      private var _estates:Array;
      
      private var _estateType:uint = 2;
      
      private var _housesAreas:Array;
      
      private var _paddocksAreas:Array;
      
      private var _skills:Array;
      
      private var _houseFilters:Array;
      
      private var _paddockFilters:Array;
      
      private var _aAtLeastNbRoom:Array;
      
      private var _aAtLeastNbChest:Array;
      
      private var _aSkillRequested:Array;
      
      private var _aAtLeastNbMount:Array;
      
      private var _aAtLeastNbMachine:Array;
      
      private var _aHousesAreaRequested:Array;
      
      private var _aPaddocksAreaRequested:Array;
      
      public var windowCtr:GraphicContainer;
      
      public var listCtr:Object;
      
      public var filterCtr:Object;
      
      public var typeCtr:GraphicContainer;
      
      public var gd_estates:Object;
      
      public var cb_estateType:ComboBox;
      
      public var cb_filterRoomMount:ComboBox;
      
      public var cb_filterChestMachine:ComboBox;
      
      public var cb_filterSubarea:ComboBox;
      
      public var cb_filterSkill:ComboBox;
      
      public var btn_tabName:Object;
      
      public var btn_tabLoc:Object;
      
      public var btn_tabCost:Object;
      
      public var btn_prevPage:Object;
      
      public var btn_nextPage:Object;
      
      public var btn_filter:Object;
      
      public var btn_close:Object;
      
      public var lbl_page:Object;
      
      public var lbl_type:Label;
      
      public var inp_filterMaxPrice:Object;
      
      public var bgcb_estateType:TextureBitmap;
      
      public var bgcb_filterSkill:TextureBitmap;
      
      private var tx_kamasList:Dictionary;
      
      public function EstateAgency()
      {
         this._housesAreas = new Array();
         this._paddocksAreas = new Array();
         this._skills = new Array();
         this._houseFilters = new Array();
         this._paddockFilters = new Array();
         this.tx_kamasList = new Dictionary();
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_OPEN);
         this.sysApi.addHook(EstateToSellList,this.onEstateToSellList);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.uiApi.addComponentHook(this.cb_estateType,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_filterRoomMount,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_filterChestMachine,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_filterSubarea,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_filterSkill,ComponentHookList.ON_SELECT_ITEM);
         this._estateType = param1.type;
         this.alignTypeCtr();
         this.inp_filterMaxPrice.restrict = "0-9";
         var _loc2_:Array = new Array(this.uiApi.getText("ui.common.housesWord"),this.uiApi.getText("ui.common.mountPark"));
         this.cb_estateType.dataProvider = _loc2_;
         this.cb_estateType.selectedIndex = this._estateType;
         this.initFilters();
         this.onEstateToSellList(param1.list,param1.index,param1.total,this._estateType);
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("estateForm");
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_CLOSE);
      }
      
      public function updateEstateLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Texture = null;
         if(param1)
         {
            param2.lbl_name.text = "{estate," + param1.index + "::" + param1.name + "}";
            param2.lbl_loc.text = param1.area;
            param2.lbl_cost.text = this.utilApi.kamasToString(param1.price,"");
            _loc4_ = this.tx_kamasList[param2.lbl_cost];
            if(!_loc4_)
            {
               _loc4_ = this.uiApi.createComponent("Texture") as Texture;
               _loc4_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "icon_kama.png");
               _loc4_.finalize();
               this.tx_kamasList[param2.lbl_cost] = _loc4_;
            }
            _loc4_.x = param2.lbl_cost.x + param2.lbl_cost.textWidth + 10;
            _loc4_.y = param2.lbl_cost.y + 4;
            param2.estateCtr.addContent(_loc4_);
         }
         else
         {
            param2.lbl_name.text = "";
            param2.lbl_loc.text = "";
            param2.lbl_cost.text = "";
            if(this.tx_kamasList[param2.lbl_cost])
            {
               this.tx_kamasList[param2.lbl_cost].removeFromParent();
            }
         }
      }
      
      private function initFilters() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this._aAtLeastNbRoom = new Array(this.uiApi.getText("ui.estate.filter.atLeastNbRoom"),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbRoom","2"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbRoom","3"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbRoom","4"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbRoom","5"),"m",false));
         this._aAtLeastNbChest = new Array(this.uiApi.getText("ui.estate.filter.atLeastNbChest"),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbChest","2"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbChest","3"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbChest","4"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbChest","5"),"m",false));
         this._aSkillRequested = new Array(this.uiApi.getText("ui.estate.filter.skillRequested"));
         for each(_loc1_ in this.dataApi.getHouseSkills())
         {
            this._skills.push(_loc1_);
         }
         this._skills.sortOn("name");
         for each(_loc2_ in this._skills)
         {
            this._aSkillRequested.push(_loc2_.name);
         }
         this._aAtLeastNbMount = new Array(this.uiApi.getText("ui.estate.filter.atLeastNbMount"),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMount","5"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMount","10"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMount","15"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMount","20"),"m",false));
         this._aAtLeastNbMachine = new Array(this.uiApi.getText("ui.estate.filter.atLeastNbMachine"),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMachine","5"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMachine","10"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMachine","15"),"m",false),this.uiApi.processText(this.uiApi.getText("ui.estate.filter.nbMachine","20"),"m",false));
         this._aHousesAreaRequested = new Array(this.uiApi.getText("ui.estate.filter.areaRequested"));
         for each(_loc3_ in this.dataApi.getAllArea(true))
         {
            this._housesAreas.push(_loc3_);
         }
         this._housesAreas.sortOn("name");
         for each(_loc4_ in this._housesAreas)
         {
            this._aHousesAreaRequested.push(_loc4_.name);
         }
         this._aPaddocksAreaRequested = new Array(this.uiApi.getText("ui.estate.filter.areaRequested"));
         for each(_loc5_ in this.dataApi.getAllArea(false,true))
         {
            this._paddocksAreas.push(_loc5_);
         }
         this._paddocksAreas.sortOn("name");
         for each(_loc6_ in this._paddocksAreas)
         {
            this._aPaddocksAreaRequested.push(_loc6_.name);
         }
         this._houseFilters = [0,0,0,0,0];
         this._paddockFilters = [0,0,0,0,0];
         this.updateFilters();
      }
      
      private function updateFilters() : void
      {
         if(this._estateType == 0)
         {
            this.cb_filterSubarea.dataProvider = this._aHousesAreaRequested;
            this.cb_filterRoomMount.dataProvider = this._aAtLeastNbRoom;
            this.cb_filterChestMachine.dataProvider = this._aAtLeastNbChest;
            this.cb_filterSkill.dataProvider = this._aSkillRequested;
            this.cb_filterSkill.visible = this.bgcb_filterSkill.visible = true;
            this.cb_filterChestMachine.selectedIndex = this._houseFilters[0];
            this.cb_filterRoomMount.selectedIndex = this._houseFilters[1];
            this.cb_filterSkill.selectedIndex = this._houseFilters[2];
            this.cb_filterSubarea.selectedIndex = this._houseFilters[3];
            this.inp_filterMaxPrice.text = this._houseFilters[4] == 0?"":this._houseFilters[4];
         }
         else if(this._estateType == 1)
         {
            this.cb_filterSubarea.dataProvider = this._aPaddocksAreaRequested;
            this.cb_filterRoomMount.dataProvider = this._aAtLeastNbMount;
            this.cb_filterChestMachine.dataProvider = this._aAtLeastNbMachine;
            this.cb_filterSkill.visible = this.bgcb_filterSkill.visible = false;
            this.cb_filterChestMachine.selectedIndex = this._paddockFilters[0];
            this.cb_filterRoomMount.selectedIndex = this._paddockFilters[1];
            this.cb_filterSubarea.selectedIndex = this._paddockFilters[3];
            this.inp_filterMaxPrice.text = this._paddockFilters[4] == 0?"":this._paddockFilters[4];
         }
      }
      
      private function alignTypeCtr() : void
      {
         this.lbl_type.fullWidth();
         this.bgcb_estateType.x = this.lbl_type.x + this.lbl_type.width;
         this.typeCtr.x = this.windowCtr.width / 2 - (this.lbl_type.width + this.bgcb_estateType.width) / 2 - 20;
      }
      
      public function onEstateToSellList(param1:Object, param2:uint, param3:uint, param4:uint = 0) : void
      {
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_.push({
               "index":_loc6_,
               "name":param1[_loc6_].name,
               "area":param1[_loc6_].area,
               "price":param1[_loc6_].price
            });
            _loc6_++;
         }
         this.gd_estates.dataProvider = _loc5_;
         this._currentPage = param2;
         this._maxPage = Math.max(param3,1);
         this.lbl_page.text = param2 + "/" + this._maxPage;
         if(param2 == 1)
         {
            this.btn_prevPage.visible = false;
         }
         else
         {
            this.btn_prevPage.visible = true;
         }
         if(param2 == this._maxPage)
         {
            this.btn_nextPage.visible = false;
         }
         else
         {
            this.btn_nextPage.visible = true;
         }
         if(param4 != this._estateType)
         {
            this._estateType = param4;
            this.updateFilters();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_filter:
               _loc2_ = -1;
               if(!this._estateType)
               {
                  for each(_loc3_ in this._housesAreas)
                  {
                     if(_loc3_.name == this.cb_filterSubarea.value)
                     {
                        _loc2_ = _loc3_.id;
                     }
                  }
                  _loc4_ = 0;
                  for each(_loc5_ in this._skills)
                  {
                     if(_loc5_.name == this.cb_filterSkill.value)
                     {
                        _loc4_ = _loc5_.id;
                     }
                  }
                  this._houseFilters[0] = this.cb_filterChestMachine.selectedIndex + 1;
                  this._houseFilters[1] = this.cb_filterRoomMount.selectedIndex + 1;
                  this._houseFilters[2] = this.cb_filterSkill.selectedIndex;
                  this._houseFilters[3] = this.cb_filterSubarea.selectedIndex;
                  this._houseFilters[4] = 0;
                  if(this.inp_filterMaxPrice.text != "")
                  {
                     this._houseFilters[4] = this.utilApi.stringToKamas(this.inp_filterMaxPrice.text);
                  }
                  this.sysApi.sendAction(new HouseToSellFilter(_loc2_,this._houseFilters[1],this._houseFilters[0],_loc4_,this._houseFilters[4]));
                  this.sysApi.sendAction(new HouseToSellListRequest(1));
               }
               else
               {
                  for each(_loc3_ in this._paddocksAreas)
                  {
                     if(_loc3_.name == this.cb_filterSubarea.value)
                     {
                        _loc2_ = _loc3_.id;
                     }
                  }
                  this._paddockFilters[0] = this.cb_filterChestMachine.selectedIndex;
                  this._paddockFilters[1] = this.cb_filterRoomMount.selectedIndex;
                  this._paddockFilters[3] = this.cb_filterSubarea.selectedIndex;
                  this._paddockFilters[4] = 0;
                  if(this.inp_filterMaxPrice.text != "")
                  {
                     this._paddockFilters[4] = this.utilApi.stringToKamas(this.inp_filterMaxPrice.text);
                  }
                  this.sysApi.sendAction(new PaddockToSellFilter(_loc2_,this._paddockFilters[1] * 5,this._paddockFilters[0] * 5,this._paddockFilters[4]));
                  this.sysApi.sendAction(new PaddockToSellListRequest(1));
               }
               break;
            case this.btn_nextPage:
               if(this._currentPage + 1 <= this._maxPage)
               {
                  if(!this._estateType)
                  {
                     this.sysApi.sendAction(new HouseToSellListRequest(++this._currentPage));
                  }
                  else
                  {
                     this.sysApi.sendAction(new PaddockToSellListRequest(++this._currentPage));
                  }
               }
               break;
            case this.btn_prevPage:
               if(this._currentPage - 1 >= 0)
               {
                  if(!this._estateType)
                  {
                     this.sysApi.sendAction(new HouseToSellListRequest(--this._currentPage));
                  }
                  else
                  {
                     this.sysApi.sendAction(new PaddockToSellListRequest(--this._currentPage));
                  }
               }
               break;
            case this.btn_tabName:
               if(this._bDescendingSort)
               {
                  this.gd_estates.sortOn("name",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_estates.sortOn("name",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabLoc:
               if(this._bDescendingSort)
               {
                  this.gd_estates.sortOn("area");
               }
               else
               {
                  this.gd_estates.sortOn("area",Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabCost:
               if(this._bDescendingSort)
               {
                  this.gd_estates.sortOn("price",Array.NUMERIC);
               }
               else
               {
                  this.gd_estates.sortOn("price",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
      }
      
      public function onRollOut(param1:Object) : void
      {
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 != 7)
         {
            switch(param1)
            {
               case this.cb_estateType:
                  if(!this.cb_estateType.selectedIndex)
                  {
                     this.sysApi.sendAction(new HouseToSellListRequest(1));
                  }
                  else
                  {
                     this.sysApi.sendAction(new PaddockToSellListRequest(1));
                  }
                  break;
               case this.cb_filterRoomMount:
                  break;
               case this.cb_filterChestMachine:
                  break;
               case this.cb_filterSubarea:
                  break;
               case this.cb_filterSkill:
            }
         }
      }
   }
}
