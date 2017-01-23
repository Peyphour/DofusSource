package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicAllianceInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicGuildInformations;
   import com.ankamagames.dofus.network.types.game.social.AbstractSocialGroupInfos;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.AllianceListRequest;
   import d2actions.BasicWhoIsRequest;
   import d2actions.GuildListRequest;
   import d2enums.ComponentHookList;
   import d2hooks.AllianceList;
   import d2hooks.GuildList;
   import d2hooks.SilentWhoIs;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class Directory
   {
      
      private static const TAB_GUILD:uint = 0;
      
      private static const TAB_ALLIANCE:uint = 1;
      
      private static const SEARCH_TAG:uint = 0;
      
      private static const SEARCH_NAME:uint = 1;
      
      private static const SEARCH_MEMBER_NAME:uint = 2;
       
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var sysApi:SystemApi;
      
      public var chatApi:ChatApi;
      
      private var _currentTab:int = -1;
      
      private var _currentGuildDataProvider;
      
      private var _currentAllianceDataProvider;
      
      private var _guildSortField:String;
      
      private var _guildSortOrderAscending:Boolean = true;
      
      private var _allianceSortField:String;
      
      private var _allianceSortOrderAscending:Boolean = true;
      
      private var _moreBtnList:Dictionary;
      
      private var _sortFieldAssoc:Dictionary;
      
      private var _exactMemberSearchTimer:Timer;
      
      private var _searchText:String = "";
      
      public var btn_guilds:ButtonContainer;
      
      public var btn_alliances:ButtonContainer;
      
      public var btn_search:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_tabGuildName:ButtonContainer;
      
      public var btn_tabGuildLevel:ButtonContainer;
      
      public var btn_tabGuildMembers:ButtonContainer;
      
      public var btn_tabAllianceAbr:ButtonContainer;
      
      public var btn_tabAllianceName:ButtonContainer;
      
      public var btn_tabAllianceSubarea:ButtonContainer;
      
      public var btn_tabAllianceNbMembers:ButtonContainer;
      
      public var btn_tabAllianceGuildNumber:ButtonContainer;
      
      public var ctr_guild:GraphicContainer;
      
      public var inp_searchGuild:Input;
      
      public var btn_closeSearchGuild:ButtonContainer;
      
      public var gd_guilds:Grid;
      
      public var ctr_alliance:GraphicContainer;
      
      public var inp_searchAlliance:Input;
      
      public var btn_closeSearchAlliance:ButtonContainer;
      
      public var gd_alliances:Grid;
      
      public var cb_allianceSearchType:ComboBox;
      
      public var cb_guildSearchType:ComboBox;
      
      public function Directory()
      {
         this._moreBtnList = new Dictionary();
         this._sortFieldAssoc = new Dictionary(true);
         this._exactMemberSearchTimer = new Timer(1000,1);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(AllianceList,this.onAllianceList);
         this.sysApi.addHook(GuildList,this.onGuildList);
         this.sysApi.addHook(SilentWhoIs,this.onWhoisInfo);
         this.uiApi.addComponentHook(this.btn_guilds,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_alliances,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.inp_searchGuild,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_searchAlliance,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_searchGuild,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.inp_searchAlliance,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.cb_allianceSearchType,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_guildSearchType,ComponentHookList.ON_SELECT_ITEM);
         this._sortFieldAssoc[this.btn_tabGuildName] = "guildName";
         this._sortFieldAssoc[this.btn_tabGuildLevel] = "level";
         this._sortFieldAssoc[this.btn_tabGuildMembers] = "nbMembers";
         this._sortFieldAssoc[this.btn_tabAllianceAbr] = "allianceTag";
         this._sortFieldAssoc[this.btn_tabAllianceName] = "allianceName";
         this._sortFieldAssoc[this.btn_tabAllianceSubarea] = "nbSubareas";
         this._sortFieldAssoc[this.btn_tabAllianceNbMembers] = "nbMembers";
         this._sortFieldAssoc[this.btn_tabAllianceGuildNumber] = "nbGuilds";
         if(param1[0] == TAB_GUILD)
         {
            this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_guilds,this.uiApi.me());
            this.btn_guilds.selected = true;
         }
         else
         {
            this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_alliances,this.uiApi.me());
            this.btn_alliances.selected = true;
         }
         this._searchText = this.uiApi.getText("ui.common.search.input");
         this.inp_searchAlliance.text = this._searchText;
         this.inp_searchGuild.text = this._searchText;
         this.cb_allianceSearchType.dataProvider = [{
            "label":this.uiApi.getText("ui.common.name"),
            "type":SEARCH_NAME
         },{
            "label":this.uiApi.getText("ui.alliance.tag"),
            "type":SEARCH_TAG
         },{
            "label":this.uiApi.getText("ui.alliance.memberName"),
            "type":SEARCH_MEMBER_NAME
         }];
         this.cb_allianceSearchType.selectedIndex = 0;
         this.cb_guildSearchType.dataProvider = [{
            "label":this.uiApi.getText("ui.common.name"),
            "type":SEARCH_NAME
         },{
            "label":this.uiApi.getText("ui.alliance.memberName"),
            "type":SEARCH_MEMBER_NAME
         }];
         this.cb_guildSearchType.selectedIndex = 0;
         this._exactMemberSearchTimer.addEventListener(TimerEvent.TIMER,this.onRefreshExactMemberNameFilter);
         this.displaySelectedTab(param1[0]);
      }
      
      public function unload() : void
      {
         this._moreBtnList = null;
         this._currentGuildDataProvider = null;
         this._currentAllianceDataProvider = null;
         this._exactMemberSearchTimer.removeEventListener(TimerEvent.TIMER,this.onRefreshExactMemberNameFilter);
      }
      
      public function updateGuildLine(param1:GuildWrapper, param2:*, param3:Boolean) : void
      {
         var _loc4_:EmblemSymbol = null;
         if(param1)
         {
            param2.lbl_guildLvl.text = param1.level.toString();
            param2.lbl_guildName.text = this.chatApi.getGuildLink(param1,param1.guildName);
            param2.lbl_guildMembers.text = param1.nbMembers.toString();
            if(param1.backEmblem)
            {
               param2.tx_emblemBackGuild.uri = param1.backEmblem.iconUri;
               param2.tx_emblemUpGuild.uri = param1.upEmblem.iconUri;
               this.utilApi.changeColor(param2.tx_emblemBackGuild,param1.backEmblem.color,1);
               _loc4_ = this.dataApi.getEmblemSymbol(param1.upEmblem.idEmblem);
               if(_loc4_.colorizable)
               {
                  this.utilApi.changeColor(param2.tx_emblemUpGuild,param1.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(param2.tx_emblemUpGuild,param1.upEmblem.color,0,true);
               }
            }
         }
         else
         {
            param2.lbl_guildLvl.text = "";
            param2.lbl_guildName.text = "";
            param2.lbl_guildMembers.text = "";
            param2.tx_emblemBackGuild.uri = null;
            param2.tx_emblemUpGuild.uri = null;
         }
      }
      
      public function updateAllianceLine(param1:AllianceWrapper, param2:*, param3:Boolean) : void
      {
         var _loc4_:EmblemSymbol = null;
         if(param1)
         {
            param2.lbl_allianceTag.text = this.chatApi.getAllianceLink(param1,param1.allianceTag);
            param2.lbl_allianceName.text = this.chatApi.getAllianceLink(param1,param1.allianceName);
            param2.lbl_allianceAreas.text = param1.nbSubareas;
            param2.lbl_allianceGuilds.text = param1.nbGuilds;
            param2.lbl_allianceMembers.text = param1.nbMembers;
            if(param1.backEmblem)
            {
               param2.tx_emblemBackAlliance.uri = param1.backEmblem.iconUri;
               param2.tx_emblemUpAlliance.uri = param1.upEmblem.iconUri;
               this.utilApi.changeColor(param2.tx_emblemBackAlliance,param1.backEmblem.color,1);
               _loc4_ = this.dataApi.getEmblemSymbol(param1.upEmblem.idEmblem);
               if(_loc4_ && _loc4_.colorizable)
               {
                  this.utilApi.changeColor(param2.tx_emblemUpAlliance,param1.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(param2.tx_emblemUpAlliance,param1.upEmblem.color,0,true);
               }
            }
            else
            {
               param2.tx_emblemBackAlliance.uri = null;
               param2.tx_emblemUpAlliance.uri = null;
            }
         }
         else
         {
            param2.lbl_allianceTag.text = "";
            param2.lbl_allianceName.text = "";
            param2.lbl_allianceAreas.text = "";
            param2.lbl_allianceGuilds.text = "";
            param2.lbl_allianceMembers.text = "";
            param2.tx_emblemUpAlliance.uri = null;
            param2.tx_emblemBackAlliance.uri = null;
         }
      }
      
      private function displaySelectedTab(param1:uint) : void
      {
         if(this._currentTab == param1)
         {
            return;
         }
         this._currentTab = param1;
         switch(this._currentTab)
         {
            case TAB_GUILD:
               this.ctr_guild.visible = true;
               this.ctr_alliance.visible = false;
               if(this.gd_guilds.dataProvider == null || this.gd_guilds.dataProvider.length == 0)
               {
                  this.sysApi.sendAction(new GuildListRequest());
               }
               break;
            case TAB_ALLIANCE:
               this.ctr_guild.visible = false;
               this.ctr_alliance.visible = true;
               if(this.gd_alliances.dataProvider == null || this.gd_alliances.dataProvider.length == 0)
               {
                  this.sysApi.sendAction(new AllianceListRequest());
               }
         }
      }
      
      private function getSearchTextAlliance() : String
      {
         if(this.inp_searchAlliance.text != this._searchText)
         {
            return this.inp_searchAlliance.text;
         }
         return "";
      }
      
      private function getSearchTextGuild() : String
      {
         if(this.inp_searchGuild.text != this._searchText)
         {
            return this.inp_searchGuild.text;
         }
         return "";
      }
      
      public function onChange(param1:Input) : void
      {
         switch(param1)
         {
            case this.inp_searchGuild:
               this.updateGuildFilter();
               break;
            case this.inp_searchAlliance:
               this.updateAllianceFilter();
         }
      }
      
      private function updateGuildFilter() : void
      {
         var _loc1_:String = this.getSearchTextGuild();
         if(_loc1_ == "")
         {
            this.gd_guilds.dataProvider = this.utilApi["sort"](this._currentGuildDataProvider,"nbMembers",false,true);
            return;
         }
         switch(this.cb_guildSearchType.selectedItem.type)
         {
            case SEARCH_NAME:
               this.gd_guilds.dataProvider = this.utilApi["filter"](this._currentGuildDataProvider,_loc1_,"guildName");
               break;
            case SEARCH_TAG:
               this.gd_guilds.dataProvider = this.utilApi["filter"](this._currentGuildDataProvider,_loc1_,"allianceTag");
               break;
            case SEARCH_MEMBER_NAME:
               this._exactMemberSearchTimer.reset();
               this._exactMemberSearchTimer.start();
         }
      }
      
      private function updateAllianceFilter() : void
      {
         var _loc1_:String = this.getSearchTextAlliance();
         if(_loc1_ == "")
         {
            this.gd_alliances.dataProvider = this.utilApi["sort"](this._currentAllianceDataProvider,"nbSubareas",false,true);
            return;
         }
         switch(this.cb_allianceSearchType.selectedItem.type)
         {
            case SEARCH_NAME:
               this.gd_alliances.dataProvider = this.utilApi["filter"](this._currentAllianceDataProvider,_loc1_,"allianceName");
               break;
            case SEARCH_TAG:
               this.gd_alliances.dataProvider = this.utilApi["filter"](this._currentAllianceDataProvider,_loc1_,"allianceTag");
               break;
            case SEARCH_MEMBER_NAME:
               this._exactMemberSearchTimer.reset();
               this._exactMemberSearchTimer.start();
         }
      }
      
      private function onRefreshExactMemberNameFilter(param1:Event) : void
      {
         if(this._currentTab == TAB_GUILD && this.getSearchTextGuild().length > 2)
         {
            this.sysApi.sendAction(new BasicWhoIsRequest(this.getSearchTextGuild(),false));
         }
         if(this._currentTab == TAB_ALLIANCE && this.getSearchTextAlliance().length > 2)
         {
            this.sysApi.sendAction(new BasicWhoIsRequest(this.getSearchTextAlliance(),false));
         }
      }
      
      private function onGuildList(param1:Object, param2:Boolean, param3:Boolean) : void
      {
         this._currentGuildDataProvider = param1;
         this.gd_guilds.dataProvider = this.utilApi["sort"](this._currentGuildDataProvider,"nbMembers",false,true);
      }
      
      private function onAllianceList(param1:Object, param2:Boolean, param3:Boolean) : void
      {
         this._currentAllianceDataProvider = param1;
         this.gd_alliances.dataProvider = this.utilApi["sort"](this._currentAllianceDataProvider,"nbSubareas",false,true);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.inp_searchGuild:
               if(this.inp_searchGuild.text == this._searchText)
               {
                  this.inp_searchGuild.text = "";
               }
               break;
            case this.inp_searchAlliance:
               if(this.inp_searchAlliance.text == this._searchText)
               {
                  this.inp_searchAlliance.text = "";
               }
               break;
            case this.btn_closeSearchGuild:
               this.inp_searchGuild.text = this._searchText;
               this.updateGuildFilter();
               break;
            case this.btn_closeSearchAlliance:
               this.inp_searchAlliance.text = this._searchText;
               this.updateAllianceFilter();
               break;
            case this.btn_guilds:
               if(this._currentTab != TAB_GUILD)
               {
                  this.displaySelectedTab(TAB_GUILD);
               }
               break;
            case this.btn_alliances:
               if(this._currentTab != TAB_ALLIANCE)
               {
                  this.displaySelectedTab(TAB_ALLIANCE);
               }
               break;
            case this.btn_tabGuildLevel:
            case this.btn_tabGuildMembers:
            case this.btn_tabAllianceGuildNumber:
            case this.btn_tabAllianceNbMembers:
            case this.btn_tabAllianceSubarea:
               if(this._currentTab == TAB_GUILD)
               {
                  this._guildSortOrderAscending = !this._guildSortOrderAscending;
                  this.gd_guilds.dataProvider = this.utilApi["sort"](this.gd_guilds.dataProvider,this._sortFieldAssoc[param1],this._guildSortOrderAscending,true);
               }
               else
               {
                  this._allianceSortOrderAscending = !this._allianceSortOrderAscending;
                  this.gd_alliances.dataProvider = this.utilApi["sort"](this.gd_alliances.dataProvider,this._sortFieldAssoc[param1],this._allianceSortOrderAscending,true);
               }
               break;
            case this.btn_tabGuildName:
            case this.btn_tabAllianceAbr:
            case this.btn_tabAllianceName:
               if(this._currentTab == TAB_GUILD)
               {
                  this._guildSortOrderAscending = !this._guildSortOrderAscending;
                  this.gd_guilds.dataProvider = this.utilApi["sort"](this.gd_guilds.dataProvider,this._sortFieldAssoc[param1],this._guildSortOrderAscending,false);
               }
               else
               {
                  this._allianceSortOrderAscending = !this._allianceSortOrderAscending;
                  this.gd_alliances.dataProvider = this.utilApi["sort"](this.gd_alliances.dataProvider,this._sortFieldAssoc[param1],this._allianceSortOrderAscending,false);
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(this._currentTab == TAB_GUILD)
         {
            this.updateGuildFilter();
         }
         else if(this._currentTab == TAB_ALLIANCE)
         {
            this.updateAllianceFilter();
         }
      }
      
      private function onWhoisInfo(param1:uint, param2:String, param3:uint, param4:Number, param5:String, param6:uint, param7:Object) : void
      {
         var _loc8_:AbstractSocialGroupInfos = null;
         if(param7 && param7.length)
         {
            for each(_loc8_ in param7)
            {
               if(_loc8_ is BasicGuildInformations && this._currentTab == TAB_GUILD)
               {
                  this.gd_guilds.dataProvider = this.utilApi["filter"](this._currentGuildDataProvider,BasicGuildInformations(_loc8_).guildId,"guildId");
               }
               else if(_loc8_ is BasicAllianceInformations && this._currentTab == TAB_ALLIANCE)
               {
                  this.gd_alliances.dataProvider = this.utilApi["filter"](this._currentAllianceDataProvider,BasicAllianceInformations(_loc8_).allianceId,"allianceId");
               }
            }
         }
      }
   }
}
