package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalAllianceInformations;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalGuildInformations;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.GuildFightAlliesListUpdate;
   import d2hooks.GuildFightEnnemiesListUpdate;
   import d2hooks.TaxCollectorUpdate;
   import flash.utils.getTimer;
   import ui.AllianceFights;
   import utils.JoinFightUtil;
   
   public class AllianceFightXmlItem
   {
      
      private static const TYPE_TAX_COLLECTOR:int = 0;
      
      private static const TYPE_PRISM:int = 1;
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      public var utilApi:UtilApi;
      
      private var _data:SocialEntityInFightWrapper;
      
      private var _detailedData:Object;
      
      private var _clockStart:uint;
      
      private var _clockEnd:uint;
      
      private var _clockDuration:uint;
      
      private var _savedTime:int = 0;
      
      private var _previousState:uint = 0;
      
      private var _fighting:Boolean = false;
      
      private var _forceShowType:int = -1;
      
      private var _forceShowFight:int = -1;
      
      private var _attackList:String = "";
      
      private var _defenseList:String = "";
      
      private var _infos:String = "";
      
      private var _timeProgressBar_y:uint;
      
      private var _assetsPath:String;
      
      public var mainCtr:GraphicContainer;
      
      public var tx_fightType:Texture;
      
      public var pb_time:ProgressBar;
      
      public var tx_attackTeam:Texture;
      
      public var tx_defenseTeam:Texture;
      
      public var lbl_name:Label;
      
      public var lbl_loc:Label;
      
      public var lbl_infos:Label;
      
      public var gd_attackTeam:Grid;
      
      public var gd_defenseTeam:Grid;
      
      public function AllianceFightXmlItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
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
         this.uiApi.addComponentHook(this.tx_fightType,"onRollOver");
         this.uiApi.addComponentHook(this.tx_fightType,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_infos,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_infos,"onRollOut");
         this.pb_time.value = 0;
         this.pb_time.visible = false;
         this._clockEnd = 0;
         this._clockDuration = 0;
         this._clockStart = 0;
         this._assetsPath = this.uiApi.me().getConstant("texture");
         this._forceShowType = AllianceFights.getInstance().forceShowType;
         this._forceShowFight = AllianceFights.getInstance().forceShowFight;
         this.update(param1.data,false);
      }
      
      public function unload() : void
      {
         this.pb_time.value = 0;
         this._clockEnd = 0;
         this._clockDuration = 0;
         this._clockStart = 0;
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function update(param1:Object, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:TaxCollectorWrapper = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:PrismSubAreaWrapper = null;
         var _loc9_:Object = null;
         var _loc10_:Number = NaN;
         var _loc11_:* = undefined;
         var _loc12_:String = null;
         var _loc13_:* = undefined;
         this.tx_fightType.uri = this.uiApi.createUri(this._assetsPath + "tx_conquestPrism.png");
         if(param1)
         {
            this._data = param1 as SocialEntityInFightWrapper;
            this.tx_attackTeam.visible = true;
            this.tx_defenseTeam.visible = true;
            this._attackList = this.uiApi.getText("ui.common.attackers") + this.uiApi.getText("ui.common.colon") + "\n";
            this._defenseList = this.uiApi.getText("ui.common.defenders") + this.uiApi.getText("ui.common.colon") + "\n";
            this.gd_attackTeam.visible = true;
            this.gd_defenseTeam.visible = true;
            if(this._forceShowType == this._data.typeId && this._forceShowFight == this._data.uniqueId)
            {
               this.mainCtr.bgColor = this.sysApi.getConfigEntry("colors.grid.over");
            }
            else
            {
               this.mainCtr.bgColor = -1;
            }
            if(this._data.typeId == TYPE_TAX_COLLECTOR)
            {
               _loc4_ = this.socialApi.getTaxCollector(this._data.uniqueId);
               if(!_loc4_)
               {
                  return;
               }
               this.lbl_name.text = _loc4_.firstName + " " + _loc4_.lastName;
               this.lbl_loc.text = this.dataApi.getSubArea(_loc4_.subareaId).name + " (" + _loc4_.mapWorldX + "," + _loc4_.mapWorldY + ")";
               _loc5_ = !!_loc4_.guild?_loc4_.guild.guildName:this.socialApi.getGuild().guildName;
               this.lbl_infos.text = this.uiApi.getText("ui.common.guild") + this.uiApi.getText("ui.common.colon") + _loc5_;
               if(this._data && this._data.enemyCharactersInformations && this._data.enemyCharactersInformations.length > 0)
               {
                  this.gd_attackTeam.dataProvider = this._data.enemyCharactersInformations;
                  for each(_loc6_ in this._data.enemyCharactersInformations)
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
               if(this._data && this._data.allyCharactersInformations && this._data.allyCharactersInformations.length > 0)
               {
                  this.gd_defenseTeam.dataProvider = this._data.allyCharactersInformations;
                  for each(_loc7_ in this._data.allyCharactersInformations)
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
               if(!this.pb_time.visible || this.pb_time.value == 0)
               {
                  this.pb_time.visible = true;
               }
               this._clockEnd = _loc4_.fightTime;
               this._clockDuration = _loc4_.waitTimeForPlacement;
               this._clockStart = getTimer();
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               this.tx_fightType.uri = this.uiApi.createUri(this._assetsPath + "tx_conquestTaxCollector.png");
               this._detailedData = _loc4_;
            }
            else if(this._data.typeId == TYPE_PRISM)
            {
               _loc8_ = this.socialApi.getPrismSubAreaById(this._data.uniqueId);
               this.lbl_name.text = this.uiApi.getText("ui.zaap.prism") + " " + _loc8_.alliance.allianceName;
               this.lbl_loc.text = _loc8_.subAreaName + " (" + _loc8_.worldX + "," + _loc8_.worldY + ")";
               this.lbl_infos.text = this.uiApi.getText("ui.prism.placed",this.timeApi.getDate(_loc8_.placementDate * 1000));
               if(this._data && this._data.enemyCharactersInformations && this._data.enemyCharactersInformations.length > 0)
               {
                  this.gd_attackTeam.dataProvider = this._data.enemyCharactersInformations;
                  for each(_loc11_ in this._data.enemyCharactersInformations)
                  {
                     _loc9_ = _loc11_.playerCharactersInformations;
                     if(_loc9_.level > ProtocolConstantsEnum.MAX_LEVEL)
                     {
                        _loc12_ = this.uiApi.getText("ui.common.short.prestige") + (_loc9_.level - ProtocolConstantsEnum.MAX_LEVEL);
                     }
                     else
                     {
                        _loc12_ = this.uiApi.getText("ui.common.short.level") + _loc9_.level;
                     }
                     if(_loc9_ is CharacterMinimalAllianceInformations)
                     {
                        this._attackList = this._attackList + (_loc9_.name + "  " + _loc12_ + " - " + _loc9_.guild.guildName + " - [" + _loc9_.alliance.allianceTag + "]\n");
                     }
                     else if(_loc9_ is CharacterMinimalGuildInformations)
                     {
                        this._attackList = this._attackList + (_loc9_.name + "  " + _loc12_ + " - " + _loc9_.guild.guildName + "\n");
                     }
                     else
                     {
                        this._attackList = this._attackList + (_loc9_.name + "  " + _loc12_ + "\n");
                     }
                  }
               }
               if(this._data && this._data.allyCharactersInformations && this._data.allyCharactersInformations.length > 0)
               {
                  this.gd_defenseTeam.dataProvider = this._data.allyCharactersInformations;
                  for each(_loc13_ in this._data.allyCharactersInformations)
                  {
                     _loc9_ = _loc13_.playerCharactersInformations;
                     if(_loc9_.level > ProtocolConstantsEnum.MAX_LEVEL)
                     {
                        _loc12_ = this.uiApi.getText("ui.common.short.prestige") + (_loc9_.level - ProtocolConstantsEnum.MAX_LEVEL);
                     }
                     else
                     {
                        _loc12_ = this.uiApi.getText("ui.common.short.level") + _loc9_.level;
                     }
                     if(_loc9_.name == "3451")
                     {
                        this._defenseList = this._defenseList + (this.lbl_name.text + "  " + _loc12_ + "\n");
                     }
                     else if(_loc9_ is CharacterMinimalGuildInformations || _loc9_ is CharacterMinimalAllianceInformations)
                     {
                        this._defenseList = this._defenseList + (_loc9_.name + "  " + _loc12_ + " - " + _loc9_.guild.guildName + "\n");
                     }
                     else
                     {
                        this._defenseList = this._defenseList + (_loc9_.name + "  " + _loc12_ + "\n");
                     }
                  }
               }
               this.pb_time.visible = true;
               this._clockEnd = this._data.fightTime;
               this._clockDuration = this._data.waitTimeForPlacement;
               this._clockStart = getTimer();
               _loc10_ = (this._clockDuration - (this._clockEnd - this._clockStart)) / this._clockDuration;
               this.pb_time.value = _loc10_;
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               if(_loc8_.isVillage)
               {
                  this.tx_fightType.uri = this.uiApi.createUri(this._assetsPath + "tx_conquestVillage.png");
               }
               else
               {
                  this.tx_fightType.uri = this.uiApi.createUri(this._assetsPath + "tx_conquestPrism.png");
               }
               this._detailedData = _loc8_;
            }
         }
         else
         {
            this.pb_time.value = 0;
            this._clockEnd = 0;
            this._clockDuration = 0;
            this._clockStart = 0;
            this.mainCtr.bgColor = -1;
            this.tx_fightType.uri = null;
            this.pb_time.visible = false;
            this.tx_attackTeam.visible = false;
            this.tx_defenseTeam.visible = false;
            this.lbl_name.text = "";
            this.lbl_loc.text = "";
            this.lbl_infos.text = "";
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
            case this.tx_fightType:
               if(this._infos != "")
               {
                  _loc2_ = this._infos;
               }
               break;
            case this.lbl_infos:
               if(this._detailedData && this._data.typeId == TYPE_TAX_COLLECTOR)
               {
                  if(this._detailedData.itemsValue)
                  {
                     _loc2_ = this.uiApi.getText("ui.social.taxCollector.itemsValue",this.utilApi.kamasToString(this._detailedData.itemsValue));
                     if(this._detailedData.kamas)
                     {
                        _loc2_ = _loc2_ + "\n";
                     }
                  }
                  if(this._detailedData.kamas)
                  {
                     _loc2_ = _loc2_ + this.uiApi.getText("ui.social.taxCollector.kamasCollected",this.utilApi.kamasToString(this._detailedData.kamas,""));
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
            case this.tx_fightType:
            case this.lbl_infos:
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
                  JoinFightUtil.swapPlaces(this._data.typeId,this._data.uniqueId,param1.selectedItem.playerCharactersInformations);
               }
               else
               {
                  JoinFightUtil.leave(this._data.typeId,this._data.uniqueId);
               }
            }
         }
      }
      
      public function onSelectEmptyItem(param1:Object, param2:uint) : void
      {
         if(param1 == this.gd_defenseTeam && param2 == SelectMethodEnum.CLICK)
         {
            JoinFightUtil.join(this._data.typeId,this._data.uniqueId);
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(param2 && param2.data)
         {
            _loc3_ = "";
            if(param1 == this.gd_attackTeam)
            {
               _loc4_ = param2.data.playerCharactersInformations;
               if(_loc4_.level > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  _loc5_ = this.uiApi.getText("ui.common.short.prestige") + (_loc4_.level - ProtocolConstantsEnum.MAX_LEVEL);
               }
               else
               {
                  _loc5_ = this.uiApi.getText("ui.common.short.level") + _loc4_.level;
               }
               if(_loc4_ is CharacterMinimalAllianceInformations)
               {
                  _loc3_ = _loc4_.name + "  " + _loc5_ + " - " + _loc4_.guild.guildName + " [" + _loc4_.alliance.allianceTag + "]";
               }
               else if(_loc4_ is CharacterMinimalGuildInformations)
               {
                  _loc3_ = _loc4_.name + "  " + _loc5_ + " - " + _loc4_.guild.guildName;
               }
               else
               {
                  _loc3_ = _loc4_.name + "  " + _loc5_ + "";
               }
            }
            if(param1 == this.gd_defenseTeam)
            {
               _loc4_ = param2.data.playerCharactersInformations;
               if(_loc4_.level > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  _loc5_ = this.uiApi.getText("ui.common.short.prestige") + (_loc4_.level - ProtocolConstantsEnum.MAX_LEVEL);
               }
               else
               {
                  _loc5_ = this.uiApi.getText("ui.common.short.level") + _loc4_.level;
               }
               if(_loc4_.name == "3451")
               {
                  _loc3_ = this.lbl_name.text + "  " + _loc5_ + "";
               }
               else if(_loc4_ is CharacterMinimalGuildInformations || _loc4_ is CharacterMinimalAllianceInformations)
               {
                  _loc3_ = _loc4_.name + "  " + _loc5_ + " - " + _loc4_.guild.guildName;
               }
               else
               {
                  _loc3_ = _loc4_.name + "  " + _loc5_ + "";
               }
            }
            if(_loc3_ != "")
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param2.container,false,"standard",this.sysApi.getEnum("com.ankamagames.berilia.types.LocationEnum").POINT_BOTTOMRIGHT,1,3,null,null,null,"TextInfo");
            }
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
         if(_loc2_ > 1)
         {
            _loc2_ = 0;
         }
         if(_loc1_ >= this._clockEnd)
         {
            this.sysApi.removeEventListener(this.onEnterFrame);
         }
         this.pb_time.value = _loc2_;
      }
      
      private function onGuildFightEnnemiesListUpdate(param1:int, param2:uint) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(this._data && param1 == this._data.typeId && param2 == this._data.uniqueId)
         {
            if(param1 == 0)
            {
               _loc3_ = this.socialApi.getAllFightingTaxCollector(param2).enemyCharactersInformations;
            }
            else if(param1 == 1)
            {
               _loc3_ = this.socialApi.getFightingPrism(param2).enemyCharactersInformations;
            }
            this.gd_attackTeam.dataProvider = _loc3_;
            this._attackList = this.uiApi.getText("ui.common.attackers") + this.uiApi.getText("ui.common.colon") + "\n";
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
            else
            {
               this._attackList = "";
            }
         }
      }
      
      private function onGuildFightAlliesListUpdate(param1:int, param2:uint) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(this._data && param1 == this._data.typeId && param2 == this._data.uniqueId)
         {
            if(param1 == 0)
            {
               _loc3_ = this.socialApi.getAllFightingTaxCollector(param2).allyCharactersInformations;
            }
            else if(param1 == 1)
            {
               _loc3_ = this.socialApi.getFightingPrism(param2).allyCharactersInformations;
            }
            this.gd_defenseTeam.dataProvider = _loc3_;
            this._defenseList = this.uiApi.getText("ui.common.defenders") + this.uiApi.getText("ui.common.colon") + "\n";
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
            else
            {
               this._defenseList = "";
            }
         }
      }
      
      private function onTaxCollectorUpdate(param1:int) : void
      {
         if(this._data && param1 == this._data.uniqueId)
         {
            this.update(this.socialApi.getAllFightingTaxCollector(param1),false);
         }
      }
   }
}
