package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.TaxCollectorStateEnum;
   import d2hooks.GuildFightAlliesListUpdate;
   import d2hooks.GuildFightEnnemiesListUpdate;
   import d2hooks.TaxCollectorUpdate;
   import flash.utils.getTimer;
   import utils.JoinFightUtil;
   
   public class PonyXmlItem
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      public var utilApi:UtilApi;
      
      private var _grid:Object;
      
      private var _data:TaxCollectorWrapper;
      
      private var _clockStart:uint;
      
      private var _clockEnd:uint;
      
      private var _clockDuration:uint;
      
      private var _previousState:uint = 0;
      
      private var _fighting:Boolean = false;
      
      private var _attackList:String = "";
      
      private var _defenseList:String = "";
      
      private var _infos:String = "";
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_mine:GraphicContainer;
      
      public var tx_mine:Texture;
      
      public var tx_fightState:Texture;
      
      public var pb_time:ProgressBar;
      
      public var tx_attackTeam:Texture;
      
      public var tx_defenseTeam:Texture;
      
      public var lbl_ponyName:Label;
      
      public var lbl_ponyLoc:Label;
      
      public var lbl_ponyPodsXp:Label;
      
      public var gd_attackTeam:Grid;
      
      public var gd_defenseTeam:Grid;
      
      public function PonyXmlItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._grid = param1.grid;
         this.mainCtr.mouseEnabled = true;
         this.sysApi.addHook(GuildFightEnnemiesListUpdate,this.onGuildFightEnnemiesListUpdate);
         this.sysApi.addHook(GuildFightAlliesListUpdate,this.onGuildFightAlliesListUpdate);
         this.sysApi.addHook(TaxCollectorUpdate,this.onTaxCollectorUpdate);
         this.gd_attackTeam.mouseEnabled = true;
         this.uiApi.addComponentHook(this.gd_defenseTeam,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_defenseTeam,"onSelectEmptyItem");
         this.uiApi.addComponentHook(this.gd_defenseTeam,"onItemRollOver");
         this.uiApi.addComponentHook(this.gd_defenseTeam,"onItemRollOut");
         this.uiApi.addComponentHook(this.gd_attackTeam,"onItemRollOver");
         this.uiApi.addComponentHook(this.gd_attackTeam,"onItemRollOut");
         this.uiApi.addComponentHook(this.tx_attackTeam,"onRollOver");
         this.uiApi.addComponentHook(this.tx_attackTeam,"onRollOut");
         this.uiApi.addComponentHook(this.tx_defenseTeam,"onRollOver");
         this.uiApi.addComponentHook(this.tx_defenseTeam,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_ponyPodsXp,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_ponyPodsXp,"onRollOut");
         this.uiApi.addComponentHook(this.ctr_mine,"onRollOver");
         this.uiApi.addComponentHook(this.ctr_mine,"onRollOut");
         this.uiApi.addComponentHook(this.tx_mine,"onRollOver");
         this.uiApi.addComponentHook(this.tx_mine,"onRollOut");
         this.pb_time.value = 0;
         this.pb_time.visible = false;
         this.update(param1.data,false);
      }
      
      public function unload() : void
      {
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function get data() : TaxCollectorWrapper
      {
         return this._data;
      }
      
      public function update(param1:TaxCollectorWrapper, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:SocialEntityInFightWrapper = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(param1)
         {
            this._data = param1;
            this._previousState = this._data.state;
            this.lbl_ponyName.text = this._data.firstName + " " + this._data.lastName;
            _loc4_ = this.dataApi.getSubArea(this.data.subareaId).worldmap.id;
            this.lbl_ponyLoc.text = this.dataApi.getSubArea(this._data.subareaId).name + " ({taxcollectorPosition," + this._data.mapWorldX + "," + this._data.mapWorldY + "," + _loc4_ + "," + this._data.uniqueId + "::" + this._data.mapWorldX + "," + this._data.mapWorldY + "})";
            if(this.sysApi.getCurrentServer().gameTypeId == 1)
            {
               if(this._data.pods == 0)
               {
                  this.lbl_ponyPodsXp.text = "";
               }
               else
               {
                  this.lbl_ponyPodsXp.text = this.uiApi.processText(this.uiApi.getText("ui.common.short.weight",this._data.pods),"m",this._data.pods <= 1);
               }
            }
            else
            {
               this.lbl_ponyPodsXp.text = this.uiApi.getText("ui.social.thingsTaxCollectorGet",this.uiApi.processText(this.uiApi.getText("ui.common.short.weight",this._data.pods),"m",this._data.pods <= 1),this.utilApi.kamasToString(this._data.experience,""));
            }
            if(this._data.additionalInformation.collectorCallerName != this.playerApi.getPlayedCharacterInfo().name)
            {
               this.ctr_mine.bgAlpha = 0;
               this.tx_mine.visible = false;
            }
            else
            {
               this.ctr_mine.bgAlpha = 0.1;
               this.tx_mine.visible = true;
            }
            if(this._data.state == TaxCollectorStateEnum.STATE_COLLECTING)
            {
               this._fighting = false;
               this.tx_attackTeam.visible = false;
               this.tx_defenseTeam.visible = false;
               this.pb_time.value = 0;
               this.pb_time.visible = false;
               this._attackList = "";
               this._defenseList = "";
               this.gd_attackTeam.dataProvider = new Array();
               this.gd_attackTeam.visible = false;
               this.gd_defenseTeam.dataProvider = new Array();
               this.gd_defenseTeam.visible = false;
               this._infos = this.uiApi.getText("ui.social.guild.taxInCollect") + "\n";
            }
            else
            {
               this.pb_time.visible = true;
               this.tx_attackTeam.visible = true;
               this.tx_defenseTeam.visible = true;
               this._attackList = this.uiApi.getText("ui.common.attackers") + " : \n";
               this._defenseList = this.uiApi.getText("ui.common.defenders") + " : \n";
               _loc5_ = this.socialApi.getGuildFightingTaxCollector(this._data.uniqueId);
               if(_loc5_ && _loc5_.enemyCharactersInformations && _loc5_.enemyCharactersInformations.length > 0)
               {
                  this.gd_attackTeam.dataProvider = _loc5_.enemyCharactersInformations;
                  for each(_loc6_ in _loc5_.enemyCharactersInformations)
                  {
                     if(_loc6_.playerCharactersInformations.level > ProtocolConstantsEnum.MAX_LEVEL)
                     {
                        this._attackList = this._attackList + (_loc6_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.prestige") + (_loc6_.playerCharactersInformations.level - ProtocolConstantsEnum.MAX_LEVEL) + "\n");
                     }
                     else
                     {
                        this._attackList = this._attackList + (_loc6_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.level") + _loc6_.playerCharactersInformations.level + "\n");
                     }
                  }
               }
               if(_loc5_ && _loc5_.allyCharactersInformations && _loc5_.allyCharactersInformations.length > 0)
               {
                  this.gd_defenseTeam.dataProvider = _loc5_.allyCharactersInformations;
                  for each(_loc7_ in _loc5_.allyCharactersInformations)
                  {
                     if(_loc7_.playerCharactersInformations.level > ProtocolConstantsEnum.MAX_LEVEL)
                     {
                        this._defenseList = this._defenseList + (_loc7_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.prestige") + (_loc7_.playerCharactersInformations.level - ProtocolConstantsEnum.MAX_LEVEL) + "\n");
                     }
                     else
                     {
                        this._defenseList = this._defenseList + (_loc7_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.level") + _loc7_.playerCharactersInformations.level + "\n");
                     }
                  }
               }
               this.gd_attackTeam.visible = true;
               this.gd_defenseTeam.visible = true;
               if(this._data.state == TaxCollectorStateEnum.STATE_FIGHTING || this._fighting)
               {
                  this.pb_time.value = 0;
                  this.pb_time.visible = false;
                  this._infos = this.uiApi.getText("ui.social.guild.taxInFight") + "\n";
               }
               else if(this._data.state == TaxCollectorStateEnum.STATE_WAITING_FOR_HELP)
               {
                  if(!this.pb_time.visible || this.pb_time.value == 0 || this._clockEnd != this._data.fightTime)
                  {
                     this.pb_time.visible = true;
                     this._clockEnd = this._data.fightTime;
                     this._clockDuration = this._data.waitTimeForPlacement;
                     this._clockStart = getTimer();
                     this.sysApi.addEventListener(this.onEnterFrame,"time");
                  }
                  this._infos = this.uiApi.getText("ui.social.guild.taxInEnterFight") + "\n";
               }
            }
            if(this._fighting)
            {
               this.tx_fightState.uri = this.uiApi.createUri(this.uiApi.me().getConstant("state_uri") + "2");
            }
            else
            {
               this.tx_fightState.uri = this.uiApi.createUri(this.uiApi.me().getConstant("state_uri") + this._data.state);
            }
            this._infos = this._infos + (this.uiApi.getText("ui.common.ownerWord") + this.uiApi.getText("ui.common.colon") + this._data.additionalInformation.collectorCallerName + "\n");
            this._infos = this._infos + (this.uiApi.getText("ui.social.guild.taxStartDate") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDofusDate(this._data.additionalInformation.date * 1000) + " " + this.timeApi.getClock(this._data.additionalInformation.date * 1000));
         }
         else
         {
            this.tx_fightState.uri = null;
            this.pb_time.visible = false;
            this.tx_attackTeam.visible = false;
            this.tx_defenseTeam.visible = false;
            this.lbl_ponyName.text = "";
            this.lbl_ponyLoc.text = "";
            this.lbl_ponyPodsXp.text = "";
            this.ctr_mine.bgAlpha = 0;
            this.tx_mine.visible = false;
            this.gd_attackTeam.dataProvider = new Array();
            this.gd_attackTeam.visible = false;
            this.gd_defenseTeam.dataProvider = new Array();
            this.gd_defenseTeam.visible = false;
         }
         this.uiApi.me().render();
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         switch(param1)
         {
            case this.tx_attackTeam:
               if(this._attackList != "")
               {
                  _loc2_ = this._attackList;
               }
               break;
            case this.tx_defenseTeam:
               if(this._defenseList != "")
               {
                  _loc2_ = this._defenseList;
               }
               break;
            case this.ctr_mine:
               if(this._infos != "")
               {
                  _loc2_ = this._infos;
               }
               break;
            case this.tx_mine:
               _loc2_ = this.uiApi.getText("ui.social.taxcollector.mine");
               break;
            case this.lbl_ponyPodsXp:
               if(this._data)
               {
                  if(this._data.itemsValue)
                  {
                     _loc2_ = this.uiApi.getText("ui.social.taxCollector.itemsValue",this.utilApi.kamasToString(this._data.itemsValue));
                     if(this._data.kamas)
                     {
                        _loc2_ = _loc2_ + "\n";
                     }
                  }
                  if(this._data.kamas)
                  {
                     _loc2_ = _loc2_ + this.uiApi.getText("ui.social.taxCollector.kamasCollected",this.utilApi.kamasToString(this._data.kamas,""));
                  }
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_attackTeam:
            case this.tx_defenseTeam:
            case this.lbl_ponyPodsXp:
            case this.ctr_mine:
            case this.tx_mine:
               this.uiApi.hideTooltip();
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.gd_defenseTeam && param2 == SelectMethodEnum.CLICK)
         {
            if(param1.selectedItem.hasOwnProperty("playerCharactersInformations"))
            {
               if(param1.selectedItem.playerCharactersInformations.id != this.playerApi.id())
               {
                  JoinFightUtil.swapPlaces(0,this._data.uniqueId,param1.selectedItem.playerCharactersInformations);
               }
               else
               {
                  JoinFightUtil.leave(0,this._data.uniqueId);
               }
            }
         }
      }
      
      public function onSelectEmptyItem(param1:Object, param2:uint) : void
      {
         if(param1 == this.gd_defenseTeam && param2 == SelectMethodEnum.CLICK)
         {
            JoinFightUtil.join(0,this._data.uniqueId);
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2 && param2.data)
         {
            _loc3_ = param2.data.playerCharactersInformations.name + "  ";
            if(param2.data.playerCharactersInformations.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.prestige") + (param2.data.playerCharactersInformations.level - ProtocolConstantsEnum.MAX_LEVEL));
            }
            else
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.level") + param2.data.playerCharactersInformations.level);
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param2.container,false,"standard",this.sysApi.getEnum("com.ankamagames.berilia.types.LocationEnum").POINT_BOTTOMRIGHT,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onEnterFrame() : void
      {
         var _loc1_:uint = getTimer();
         var _loc2_:Number = (this._clockDuration - (this._clockEnd - _loc1_)) / this._clockDuration;
         if(_loc1_ >= this._clockEnd)
         {
            this.sysApi.removeEventListener(this.onEnterFrame);
            this._fighting = true;
            this.update(this._data,false,true);
         }
         this.pb_time.value = _loc2_;
      }
      
      private function onGuildFightEnnemiesListUpdate(param1:int, param2:uint) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(this._data && param1 == 0 && param2 == this._data.uniqueId)
         {
            _loc3_ = this.socialApi.getGuildFightingTaxCollector(param2).enemyCharactersInformations;
            this.gd_attackTeam.dataProvider = _loc3_;
            this._attackList = this.uiApi.getText("ui.common.attackers") + " : \n";
            if(_loc3_ && _loc3_.length > 0)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_.playerCharactersInformations.level > ProtocolConstantsEnum.MAX_LEVEL)
                  {
                     this._attackList = this._attackList + (_loc4_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.prestige") + (_loc4_.playerCharactersInformations.level - ProtocolConstantsEnum.MAX_LEVEL) + "\n");
                  }
                  else
                  {
                     this._attackList = this._attackList + (_loc4_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.level") + _loc4_.playerCharactersInformations.level + "\n");
                  }
               }
            }
         }
      }
      
      private function onGuildFightAlliesListUpdate(param1:int, param2:uint) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(this._data && param1 == 0 && param2 == this._data.uniqueId)
         {
            _loc3_ = this.socialApi.getGuildFightingTaxCollector(param2).allyCharactersInformations;
            this.gd_defenseTeam.dataProvider = _loc3_;
            this._defenseList = this.uiApi.getText("ui.common.defenders") + " : \n";
            if(_loc3_ && _loc3_.length > 0)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_.playerCharactersInformations.level > ProtocolConstantsEnum.MAX_LEVEL)
                  {
                     this._defenseList = this._defenseList + (_loc4_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.prestige") + (_loc4_.playerCharactersInformations.level - ProtocolConstantsEnum.MAX_LEVEL) + "\n");
                  }
                  else
                  {
                     this._defenseList = this._defenseList + (_loc4_.playerCharactersInformations.name + "  " + this.uiApi.getText("ui.common.short.level") + _loc4_.playerCharactersInformations.level + "\n");
                  }
               }
            }
         }
      }
      
      private function onTaxCollectorUpdate(param1:int) : void
      {
         if(this._data && param1 == this._data.uniqueId)
         {
            this.update(this.socialApi.getTaxCollectors()[param1],false);
         }
      }
   }
}
