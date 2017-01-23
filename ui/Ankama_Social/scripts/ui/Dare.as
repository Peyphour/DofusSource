package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.DareListRequest;
   import d2hooks.OpenDareSearch;
   import flash.utils.Dictionary;
   
   public class Dare
   {
      
      private static var _self:Dare;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      private var _nCurrentTab:int = -1;
      
      public var searchFilterStates:Dictionary;
      
      public var mainCtr:GraphicContainer;
      
      public var btn_creation:ButtonContainer;
      
      public var btn_totalList:ButtonContainer;
      
      public var btn_mineList:ButtonContainer;
      
      public var btn_successList:ButtonContainer;
      
      public function Dare()
      {
         super();
      }
      
      public static function getInstance() : Dare
      {
         return _self;
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(OpenDareSearch,this.onOpenDareSearch);
         this.searchFilterStates = new Dictionary(true);
         this.searchFilterStates[DareList.SEARCH_FILTER_ID] = true;
         this.searchFilterStates[DareList.SEARCH_FILTER_CREATOR] = true;
         this.searchFilterStates[DareList.SEARCH_FILTER_MONSTER] = true;
         this.searchFilterStates[DareList.SEARCH_FILTER_CRITERIA] = true;
         this.searchFilterStates[DareList.SEARCH_FILTER_SUBAREA] = true;
         this.searchFilterStates[DareList.SEARCH_FILTER_GUILD] = true;
         this.searchFilterStates[DareList.SEARCH_FILTER_ALLIANCE] = true;
         this.btn_totalList.soundId = SoundEnum.TAB;
         this.btn_creation.soundId = SoundEnum.TAB;
         this.btn_mineList.soundId = SoundEnum.TAB;
         this.btn_successList.soundId = SoundEnum.TAB;
         _self = this;
         this.openSelectedTab(rest[0][0],rest[0][1]);
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
         this.uiApi.unloadUi("subDareUi");
         _self = null;
      }
      
      public function get currentTab() : int
      {
         return this._nCurrentTab;
      }
      
      public function openSelectedTab(param1:uint, param2:Object = null) : void
      {
         if(this._nCurrentTab == param1)
         {
            return;
         }
         var _loc3_:String = this.getUiNameByTab(param1);
         if(_loc3_ == this.getUiNameByTab(this._nCurrentTab))
         {
            this.sysApi.log(2,"Rechargement de la liste en mode " + param1);
            if(this.uiApi.getUi(_loc3_))
            {
               this.uiApi.getUi(_loc3_).uiClass.forceOpenSearch(param2);
            }
            this.sysApi.sendAction(new DareListRequest());
         }
         else
         {
            this.uiApi.unloadUi("subDareUi");
            this.uiApi.loadUiInside(_loc3_,this.mainCtr,"subDareUi",[param1,param2]);
            if(_loc3_ == "dareList")
            {
               this.sysApi.sendAction(new DareListRequest());
            }
         }
         this.getButtonByTab(param1).selected = true;
         this._nCurrentTab = param1;
      }
      
      private function getUiNameByTab(param1:int) : String
      {
         if(param1 == 0)
         {
            return "dareList";
         }
         if(param1 == 1)
         {
            return "dareCreation";
         }
         if(param1 == 2)
         {
            return "dareList";
         }
         if(param1 == 3)
         {
            return "dareList";
         }
         return null;
      }
      
      private function getButtonByTab(param1:uint) : Object
      {
         if(param1 == 0)
         {
            return this.btn_totalList;
         }
         if(param1 == 1)
         {
            return this.btn_creation;
         }
         if(param1 == 2)
         {
            return this.btn_mineList;
         }
         if(param1 == 3)
         {
            return this.btn_successList;
         }
         return null;
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_totalList)
         {
            this.openSelectedTab(0);
         }
         else if(param1 == this.btn_creation)
         {
            this.openSelectedTab(1);
         }
         else if(param1 == this.btn_mineList)
         {
            this.openSelectedTab(2);
         }
         else if(param1 == this.btn_successList)
         {
            this.openSelectedTab(3);
         }
      }
      
      public function onOpenDareSearch(param1:String, param2:String = null, param3:Boolean = true) : void
      {
         if(this._nCurrentTab != 1)
         {
            return;
         }
         this.openSelectedTab(0,[param1,param2]);
      }
   }
}
