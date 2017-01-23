package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildHouseWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.GuildHouseTeleportRequest;
   import d2hooks.CurrentMap;
   import d2hooks.GuildHouseAdd;
   import d2hooks.GuildHouseRemoved;
   import d2hooks.GuildHousesUpdate;
   import flash.utils.Dictionary;
   
   public class GuildHouses
   {
      
      private static var _nCurrentTab:int = -1;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      private var _housesList:Array;
      
      private var _skillsList:Array;
      
      private var _rightsList:Array;
      
      private var _selectedHouse:Object;
      
      private var _bHouseDescendingSort:Boolean = false;
      
      private var _bOwnerDescendingSort:Boolean = false;
      
      private var _bCoordDescendingSort:Boolean = false;
      
      private var _interactiveComponentsList:Dictionary;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_infos:GraphicContainer;
      
      public var grid_house:Grid;
      
      public var btn_tabHouse:ButtonContainer;
      
      public var btn_tabOwner:ButtonContainer;
      
      public var btn_tabCoord:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_rights:ButtonContainer;
      
      public var btn_skills:ButtonContainer;
      
      public var grid_skill:Grid;
      
      public function GuildHouses()
      {
         this._interactiveComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         var _loc2_:GuildHouseWrapper = null;
         this.btn_tabHouse.soundId = SoundEnum.TAB;
         this.btn_tabOwner.soundId = SoundEnum.TAB;
         this.btn_tabCoord.soundId = SoundEnum.TAB;
         this.btn_rights.soundId = SoundEnum.TAB;
         this.btn_skills.soundId = SoundEnum.TAB;
         this.sysApi.addHook(GuildHousesUpdate,this.onGuildHousesUpdate);
         this.sysApi.addHook(GuildHouseAdd,this.onGuildHouseAdd);
         this.sysApi.addHook(GuildHouseRemoved,this.onGuildHouseRemoved);
         this.sysApi.addHook(CurrentMap,this.onCurrentMap);
         this.uiApi.addComponentHook(this.grid_house,"onSelectItem");
         this.uiApi.addComponentHook(this.btn_rights,"onRelease");
         this.uiApi.addComponentHook(this.btn_skills,"onRelease");
         this.ctr_infos.visible = false;
         this._skillsList = new Array();
         this._rightsList = new Array();
         this._housesList = new Array();
         for each(_loc2_ in this.socialApi.getGuildHouses())
         {
            this._housesList.push(_loc2_);
         }
         if(_nCurrentTab != -1)
         {
            this.refreshGrid();
         }
      }
      
      public function unload() : void
      {
      }
      
      public function updateSkillLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_skill.text = param1;
         }
         else
         {
            param2.lbl_skill.text = "";
         }
      }
      
      public function updateHouseLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:SubArea = null;
         if(!this._interactiveComponentsList[param2.btn_info.name])
         {
            this.uiApi.addComponentHook(param2.btn_info,"onRelease");
         }
         this._interactiveComponentsList[param2.btn_info.name] = param1;
         if(!this._interactiveComponentsList[param2.btn_join.name])
         {
            this.uiApi.addComponentHook(param2.btn_join,"onRelease");
         }
         this._interactiveComponentsList[param2.btn_join.name] = param1;
         if(param1)
         {
            param2.btn_house.disabled = false;
            param2.btn_house.selected = param3;
            param2.lbl_house.text = param1.houseName;
            param2.lbl_owner.text = param1.ownerName;
            _loc4_ = this.dataApi.getSubArea(param1.subareaId);
            param2.lbl_coord.text = this.dataApi.getArea(_loc4_.areaId).name + " ( " + _loc4_.name + " ) " + param1.worldX + "," + param1.worldY;
            param2.btn_house.visible = true;
            param2.btn_info.visible = true;
            param2.btn_join.visible = true;
         }
         else
         {
            param2.btn_house.selected = false;
            param2.lbl_house.text = "";
            param2.lbl_owner.text = "";
            param2.lbl_coord.text = "";
            param2.btn_house.visible = false;
            param2.btn_info.visible = false;
            param2.btn_join.visible = false;
         }
      }
      
      private function onGuildHousesUpdate() : void
      {
         var _loc1_:GuildHouseWrapper = null;
         this._housesList = new Array();
         for each(_loc1_ in this.socialApi.getGuildHouses())
         {
            this._housesList.push(_loc1_);
         }
         this.refreshGrid();
      }
      
      private function onGuildHouseAdd(param1:GuildHouseWrapper) : void
      {
         this._housesList.push(param1);
         this.refreshGrid();
      }
      
      private function onGuildHouseRemoved(param1:uint) : void
      {
         this.onGuildHousesUpdate();
      }
      
      private function onHouseSelected(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._selectedHouse = param1;
         this._skillsList = new Array();
         this._rightsList = new Array();
         for each(_loc2_ in param1.skillListString)
         {
            this._skillsList.push(_loc2_);
         }
         for each(_loc3_ in param1.guildshareString)
         {
            this._rightsList.push(_loc3_);
         }
         this.lbl_title.text = param1.houseName;
         this.updateSelectedTab();
      }
      
      private function onCurrentMap(param1:uint) : void
      {
         this.uiApi.unloadUi("socialBase");
      }
      
      private function updateSelectedTab() : void
      {
         if(_nCurrentTab == 0)
         {
            this.grid_skill.dataProvider = this._rightsList;
         }
         else if(_nCurrentTab == 1)
         {
            this.grid_skill.dataProvider = this._skillsList;
         }
      }
      
      private function refreshGrid() : void
      {
         this.grid_house.dataProvider = this._housesList;
         if(this._housesList.length == 0)
         {
            this.grid_house.selectedIndex = -1;
         }
         else
         {
            this.grid_house.selectedIndex = 0;
         }
         this.btn_rights.selected = true;
         _nCurrentTab = 0;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_close:
               this.ctr_infos.visible = false;
               break;
            case this.btn_tabHouse:
               if(this._housesList.length == 0)
               {
                  return;
               }
               this._bOwnerDescendingSort = false;
               this._bCoordDescendingSort = false;
               if(this._bHouseDescendingSort)
               {
                  this.grid_house.sortOn("houseName",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               else
               {
                  this.grid_house.sortOn("houseName",Array.CASEINSENSITIVE);
               }
               this._bHouseDescendingSort = !this._bHouseDescendingSort;
               break;
            case this.btn_tabOwner:
               if(this._housesList.length == 0)
               {
                  return;
               }
               this._bHouseDescendingSort = false;
               this._bCoordDescendingSort = false;
               if(this._bOwnerDescendingSort)
               {
                  this.grid_house.sortOn("ownerName",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               else
               {
                  this.grid_house.sortOn("ownerName",Array.CASEINSENSITIVE);
               }
               this._bOwnerDescendingSort = !this._bOwnerDescendingSort;
               break;
            case this.btn_tabCoord:
               if(this._housesList.length == 0)
               {
                  return;
               }
               this._bHouseDescendingSort = false;
               this._bOwnerDescendingSort = false;
               if(this._bCoordDescendingSort)
               {
                  this.grid_house.sortOn("worldX",Array.NUMERIC | Array.DESCENDING);
               }
               else
               {
                  this.grid_house.sortOn("worldX",Array.NUMERIC);
               }
               this._bCoordDescendingSort = !this._bCoordDescendingSort;
               break;
            case this.btn_rights:
               _nCurrentTab = 0;
               this.updateSelectedTab();
               break;
            case this.btn_skills:
               _nCurrentTab = 1;
               this.updateSelectedTab();
               break;
            default:
               if(param1.name.indexOf("btn_info") != -1)
               {
                  _loc2_ = this._interactiveComponentsList[param1.name];
                  if(_loc2_)
                  {
                     this.onHouseSelected(_loc2_);
                     this.ctr_infos.visible = true;
                  }
               }
               else if(param1.name.indexOf("btn_join") != -1)
               {
                  _loc2_ = this._interactiveComponentsList[param1.name];
                  if(_loc2_)
                  {
                     this.sysApi.sendAction(new GuildHouseTeleportRequest(_loc2_.houseId));
                  }
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.grid_house && param1.selectedIndex > -1)
         {
            this.onHouseSelected(this.grid_house.dataProvider[param1.selectedIndex]);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc2_:uint = 7;
         var _loc3_:uint = 1;
         if(_loc4_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
