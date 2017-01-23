package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.TaxCollectorStateEnum;
   import d2hooks.GuildTaxCollectorRemoved;
   import d2hooks.TaxCollectorError;
   import d2hooks.TaxCollectorListUpdate;
   import d2hooks.TaxCollectorUpdate;
   
   public class GuildTaxCollector
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _poniesList:Array;
      
      private var _bDescendingSort:Boolean = false;
      
      public var lbl_ponyCount:Label;
      
      public var gd_pony:Grid;
      
      public function GuildTaxCollector()
      {
         this._poniesList = new Array();
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(TaxCollectorListUpdate,this.onTaxCollectorListUpdate);
         this.sysApi.addHook(GuildTaxCollectorRemoved,this.onGuildTaxCollectorRemoved);
         this.sysApi.addHook(TaxCollectorError,this.onTaxCollectorError);
         this.sysApi.addHook(TaxCollectorUpdate,this.onTaxCollectorUpdate);
         this.onTaxCollectorListUpdate();
      }
      
      public function unload() : void
      {
      }
      
      private function refreshGrid() : void
      {
         var _loc1_:uint = this._poniesList.length;
         var _loc2_:uint = this.socialApi.getMaxCollectorCount();
         this.lbl_ponyCount.text = this.uiApi.getText("ui.social.guild.taxCollectorCount",_loc1_,_loc2_);
         this.gd_pony.dataProvider = this._poniesList;
      }
      
      private function onTaxCollectorListUpdate() : void
      {
         var _loc5_:TaxCollectorWrapper = null;
         var _loc6_:TaxCollectorWrapper = null;
         var _loc7_:TaxCollectorWrapper = null;
         var _loc8_:TaxCollectorWrapper = null;
         var _loc9_:TaxCollectorWrapper = null;
         this._poniesList = new Array();
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Object = this.socialApi.getTaxCollectors();
         var _loc4_:int = this.socialApi.getGuild().guildId;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.state == TaxCollectorStateEnum.STATE_WAITING_FOR_HELP && (!_loc5_.guild || _loc5_.guild.guildId == _loc4_))
            {
               this._poniesList.push(_loc5_);
            }
         }
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_.state == TaxCollectorStateEnum.STATE_FIGHTING && (!_loc6_.guild || _loc6_.guild.guildId == _loc4_))
            {
               this._poniesList.push(_loc6_);
            }
         }
         for each(_loc7_ in _loc3_)
         {
            if(_loc7_.state == TaxCollectorStateEnum.STATE_COLLECTING && (!_loc7_.guild || _loc7_.guild.guildId == _loc4_))
            {
               if(_loc7_.additionalInformation.collectorCallerName == this.playerApi.getPlayedCharacterInfo().name)
               {
                  _loc2_.push(_loc7_);
               }
               else
               {
                  _loc1_.push(_loc7_);
               }
            }
         }
         _loc2_.sortOn("pods",Array.NUMERIC | Array.DESCENDING);
         _loc1_.sortOn("pods",Array.NUMERIC | Array.DESCENDING);
         for each(_loc8_ in _loc2_)
         {
            this._poniesList.push(_loc8_);
         }
         for each(_loc9_ in _loc1_)
         {
            this._poniesList.push(_loc9_);
         }
         this.refreshGrid();
      }
      
      private function onGuildTaxCollectorRemoved(param1:uint) : void
      {
         this.onTaxCollectorListUpdate();
      }
      
      private function onTaxCollectorUpdate(param1:int) : void
      {
         var _loc2_:TaxCollectorWrapper = null;
         var _loc3_:TaxCollectorWrapper = null;
         for each(_loc2_ in this._poniesList)
         {
            if(_loc2_.uniqueId == param1)
            {
               return;
            }
         }
         _loc3_ = this.socialApi.getTaxCollectors()[param1];
         if(!_loc3_.guild || _loc3_.guild.guildId == this.socialApi.getGuild().guildId)
         {
            this._poniesList.push(_loc3_);
            this.refreshGrid();
         }
      }
      
      private function onTaxCollectorError(param1:uint) : void
      {
         this.sysApi.log(16,"Tax collector error n°" + param1);
      }
      
      public function onRelease(param1:Object) : void
      {
      }
   }
}
