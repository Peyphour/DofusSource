package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.characteristics.Characteristic;
   import com.ankamagames.dofus.datacenter.characteristics.CharacteristicCategory;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.AlignementSideEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.OpenBook;
   import d2actions.OpenSocial;
   import d2enums.BoostableCharacteristicEnum;
   import d2enums.ComponentHookList;
   import d2enums.FightEventEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.CharacterStatsList;
   import d2hooks.FightEvent;
   import d2hooks.StatsUpgradeResult;
   import d2hooks.UiLoaded;
   import flash.utils.Dictionary;
   
   public class CharacterSheetUi
   {
      
      private static const CTR_CAT_TYPE_CAT:String = "ctr_cat";
      
      private static const CTR_CAT_TYPE_ITEM:String = "ctr_caracAdvancedItem";
      
      private static const GAUGE_MAX_WIDTH:uint = 220;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      public var menuApi:ContextMenuApi;
      
      public var socialApi:SocialApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _dataMatrix:Array;
      
      private var _statListWithLife:Array;
      
      private var _caracList:Array;
      
      private var _pdvLine:Object;
      
      private var _componentList:Dictionary;
      
      private var _characterInfos;
      
      private var _characterCharacteristics:CharacterCharacteristicsInformations;
      
      private var _someStatsMayBeScrolled:Boolean = false;
      
      private var _xpInfoText:String;
      
      private var _xpColor:Number;
      
      private var _isUnloading:Boolean;
      
      private var _storageMod:uint;
      
      private var _nCurrentTab:uint = 0;
      
      private var _characteristicsCategoriesData:Object;
      
      private var _currentScrollValue:int;
      
      private var _caracListToDisplay:Array;
      
      private var _lastCategorySelected:Object;
      
      private var _openCatIndex:int;
      
      private var _currentSelectedCatId:int;
      
      private var _openedCategories:Array;
      
      private var _favCategoriesId:Array;
      
      private var _spouse:SpouseWrapper;
      
      private var _guild:GuildWrapper;
      
      private var _alliance:AllianceWrapper;
      
      private var _lastChildIndex:uint;
      
      public var ctr_regular:GraphicContainer;
      
      public var ctr_advanced:GraphicContainer;
      
      public var ctr_charTitleButton:GraphicContainer;
      
      public var ctr_rewardPointButton:GraphicContainer;
      
      public var ctr_healhPointsSmallBlock:GraphicContainer;
      
      public var ctr_actionPointsSmallBlock:GraphicContainer;
      
      public var ctr_movementPointsSmallBlock:GraphicContainer;
      
      public var ctr_pointsToDivide:GraphicContainer;
      
      public var ctr_spellPoints:GraphicContainer;
      
      public var ctr_openGuildTab:GraphicContainer;
      
      public var ctr_openAllianceTab:GraphicContainer;
      
      public var lbl_name:Label;
      
      public var lbl_charTitle:Label;
      
      public var lbl_lvl:Label;
      
      public var lbl_xp:Label;
      
      public var lbl_energy:Label;
      
      public var lbl_statPoints:Label;
      
      public var lbl_advancedName:Label;
      
      public var lbl_advancedLvl:Label;
      
      public var lbl_advancedBaseColumn:Label;
      
      public var lbl_advancedBonusColumn:Label;
      
      public var lbl_rewardPoints:Label;
      
      public var lbl_spellPointsLeft:Label;
      
      public var lbl_healthPointsValue:Label;
      
      public var lbl_actionPointsValue:Label;
      
      public var lbl_movementPointsValue:Label;
      
      public var tx_basicCharPortrait:Texture;
      
      public var tx_advancedCharPortrait:Texture;
      
      public var bgTexturebtn_pvp:Texture;
      
      public var tx_guildEmblemBack:Texture;
      
      public var tx_guildEmblemFront:Texture;
      
      public var tx_allianceEmblemBack:Texture;
      
      public var tx_allianceEmblemFront:Texture;
      
      public var pb_xp:ProgressBar;
      
      public var pb_energy:ProgressBar;
      
      public var gd_carac:Grid;
      
      public var gd_caracAdvanced:Grid;
      
      public var btn_close:ButtonContainer;
      
      public var btn_advanced:ButtonContainer;
      
      public var btn_regular:ButtonContainer;
      
      public var btn_title:ButtonContainer;
      
      public var btn_spellBook:ButtonContainer;
      
      public var btn_job:ButtonContainer;
      
      public var btn_spouse:ButtonContainer;
      
      public var btn_pvp:ButtonContainer;
      
      public function CharacterSheetUi()
      {
         this._componentList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._isUnloading = false;
         this.soundApi.playSound(SoundTypeEnum.CHARACTER_SHEET_OPEN);
         this.ctr_advanced.visible = false;
         this.sysApi.addHook(StatsUpgradeResult,this.onStatsUpgradeResult);
         this.sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         this.sysApi.addHook(FightEvent,this.onFightEvent);
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         this.uiApi.addShortcutHook("closeUi",this.onShortCut);
         this.uiApi.addComponentHook(this.btn_advanced,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_advanced,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_advanced,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_title,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_title,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_spouse,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_spouse,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_pvp,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_pvp,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_charTitleButton,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_charTitleButton,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_charTitleButton,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_rewardPointButton,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_rewardPointButton,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_rewardPointButton,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.pb_xp,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.pb_xp,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.pb_energy,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.pb_energy,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_lvl,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_lvl,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_xp,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_xp,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_energy,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_energy,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_pointsToDivide,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_pointsToDivide,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_caracAdvanced,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_caracAdvanced,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.ctr_healhPointsSmallBlock,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_healhPointsSmallBlock,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_actionPointsSmallBlock,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_actionPointsSmallBlock,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_movementPointsSmallBlock,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_movementPointsSmallBlock,ComponentHookList.ON_ROLL_OUT);
         this.tx_guildEmblemBack.dispatchMessages = true;
         this.tx_guildEmblemFront.dispatchMessages = true;
         this.tx_allianceEmblemBack.dispatchMessages = true;
         this.tx_allianceEmblemFront.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_guildEmblemBack,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_guildEmblemFront,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_allianceEmblemBack,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_allianceEmblemFront,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.ctr_openGuildTab,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_openGuildTab,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_openGuildTab,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_openAllianceTab,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_openAllianceTab,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_openAllianceTab,ComponentHookList.ON_ROLL_OUT);
         this._characterInfos = this.playerApi.getPlayedCharacterInfo();
         this._characterCharacteristics = this.playerApi.characteristics();
         this._characteristicsCategoriesData = this.dataApi.getCharacteristicCategories();
         this._dataMatrix = new Array();
         this._statListWithLife = new Array();
         this._caracList = new Array();
         this._spouse = this.socialApi.getSpouse();
         this._guild = this.socialApi.getGuild();
         this._alliance = this.socialApi.getAlliance();
         if(this._guild)
         {
            this.tx_guildEmblemBack.uri = this._guild.backEmblem.fullSizeIconUri;
            this.tx_guildEmblemFront.uri = this._guild.upEmblem.fullSizeIconUri;
         }
         if(this._alliance)
         {
            this.tx_allianceEmblemBack.uri = this._alliance.backEmblem.fullSizeIconUri;
            this.tx_allianceEmblemFront.uri = this._alliance.upEmblem.fullSizeIconUri;
         }
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_regular,this.uiApi.me());
         this.btn_regular.selected = true;
         this._openedCategories = this.sysApi.getData("openedCharsheetCat");
         if(!this._openedCategories)
         {
            this._openedCategories = new Array();
         }
         this._favCategoriesId = new Array();
         this._favCategoriesId = this.sysApi.getData("favCharsheetCat");
         if(!this._favCategoriesId)
         {
            this._favCategoriesId = new Array();
         }
         var _loc2_:String = !!this._characterInfos.sex?"1":"0";
         var _loc3_:* = this.uiApi.me().getConstant("illus_uri") + this._characterInfos.breed + "_" + _loc2_ + ".png";
         this.tx_basicCharPortrait.uri = this.tx_advancedCharPortrait.uri = this.uiApi.createUri(_loc3_);
         this.statsUpdate();
         this.dataInit();
         this.characterUpdate();
         this.btn_close.state = 0;
         this.btn_close.reset();
      }
      
      public function unload() : void
      {
         if(!this._isUnloading)
         {
            this._isUnloading = true;
            this.uiApi.hideTooltip();
            this.soundApi.playSound(SoundTypeEnum.CHARACTER_SHEET_CLOSE);
         }
      }
      
      public function updateStatLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1)
         {
            if(!this._componentList[param2.lbl_nameStat.name])
            {
               this.uiApi.addComponentHook(param2.lbl_nameStat,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.lbl_nameStat,ComponentHookList.ON_ROLL_OVER);
            }
            this._componentList[param2.lbl_nameStat.name] = param1;
            if(param1.gfxId != "null")
            {
               param2.tx_pictoStat.visible = true;
               param2.tx_pictoStat.uri = this.uiApi.createUri(this.uiApi.me().getConstant("picto_uri") + param1.gfxId);
            }
            else
            {
               param2.tx_pictoStat.uri = null;
            }
            param2.lbl_nameStat.text = param1.text;
            if(param1.id == "lifePoints")
            {
               param2.lbl_valueStat.text = this._characterCharacteristics.lifePoints + " / " + this._characterCharacteristics.maxLifePoints;
            }
            else if(param1.id == "initiative")
            {
               _loc4_ = param1.base + param1.boost + param1.stuff;
               param2.lbl_valueStat.text = int(_loc4_ * this._characterCharacteristics.lifePoints / this._characterCharacteristics.maxLifePoints) + " / " + _loc4_;
            }
            else if(param1.id == "actionPoints" || param1.id == "movementPoints")
            {
               param2.lbl_valueStat.text = this._characterCharacteristics[param1.id + "Current"];
            }
            else
            {
               _loc5_ = param1.base + param1.additionnal + param1.boost + param1.stuff;
               if(_loc5_ != 0)
               {
                  param2.lbl_valueStat.text = _loc5_;
               }
               else
               {
                  param2.lbl_valueStat.text = "-";
               }
            }
         }
         else
         {
            param2.lbl_nameStat.text = "";
            param2.lbl_valueStat.text = "";
            param2.tx_pictoStat.visible = false;
         }
      }
      
      public function updateCaracLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         if(param1)
         {
            if(!this._componentList[param2.btn_plus.name])
            {
               this.uiApi.addComponentHook(param2.btn_plus,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.btn_plus,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.btn_plus,ComponentHookList.ON_ROLL_OVER);
            }
            this._componentList[param2.btn_plus.name] = param1;
            if(!this._componentList[param2.lbl_nameCarac.name])
            {
               this.uiApi.addComponentHook(param2.lbl_nameCarac,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.lbl_nameCarac,ComponentHookList.ON_ROLL_OVER);
            }
            this._componentList[param2.lbl_nameCarac.name] = param1;
            if(!this._componentList[param2.lbl_valueCarac.name])
            {
               this.uiApi.addComponentHook(param2.lbl_valueCarac,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.lbl_valueCarac,ComponentHookList.ON_ROLL_OVER);
            }
            this._componentList[param2.lbl_valueCarac.name] = param1;
            if(param1.gfxId != "null")
            {
               param2.tx_pictoCarac.visible = true;
               param2.tx_pictoCarac.uri = this.uiApi.createUri(this.uiApi.me().getConstant("characteristics") + param1.gfxId + ".png");
            }
            else
            {
               param2.tx_pictoCarac.uri = null;
            }
            param2.tx_gridSeparator.visible = true;
            param2.lbl_nameCarac.text = param1.text;
            _loc4_ = param1.base + param1.additionnal + param1.boost + param1.stuff;
            if(_loc4_ != 0)
            {
               param2.lbl_valueCarac.text = _loc4_;
            }
            else
            {
               param2.lbl_valueCarac.text = "-";
            }
            _loc5_ = param1.id.substr(0,1).toLocaleUpperCase() + param1.id.substr(1);
            _loc6_ = new Array();
            for each(_loc7_ in this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed)["statsPointsFor" + _loc5_])
            {
               _loc6_.push(_loc7_);
            }
            param2.btn_plus.visible = false;
            _loc8_ = 0;
            while(_loc8_ < _loc6_.length)
            {
               if(_loc6_[_loc8_ + 1] && _loc6_[_loc8_ + 1][0] > param1.base && _loc6_[_loc8_][0] <= param1.base || !_loc6_[_loc8_ + 1])
               {
                  if(this._characterCharacteristics.statsPoints >= _loc6_[_loc8_][1] && !this.sysApi.isFightContext())
                  {
                     param2.btn_plus.visible = true;
                  }
               }
               if(param1.additionnal < ProtocolConstantsEnum.MAX_ADDITIONNAL_PER_CARAC && (_loc6_[_loc8_ + 1] && _loc6_[_loc8_ + 1][0] > param1.additionnal && _loc6_[_loc8_][0] <= param1.additionnal || !_loc6_[_loc8_ + 1]))
               {
                  if(this._characterCharacteristics.additionnalPoints >= _loc6_[_loc8_][1] && !this.sysApi.isFightContext())
                  {
                     param2.btn_plus.visible = true;
                  }
               }
               _loc8_++;
            }
         }
         else
         {
            param2.lbl_valueCarac.text = "";
            param2.lbl_nameCarac.text = "";
            param2.btn_plus.visible = false;
            param2.tx_pictoCarac.visible = false;
            param2.tx_gridSeparator.visible = false;
         }
      }
      
      public function updateCategory(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         switch(this.getCatLineType(param1,param4))
         {
            case CTR_CAT_TYPE_CAT:
               param2.lbl_catName.text = param1.name;
               param2.btn_cat.selected = param3;
               if(this._openedCategories.indexOf(param1.id) != -1)
               {
                  param2.tx_catplusminus.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture_uri") + "icon_minus_grey.png");
               }
               else
               {
                  param2.tx_catplusminus.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture_uri") + "icon_plus_grey.png");
               }
               break;
            case CTR_CAT_TYPE_ITEM:
               if(!this._componentList[param2.lbl_name.name])
               {
                  this.uiApi.addComponentHook(param2.lbl_name,ComponentHookList.ON_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.lbl_name,ComponentHookList.ON_ROLL_OVER);
               }
               this._componentList[param2.lbl_name.name] = param1;
               if(!this._componentList[param2.lbl_value.name])
               {
                  this.uiApi.addComponentHook(param2.lbl_value,ComponentHookList.ON_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.lbl_value,ComponentHookList.ON_ROLL_OVER);
               }
               this._componentList[param2.lbl_value.name] = param1;
               param2.lbl_name.cssClass = "p";
               if(param1.gfxId != "null")
               {
                  param2.tx_picto.visible = true;
                  param2.tx_picto.uri = this.uiApi.createUri(this.uiApi.me().getConstant("picto_uri") + param1.gfxId);
               }
               else
               {
                  param2.tx_picto.uri = null;
               }
               if(param1.cat == -1 && param1.numId == -1)
               {
                  param2.lbl_favExplanation.visible = true;
                  param2.lbl_name.visible = false;
                  param2.lbl_value.visible = false;
                  param2.tx_picto.visible = false;
               }
               else
               {
                  param2.lbl_favExplanation.visible = false;
                  param2.lbl_name.visible = true;
                  param2.lbl_value.visible = true;
                  param2.tx_picto.visible = true;
               }
               param2.lbl_name.text = param1.text;
               if(param1.id == "actionPoints" || param1.id == "movementPoints")
               {
                  _loc5_ = this._characterCharacteristics[param1.id + "Current"] - (param1.boost + param1.stuff);
                  if(_loc5_ < 0)
                  {
                     _loc6_ = Math.abs(_loc5_);
                     _loc5_ = 0;
                  }
               }
               _loc7_ = !isNaN(_loc5_)?int(_loc5_):int(param1.base + param1.additionnal);
               _loc8_ = param1.boost + param1.stuff - _loc6_;
               if(String(param1.id).indexOf("%") != -1)
               {
                  _loc9_ = Math.min(50,param1.base + param1.boost + param1.stuff);
               }
               else
               {
                  _loc9_ = _loc7_ + param1.boost + param1.stuff - _loc6_;
               }
               if(_loc9_ != 0)
               {
                  param2.lbl_value.text = _loc9_;
               }
               else
               {
                  param2.lbl_value.text = "-";
               }
         }
      }
      
      public function getCatLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1.isCat)
               {
                  return CTR_CAT_TYPE_CAT;
               }
               return CTR_CAT_TYPE_ITEM;
            default:
               return CTR_CAT_TYPE_ITEM;
         }
      }
      
      public function getCatDataLength(param1:*, param2:Boolean) : *
      {
         if(!param2)
         {
         }
         return 10;
      }
      
      public function restoreChildIndex() : void
      {
         this.uiApi.me().childIndex = this._lastChildIndex;
      }
      
      private function getParsedStat(param1:Object, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         if(param2)
         {
            _loc3_ = this.uiApi.getText("ui.common.base") + this.uiApi.getText("ui.common.colon") + (param1.base + param1.additionnal) + "\n" + this.uiApi.getText("ui.fightend.bonus") + this.uiApi.getText("ui.common.colon") + (param1.boost + param1.stuff);
         }
         else
         {
            _loc3_ = this.uiApi.getText("ui.common.base") + " (" + this.uiApi.getText("ui.charaSheet.natural") + " + " + this.uiApi.getText("ui.charaSheet.additionnal") + ")" + this.uiApi.getText("ui.common.colon") + param1.base + "+" + param1.additionnal + "\n" + this.uiApi.getText("ui.common.equipement") + this.uiApi.getText("ui.common.colon") + param1.stuff + "\n" + this.uiApi.getText("ui.charaSheet.temporaryBonus") + this.uiApi.getText("ui.common.colon") + param1.boost;
         }
         return _loc3_;
      }
      
      private function dataInit() : void
      {
         var _loc1_:CharacteristicCategory = null;
         var _loc2_:Characteristic = null;
         var _loc3_:int = 0;
         var _loc4_:Characteristic = null;
         for each(_loc1_ in this._characteristicsCategoriesData)
         {
            this._dataMatrix.push({
               "name":_loc1_.name,
               "id":_loc1_.id,
               "isCat":true
            });
            for each(_loc3_ in _loc1_.characteristicIds)
            {
               _loc4_ = this.dataApi.getCharacteristic(_loc3_);
               if(_loc4_)
               {
                  this._dataMatrix.push(new CharacteristiqueGridItem(_loc3_,_loc4_.keyword,_loc4_.name,_loc4_.asset,_loc4_.id,_loc4_.upgradable,_loc4_.categoryId));
               }
            }
         }
         _loc2_ = this.dataApi.getCharacteristic(0);
         this._pdvLine = {
            "id":_loc2_.keyword,
            "text":_loc2_.name,
            "gfxId":_loc2_.asset,
            "numId":_loc2_.id,
            "base":0,
            "additionnal":0,
            "stuff":0,
            "boost":0
         };
      }
      
      private function creareFavItemsArray() : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:CharacteristiqueGridItem = null;
         var _loc1_:Array = new Array();
         _loc1_.push({
            "name":this.uiApi.getText("ui.charaSheet.favorite"),
            "id":-1,
            "isCat":true
         });
         if(this._favCategoriesId.length <= 0)
         {
            _loc3_ = new CharacteristiqueGridItem(-1,-1,"",null,-1,false,-1);
            _loc1_.push(_loc3_);
            return _loc1_;
         }
         for each(_loc2_ in this._dataMatrix)
         {
            if(!_loc2_.isCat && this._favCategoriesId.indexOf(_loc2_.numId) != -1)
            {
               _loc3_ = _loc2_.clone();
               _loc3_.cat = -1;
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      private function characterUpdate() : void
      {
         var _loc5_:Number = NaN;
         this._characterCharacteristics = this.playerApi.characteristics();
         this.lbl_advancedName.text = this.lbl_name.text = this._characterInfos.name;
         if(this._characterInfos.level > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.lbl_advancedLvl.text = this.lbl_lvl.text = this.uiApi.getText("ui.common.prestige") + " " + (this._characterInfos.level - ProtocolConstantsEnum.MAX_LEVEL);
            this._xpColor = this.sysApi.getConfigEntry("colors.progressbar.gold");
         }
         else
         {
            this.lbl_advancedLvl.text = this.lbl_lvl.text = this.uiApi.getText("ui.common.level") + " " + this._characterInfos.level;
            this._xpColor = this.sysApi.getConfigEntry("colors.progressbar.blue");
         }
         if(this.playerApi.getTitle())
         {
            this.lbl_charTitle.text = this.playerApi.getTitle().name;
         }
         else
         {
            this.lbl_charTitle.text = this.uiApi.getText("ui.common.noTitle");
         }
         this.pb_xp.barColor = this._xpColor;
         var _loc1_:Number = this._characterCharacteristics.experienceNextLevelFloor - this._characterCharacteristics.experience;
         var _loc2_:Number = (this._characterCharacteristics.experience - this._characterCharacteristics.experienceLevelFloor) / (this._characterCharacteristics.experienceNextLevelFloor - this._characterCharacteristics.experienceLevelFloor);
         this.pb_xp.value = _loc2_;
         this._xpInfoText = this.utilApi.formateIntToString(this._characterCharacteristics.experience);
         this._xpInfoText = this._xpInfoText + (" / " + this.utilApi.formateIntToString(this._characterCharacteristics.experienceNextLevelFloor));
         this._xpInfoText = this._xpInfoText + ("\n" + this.uiApi.getText("ui.common.nextLevel") + this.uiApi.getText("ui.common.colon") + Math.floor(_loc2_ * 100) + " %");
         this._xpInfoText = this._xpInfoText + ("\n" + this.uiApi.getText("ui.common.required") + this.uiApi.getText("ui.common.colon") + this.utilApi.formateIntToString(_loc1_));
         var _loc3_:Number = this._characterCharacteristics.experienceBonusLimit;
         if(_loc3_ && _loc3_ > this._characterCharacteristics.experience)
         {
            if(_loc3_ > this._characterCharacteristics.experienceNextLevelFloor)
            {
               this.pb_xp.innerValue = 1;
            }
            else
            {
               _loc5_ = (_loc3_ - this._characterCharacteristics.experienceLevelFloor) / (this._characterCharacteristics.experienceNextLevelFloor - this._characterCharacteristics.experienceLevelFloor);
               this.pb_xp.innerValue = _loc5_;
            }
            this.pb_xp.innerBarColor = this._xpColor;
            this.pb_xp.innerBarAlpha = 0.3;
            this._xpInfoText = this._xpInfoText + ("\n<i>" + this.uiApi.getText("ui.help.xpBonus",2) + "</i>");
         }
         var _loc4_:Number = this._characterCharacteristics.energyPoints / this._characterCharacteristics.maxEnergyPoints;
         if(_loc4_ <= 0)
         {
            this.pb_energy.visible = false;
         }
         else
         {
            this.pb_energy.visible = true;
            this.pb_energy.value = _loc4_;
         }
         this.btn_spouse.visible = this.socialApi.hasSpouse();
         switch(this.playerApi.getAlignmentSide())
         {
            case AlignementSideEnum.ALIGNMENT_ANGEL:
               this.bgTexturebtn_pvp.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture_uri") + "tx_alignement_bonta.png");
               this.btn_pvp.visible = true;
               break;
            case AlignementSideEnum.ALIGNMENT_EVIL:
               this.bgTexturebtn_pvp.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture_uri") + "tx_alignement_brakmar.png");
               this.btn_pvp.visible = true;
               break;
            default:
               this.btn_pvp.visible = false;
         }
         this.lbl_rewardPoints.text = this.utilApi.kamasToString(this.playerApi.getAchievementPoints(),"") + " " + this.uiApi.getText("ui.common.points");
         this.lbl_spellPointsLeft.text = this.playerApi.characteristics().spellsPoints.toString();
         this.ctr_spellPoints.visible = this.playerApi.characteristics().spellsPoints > 0;
         this.statsUpdate();
      }
      
      private function statsUpdate() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         this._characterCharacteristics = this.playerApi.characteristics();
         this._someStatsMayBeScrolled = false;
         this._statListWithLife.push(this._pdvLine);
         for each(_loc1_ in this._dataMatrix)
         {
            if(!(!_loc1_ || _loc1_.isCat))
            {
               _loc3_ = this._characterCharacteristics[_loc1_.id];
               if(_loc3_ is CharacterBaseCharacteristic)
               {
                  _loc1_.base = _loc3_.base;
                  _loc1_.additionnal = _loc3_.additionnal;
                  _loc1_.stuff = _loc3_.objectsAndMountBonus;
                  _loc1_.boost = _loc3_.contextModif;
               }
               else if(_loc3_ is int)
               {
                  _loc1_.base = _loc3_;
               }
               if(_loc1_.cat == 2 || _loc1_.id == "tackleBlock" || _loc1_.id == "tackleEvade")
               {
                  if(_loc1_.upgradable)
                  {
                     this._caracList.push(_loc1_);
                  }
                  else
                  {
                     this._statListWithLife.push(_loc1_);
                  }
                  if(_loc1_.upgradable && _loc1_.additionnal < ProtocolConstantsEnum.MAX_ADDITIONNAL_PER_CARAC)
                  {
                     this._someStatsMayBeScrolled = true;
                  }
               }
            }
         }
         this.lbl_healthPointsValue.text = this.utilApi.kamasToString(this._characterCharacteristics.maxLifePoints,"");
         this.lbl_actionPointsValue.text = this.utilApi.kamasToString(this._characterCharacteristics.actionPoints.base + this._characterCharacteristics.actionPoints.additionnal + this._characterCharacteristics.actionPoints.contextModif + this._characterCharacteristics.actionPoints.objectsAndMountBonus,"");
         this.lbl_movementPointsValue.text = this.utilApi.kamasToString(this._characterCharacteristics.movementPoints.base + this._characterCharacteristics.movementPoints.additionnal + this._characterCharacteristics.movementPoints.contextModif + this._characterCharacteristics.movementPoints.objectsAndMountBonus,"");
         _loc2_ = !!this._someStatsMayBeScrolled?int(this._characterCharacteristics.statsPoints + this._characterCharacteristics.additionnalPoints):int(this._characterCharacteristics.statsPoints);
         this.lbl_statPoints.text = this.utilApi.kamasToString(_loc2_,"");
         this.gridsUpdate();
      }
      
      private function gridsUpdate() : void
      {
         if(this.ctr_regular.visible)
         {
            this.gd_carac.dataProvider = this._caracList;
         }
         else
         {
            this.displayCategories();
         }
      }
      
      private function displaySelectedTab(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               this.ctr_regular.visible = true;
               this.ctr_advanced.visible = false;
               break;
            case 1:
               this.ctr_regular.visible = false;
               this.ctr_advanced.visible = true;
         }
         this.gridsUpdate();
      }
      
      private function displayCategories(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc10_:Object = null;
         var _loc4_:int = 0;
         if(param1)
         {
            _loc4_ = param1.id;
            if(this._openedCategories.indexOf(_loc4_) != -1)
            {
               this._openedCategories.splice(this._openedCategories.indexOf(_loc4_),1);
            }
            else
            {
               this._openedCategories.push(_loc4_);
            }
         }
         var _loc5_:int = -1;
         var _loc6_:Array = new Array();
         var _loc7_:int = -1;
         var _loc8_:Array = this.creareFavItemsArray();
         var _loc9_:Array = _loc8_.concat(this._dataMatrix);
         for each(_loc10_ in _loc9_)
         {
            if(_loc10_.isCat)
            {
               _loc6_.push(_loc10_);
               _loc5_++;
               if(_loc10_.id == _loc4_)
               {
                  _loc3_ = _loc5_;
               }
            }
            if(!_loc10_.isCat && this._openedCategories.indexOf(_loc10_.cat) != -1)
            {
               _loc6_.push(_loc10_);
               _loc5_++;
            }
         }
         if(_loc7_ >= 0)
         {
            this._openCatIndex = _loc7_;
         }
         else
         {
            this._openCatIndex = 0;
         }
         this._currentSelectedCatId = _loc4_;
         var _loc11_:int = this.gd_caracAdvanced.verticalScrollValue;
         this.gd_caracAdvanced.dataProvider = _loc6_;
         if(this.gd_caracAdvanced.selectedIndex != _loc3_)
         {
            this.gd_caracAdvanced.silent = true;
            this.gd_caracAdvanced.selectedIndex = _loc3_;
            this.gd_caracAdvanced.silent = false;
         }
         this.gd_caracAdvanced.verticalScrollValue = _loc11_;
         this.sysApi.setData("openedCharsheetCat",this._openedCategories);
      }
      
      private function updateFavCatArray(param1:int, param2:Boolean) : void
      {
         if(!param2)
         {
            this._favCategoriesId.push(param1);
         }
         else
         {
            this._favCategoriesId.splice(this._favCategoriesId.indexOf(param1),1);
         }
         this.sysApi.setData("favCharsheetCat",this._favCategoriesId);
         this.displayCategories();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.gd_caracAdvanced)
         {
            if(param2 != GridItemSelectMethodEnum.AUTO && param1.selectedItem.isCat)
            {
               this._currentScrollValue = 0;
               this._caracListToDisplay = new Array();
               this._lastCategorySelected = param1.selectedItem;
               this.displayCategories(param1.selectedItem);
            }
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Array = null;
         if(!param2.data.isCat)
         {
            _loc3_ = new Array();
            if(this._favCategoriesId.indexOf(param2.data.numId) == -1)
            {
               _loc3_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.zaap.addFavoritTooltip"),this.updateFavCatArray,[param2.data.numId,false]));
            }
            else
            {
               _loc3_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.zaap.deleteFavoritTooltip"),this.updateFavCatArray,[param2.data.numId,true]));
            }
            this.modContextMenu.createContextMenu(_loc3_);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case this.btn_close:
               if(this.uiApi.getUi("statBoost"))
               {
                  this.uiApi.unloadUi("statBoost");
               }
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_pvp:
               _loc2_ = this.playerApi.getAlignmentSide();
               if(_loc2_ == AlignementSideEnum.ALIGNMENT_ANGEL || _loc2_ == AlignementSideEnum.ALIGNMENT_EVIL)
               {
                  this.sysApi.sendAction(new OpenBook("alignmentTab"));
               }
               break;
            case this.btn_regular:
               if(this._nCurrentTab != 0)
               {
                  this._nCurrentTab = 0;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_advanced:
               if(this._nCurrentTab != 1)
               {
                  this._nCurrentTab = 1;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_spellBook:
               this.sysApi.sendAction(new OpenBook("spellTab"));
               break;
            case this.btn_job:
               this.sysApi.sendAction(new OpenBook("jobTab"));
               break;
            case this.ctr_charTitleButton:
               this.sysApi.sendAction(new OpenBook("titleTab"));
               break;
            case this.ctr_rewardPointButton:
               this.sysApi.sendAction(new OpenBook("achievementTab"));
               break;
            case this.btn_spouse:
               if(this.socialApi.hasSpouse())
               {
                  this.sysApi.sendAction(new d2actions.OpenSocial("3"));
               }
               break;
            case this.ctr_openGuildTab:
               if(this.socialApi.hasGuild())
               {
                  this.sysApi.sendAction(new d2actions.OpenSocial("1"));
               }
               else
               {
                  this.sysApi.dispatchHook(d2hooks.OpenSocial,4,0);
               }
               break;
            case this.ctr_openAllianceTab:
               if(this.socialApi.hasAlliance())
               {
                  this.sysApi.sendAction(new d2actions.OpenSocial("2"));
               }
               else
               {
                  this.sysApi.dispatchHook(d2hooks.OpenSocial,4,1);
               }
               break;
            default:
               if(param1.name.indexOf("btn_plus") != -1)
               {
                  if(!this.uiApi.getUi("statBoost"))
                  {
                     this.uiApi.loadUi("statBoost","statBoost",[this._componentList[param1.name].id,this._componentList[param1.name].numId,this._someStatsMayBeScrolled]);
                  }
                  else if(this._componentList[param1.name] && this.uiApi.getUi("statBoost").uiClass.statId != this._componentList[param1.name].numId)
                  {
                     this.uiApi.getUi("statBoost").uiClass.main([this._componentList[param1.name].id,this._componentList[param1.name].numId,this._someStatsMayBeScrolled]);
                  }
               }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
         this.uiApi.hideTooltip("statboostTooltip");
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         switch(param1)
         {
            case this.lbl_lvl:
               _loc2_ = this.uiApi.getText("ui.help.level",ProtocolConstantsEnum.MAX_LEVEL);
               break;
            case this.pb_xp:
               _loc2_ = this._xpInfoText;
               break;
            case this.pb_energy:
               _loc2_ = this.utilApi.formateIntToString(this._characterCharacteristics.energyPoints) + " / " + this.utilApi.formateIntToString(this._characterCharacteristics.maxEnergyPoints);
               break;
            case this.lbl_energy:
               _loc2_ = this.uiApi.getText("ui.help.energy");
               break;
            case this.lbl_xp:
               _loc2_ = this.uiApi.getText("ui.help.xp");
               break;
            case this.ctr_pointsToDivide:
               _loc2_ = this.uiApi.getText("ui.help.boostPoints");
               if(this._someStatsMayBeScrolled && this._characterCharacteristics.additionnalPoints > 0)
               {
                  _loc2_ = _loc2_ + ("\n\n" + this.uiApi.getText("ui.common.base") + " (" + this.uiApi.getText("ui.charaSheet.natural") + " + " + this.uiApi.getText("ui.charaSheet.additionnal") + ")" + this.uiApi.getText("ui.common.colon") + this._characterCharacteristics.statsPoints + "+" + this._characterCharacteristics.additionnalPoints);
               }
               break;
            case this.btn_title:
               _loc2_ = this.uiApi.getText("ui.common.titles");
               break;
            case this.btn_spouse:
               _loc2_ = this.uiApi.processText(this.uiApi.getText("ui.common.spouse"),this._spouse.sex > 0?"f":"m",true);
               break;
            case this.btn_pvp:
               _loc2_ = this.uiApi.getText("ui.common.alignment");
               break;
            case this.lbl_advancedBaseColumn:
               _loc2_ = this.uiApi.getText("ui.charaSheet.advancedBaseInfo");
               break;
            case this.lbl_advancedBonusColumn:
               _loc2_ = this.uiApi.getText("ui.charaSheet.advancedBonusInfo");
               break;
            case this.ctr_charTitleButton:
               if(this.playerApi.getTitle())
               {
                  _loc2_ = this.uiApi.getText("ui.charaSheet.changeTitle");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.charaSheet.noTitle");
               }
               break;
            case this.ctr_rewardPointButton:
               _loc2_ = this.uiApi.getText("ui.achievement.achievement");
               break;
            case this.ctr_healhPointsSmallBlock:
               _loc2_ = this.uiApi.getText("ui.help.lifePoints");
               break;
            case this.ctr_actionPointsSmallBlock:
               _loc2_ = this.uiApi.getText("ui.help.actionPoints");
               break;
            case this.ctr_movementPointsSmallBlock:
               _loc2_ = this.uiApi.getText("ui.help.movementPoints");
               break;
            case this.ctr_openGuildTab:
               _loc2_ = !!this.socialApi.hasGuild()?this._guild.guildName:this.uiApi.getText("ui.common.guild");
               break;
            case this.ctr_openAllianceTab:
               _loc2_ = !!this.socialApi.hasAlliance()?this._alliance.allianceName:this.uiApi.getText("ui.common.alliance");
               break;
            default:
               if(param1.name.indexOf("lbl_name") != -1)
               {
                  _loc4_ = "";
                  _loc3_ = this._componentList[param1.name];
                  if(this._favCategoriesId.indexOf(_loc3_.numId) == -1)
                  {
                     _loc4_ = this.uiApi.getText("ui.charaSheet.rightClickToAdd");
                  }
                  else
                  {
                     _loc4_ = this.uiApi.getText("ui.charaSheet.rightClickToRemove");
                  }
                  if(this.ctr_advanced.visible)
                  {
                     _loc2_ = null;
                     _loc5_ = this.uiApi.getText("ui.help." + this._componentList[param1.name].id);
                     if(_loc5_.indexOf("[UNKNOWN_TEXT_NAME") != -1)
                     {
                        _loc2_ = _loc4_;
                     }
                     else
                     {
                        _loc6_ = {
                           "content":this.uiApi.getText("ui.help." + this._componentList[param1.name].id),
                           "additionalInfo":_loc4_,
                           "maxWidth":400,
                           "addInfoCssClass":"italiclightgrey"
                        };
                        this.uiApi.showTooltip(_loc6_,param1,false,"standard",5,3,3,"textInfoWithHorizontalSeparator",null,null);
                     }
                  }
                  else
                  {
                     _loc2_ = this.uiApi.getText("ui.help." + this._componentList[param1.name].id);
                  }
               }
               else if(param1.name.indexOf("lbl_value") != -1)
               {
                  if(this.ctr_advanced.visible)
                  {
                     _loc2_ = null;
                     _loc6_ = {
                        "content":this.getParsedStat(this._componentList[param1.name],true),
                        "additionalInfo":this.uiApi.getText("ui.common.total") + this.uiApi.getText("ui.common.colon") + param1.text,
                        "maxWidth":100
                     };
                     this.uiApi.showTooltip(_loc6_,param1,false,"standard",6,2,3,"textInfoWithHorizontalSeparator",null,null);
                  }
                  else
                  {
                     _loc2_ = this.getParsedStat(this._componentList[param1.name]);
                  }
               }
               else if(param1.name.indexOf("lbl_base") != -1)
               {
                  _loc3_ = this._componentList[param1.name];
                  if(_loc3_ && !_loc3_.isCat && _loc3_.hasOwnProperty("upgradable") && _loc3_.upgradable && _loc3_.hasOwnProperty("base") && (_loc3_.base > 0 || _loc3_.additionnal > 0))
                  {
                     _loc2_ = "" + _loc3_.base + " + " + _loc3_.additionnal;
                  }
               }
               else if(param1.name.indexOf("lbl_bonus") != -1)
               {
                  _loc3_ = this._componentList[param1.name];
                  if(_loc3_ && !_loc3_.isCat && _loc3_.hasOwnProperty("boost") && _loc3_.boost > 0)
                  {
                     _loc2_ = "" + _loc3_.stuff + " + " + _loc3_.boost;
                  }
               }
               else if(param1.name.indexOf("btn_plus") != -1)
               {
                  if(this.sysApi.isFightContext())
                  {
                     _loc2_ = this.uiApi.getText("ui.charaSheet.caracBoostNoFight");
                  }
                  else if(param1.softDisabled)
                  {
                     _loc2_ = this.uiApi.getText("ui.charaSheet.notEnoughtPoints");
                  }
                  else
                  {
                     switch(this._componentList[param1.name].numId)
                     {
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_VITALITY:
                           _loc2_ = this.uiApi.getText("ui.stats.modifyVitalityPoints");
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_WISDOM:
                           _loc2_ = this.uiApi.getText("ui.stats.modifyWisdomPoints");
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_STRENGTH:
                           _loc2_ = this.uiApi.getText("ui.stats.modifyStrengthPoints");
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE:
                           _loc2_ = this.uiApi.getText("ui.stats.modifyIntelligencePoints");
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_CHANCE:
                           _loc2_ = this.uiApi.getText("ui.stats.modifyChancePoints");
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_AGILITY:
                           _loc2_ = this.uiApi.getText("ui.stats.modifyAgilityPoints");
                     }
                  }
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"textWithSeparator");
         }
      }
      
      public function onStatsUpgradeResult(param1:uint) : void
      {
         if(param1 > 0)
         {
            this.statsUpdate();
         }
      }
      
      public function onInventoryContent(param1:Object) : void
      {
         this.characterUpdate();
      }
      
      public function onCharacterStatsList(param1:Boolean = false) : void
      {
         this.characterUpdate();
      }
      
      public function onFightEvent(param1:String, param2:Object, param3:Object = null) : void
      {
         var _loc4_:int = param3.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param3[_loc5_] == this.playerApi.id())
            {
               switch(param1)
               {
                  case FightEventEnum.FIGHTER_LIFE_GAIN:
                  case FightEventEnum.FIGHTER_LIFE_LOSS:
                  case FightEventEnum.FIGHTER_TEMPORARY_BOOSTED:
                  case FightEventEnum.FIGHTER_AP_USED:
                  case FightEventEnum.FIGHTER_AP_LOST:
                  case FightEventEnum.FIGHTER_AP_GAINED:
                  case FightEventEnum.FIGHTER_MP_USED:
                  case FightEventEnum.FIGHTER_MP_LOST:
                  case FightEventEnum.FIGHTER_MP_GAINED:
                     this.characterUpdate();
                  default:
                     this.characterUpdate();
               }
            }
            _loc5_++;
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(!this.uiApi.getUi("statBoost")?this.uiApi.me().name:"statBoost");
            return true;
         }
         return false;
      }
      
      public function onUiLoaded(param1:String) : void
      {
         if(param1 == "statBoost")
         {
            this._lastChildIndex = this.uiApi.me().childIndex;
            this.uiApi.me().setOnTop();
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         switch(param1)
         {
            case this.tx_guildEmblemBack:
               this.utilApi.changeColor(this.tx_guildEmblemBack.getChildByName("back"),this._guild.backEmblem.color,1);
               break;
            case this.tx_guildEmblemFront:
               _loc2_ = this.dataApi.getEmblemSymbol(this._guild.upEmblem.idEmblem);
               if(_loc2_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_guildEmblemFront.getChildByName("up"),this._guild.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_guildEmblemFront.getChildByName("up"),this._guild.upEmblem.color,0,true);
               }
               break;
            case this.tx_allianceEmblemBack:
               this.utilApi.changeColor(this.tx_allianceEmblemBack.getChildByName("back"),this._alliance.backEmblem.color,1);
               break;
            case this.tx_allianceEmblemFront:
               _loc2_ = this.dataApi.getEmblemSymbol(this._alliance.upEmblem.idEmblem);
               if(_loc2_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_allianceEmblemFront.getChildByName("up"),this._alliance.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_allianceEmblemFront.getChildByName("up"),this._alliance.upEmblem.color,0,true);
               }
         }
      }
   }
}

