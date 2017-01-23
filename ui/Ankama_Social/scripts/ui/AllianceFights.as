package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.GuildGetInformations;
   import d2enums.GuildInformationsTypeEnum;
   import d2hooks.AllianceTaxCollectorRemoved;
   import d2hooks.PrismInFightAdded;
   import d2hooks.PrismInFightRemoved;
   import d2hooks.PrismsInFightList;
   import d2hooks.TaxCollectorListUpdate;
   import d2hooks.TaxCollectorUpdate;
   
   public class AllianceFights
   {
      
      private static const TYPE_TAX_COLLECTOR:int = 0;
      
      private static const TYPE_PRISM:int = 1;
      
      private static var _self:AllianceFights;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      private var _fightsList:Array;
      
      private var _forceShowType:int = -1;
      
      private var _forceShowFight:int = -1;
      
      private var _bDescendingSort:Boolean = false;
      
      public var gd_fights:Grid;
      
      public var lbl_fightsCount:Label;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabState:ButtonContainer;
      
      public function AllianceFights()
      {
         this._fightsList = new Array();
         super();
      }
      
      public static function getInstance() : AllianceFights
      {
         return _self;
      }
      
      public function main(... rest) : void
      {
         var _loc2_:SocialEntityInFightWrapper = null;
         _self = this;
         this.sysApi.addHook(TaxCollectorListUpdate,this.onTaxCollectorsListUpdate);
         this.sysApi.addHook(TaxCollectorUpdate,this.onTaxCollectorUpdate);
         this.sysApi.addHook(AllianceTaxCollectorRemoved,this.onAllianceTaxCollectorRemoved);
         this.sysApi.addHook(PrismsInFightList,this.onPrismsInFightList);
         this.sysApi.addHook(PrismInFightAdded,this.onPrismInFightAdded);
         this.sysApi.addHook(PrismInFightRemoved,this.onPrismInFightRemoved);
         this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_TAX_COLLECTOR_ALLIANCE));
         if(rest && rest[0])
         {
            this._forceShowType = rest[0][0];
            this._forceShowFight = rest[0][1];
         }
         else
         {
            this._forceShowType = -1;
            this._forceShowFight = -1;
         }
         for each(_loc2_ in this.socialApi.getAllFightingTaxCollectors())
         {
            this._fightsList.push(_loc2_);
         }
         for each(_loc2_ in this.socialApi.getFightingPrisms())
         {
            this._fightsList.push(_loc2_);
         }
         this.refreshGrid();
      }
      
      public function unload() : void
      {
      }
      
      public function get forceShowType() : int
      {
         return this._forceShowType;
      }
      
      public function get forceShowFight() : int
      {
         return this._forceShowFight;
      }
      
      private function refreshGrid() : void
      {
         var _loc1_:uint = this._fightsList.length;
         this.lbl_fightsCount.text = this.uiApi.processText(this.uiApi.getText("ui.alliance.currentFights",_loc1_),"m",_loc1_ < 2);
         this._fightsList.sortOn("fightTime",Array.NUMERIC | Array.DESCENDING);
         this.gd_fights.dataProvider = this._fightsList;
         var _loc2_:int = 0;
         while(_loc2_ < this._fightsList.length)
         {
            if(this._forceShowType == this._fightsList[_loc2_].typeId && this._forceShowFight == this._fightsList[_loc2_].uniqueId)
            {
               this.gd_fights.moveTo(_loc2_,true);
               return;
            }
            _loc2_++;
         }
      }
      
      private function onTaxCollectorsListUpdate() : void
      {
         var _loc1_:SocialEntityInFightWrapper = null;
         var _loc2_:Array = new Array();
         for each(_loc1_ in this._fightsList)
         {
            if(_loc1_.typeId != TYPE_TAX_COLLECTOR)
            {
               _loc2_.push(_loc1_);
            }
         }
         this._fightsList = _loc2_;
         for each(_loc1_ in this.socialApi.getAllFightingTaxCollectors())
         {
            this._fightsList.push(_loc1_);
         }
         this.refreshGrid();
      }
      
      private function onTaxCollectorUpdate(param1:int) : void
      {
         var _loc4_:SocialEntityInFightWrapper = null;
         var _loc2_:SocialEntityInFightWrapper = this.socialApi.getAllFightingTaxCollector(param1);
         var _loc3_:int = -1;
         for each(_loc4_ in this._fightsList)
         {
            if(_loc4_.uniqueId == param1 && _loc4_.typeId == TYPE_TAX_COLLECTOR)
            {
               _loc3_ = this._fightsList.indexOf(_loc4_);
            }
         }
         if(_loc3_ > -1 && !_loc2_)
         {
            this._fightsList.splice(_loc3_,1);
         }
         else if(_loc3_ == -1 && _loc2_)
         {
            this._fightsList.push(_loc2_);
         }
         this.refreshGrid();
      }
      
      private function onAllianceTaxCollectorRemoved(param1:int) : void
      {
         var _loc3_:SocialEntityInFightWrapper = null;
         var _loc2_:int = -1;
         for each(_loc3_ in this._fightsList)
         {
            if(_loc3_.uniqueId == param1 && _loc3_.typeId == TYPE_TAX_COLLECTOR)
            {
               _loc2_ = this._fightsList.indexOf(_loc3_);
            }
         }
         if(_loc2_ > -1)
         {
            this._fightsList.splice(_loc2_,1);
         }
         this.refreshGrid();
      }
      
      private function onPrismsInFightList() : void
      {
         var _loc1_:SocialEntityInFightWrapper = null;
         var _loc2_:Array = new Array();
         for each(_loc1_ in this._fightsList)
         {
            if(_loc1_.typeId != TYPE_PRISM)
            {
               _loc2_.push(_loc1_);
            }
         }
         this._fightsList = _loc2_;
         for each(_loc1_ in this.socialApi.getFightingPrisms())
         {
            this._fightsList.push(_loc1_);
         }
         this.refreshGrid();
      }
      
      private function onPrismInFightAdded(param1:int) : void
      {
         var _loc2_:SocialEntityInFightWrapper = this.socialApi.getFightingPrism(param1);
         this._fightsList.push(_loc2_);
         this.refreshGrid();
      }
      
      private function onPrismInFightRemoved(param1:int) : void
      {
         var _loc3_:SocialEntityInFightWrapper = null;
         var _loc2_:int = -1;
         for each(_loc3_ in this._fightsList)
         {
            if(_loc3_.uniqueId == param1 && _loc3_.typeId == TYPE_PRISM)
            {
               _loc2_ = this._fightsList.indexOf(_loc3_);
            }
         }
         if(_loc2_ > -1)
         {
            this._fightsList.splice(_loc2_,1);
         }
         this.refreshGrid();
      }
   }
}