class CharacteristiqueGridItem
{
    
   
   public var cId:int = 0;
   
   public var id:String;
   
   public var text:String;
   
   public var gfxId:String;
   
   public var numId:int;
   
   public var upgradable:Boolean;
   
   public var cat:int;
   
   public var base:uint = 0;
   
   public var additionnal:uint = 0;
   
   public var stuff:int = 0;
   
   public var boost:int = 0;
   
   public var isCat:Boolean = false;
   
   function CharacteristiqueGridItem(param1:*, param2:*, param3:*, param4:*, param5:*, param6:*, param7:*)
   {
      super();
      this.cId = param1;
      this.id = param2;
      this.text = param3;
      this.gfxId = param4;
      this.numId = param5;
      this.upgradable = param6;
      this.cat = param7;
   }
   
   public function clone() : CharacteristiqueGridItem
   {
      var _loc1_:CharacteristiqueGridItem = new CharacteristiqueGridItem(this.cId,this.id,this.text,this.gfxId,this.numId,this.upgradable,this.cat);
      _loc1_.base = this.base;
      _loc1_.additionnal = this.additionnal;
      _loc1_.stuff = this.stuff;
      _loc1_.boost = this.boost;
      _loc1_.isCat = this.isCat;
      return _loc1_;
   }
}
