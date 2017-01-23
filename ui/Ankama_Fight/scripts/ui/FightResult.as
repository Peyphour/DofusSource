package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.CaptureApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.OpenBook;
   import d2actions.OpenIdols;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.FightOutcomeEnum;
   import d2enums.FightTypeEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ScreenshotTypeEnum;
   import d2enums.StrataEnum;
   import d2hooks.FightResultClosed;
   import d2hooks.ShowObjectLinked;
   import d2hooks.TextInformation;
   import flash.utils.Dictionary;
   
   public class FightResult
   {
      
      private static const RESULT_COMPLETE:uint = 1;
      
      private static const RESULT_FAILED:uint = 2;
      
      private static const MAXIMAL_SIZE:uint = 20;
      
      private static var CTR_TYPE_TITLE:String = "ctr_title";
      
      private static var CTR_TYPE_FIGHTER:String = "ctr_fighter";
       
      
      public var sysApi:SystemApi;
      
      public var timeApi:TimeApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var soundApi:SoundApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var utilApi:UtilApi;
      
      public var tooltipApi:TooltipApi;
      
      public var menuApi:ContextMenuApi;
      
      public var dataApi:DataApi;
      
      public var captureApi:CaptureApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var ctr_stars:GraphicContainer;
      
      public var ctr_drop:GraphicContainer;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_fightResult:GraphicContainer;
      
      public var ctr_gridResult:GraphicContainer;
      
      public var fightResultWindow:GraphicContainer;
      
      public var btn_close_fightResultWindow:ButtonContainer;
      
      public var btn_close2:ButtonContainer;
      
      public var btn_closeDrop:ButtonContainer;
      
      public var btn_idols:ButtonContainer;
      
      public var lbl_result:Label;
      
      public var lbl_time:Label;
      
      public var lbl_honour:Label;
      
      public var lbl_drop:Label;
      
      public var lbl_score:Label;
      
      public var lbl_xp:Label;
      
      public var gd_fighters:Grid;
      
      public var gd_drop:Grid;
      
      public var gd_idols:Grid;
      
      public var tx_star0:Texture;
      
      public var tx_star1:Texture;
      
      public var tx_star2:Texture;
      
      public var tx_star3:Texture;
      
      public var tx_star4:Texture;
      
      public var tx_challenge1:Texture;
      
      public var tx_challenge2:Texture;
      
      public var tx_challenge1Slot:TextureBitmap;
      
      public var tx_challenge2Slot:TextureBitmap;
      
      public var tx_challenge_result1:Texture;
      
      public var tx_challenge_result2:Texture;
      
      public var tx_gdFighterBg:Texture;
      
      public var tx_gridHeader:Texture;
      
      public var tx_result:TextureBitmap;
      
      public var tx_honor_separator:TextureBitmap;
      
      public var btn_share:ButtonContainer;
      
      private var _challenges:Array;
      
      private var _ageBonus:int;
      
      private var _sizeMalus:int;
      
      private var _isPvpFight:Boolean;
      
      private var _winnersName:String;
      
      private var _losersName:String;
      
      private var _heightBg:int;
      
      private var _heightGrid:int;
      
      private var _heightGridBg:int;
      
      private var _heightLine:int;
      
      private var _widthName:int;
      
      private var _xXpShort:int;
      
      private var _widthXpShort:int;
      
      private var _xXpShortHonour:int;
      
      private var _widthXpShortHonour:int;
      
      private var _xXpLong:int;
      
      private var _widthXpLong:int;
      
      private var _pictoUris:Array;
      
      private var _objectsLists:Dictionary;
      
      private var _hookGridObjects:Dictionary;
      
      private var _headsUri:String;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      private var _idols:Object;
      
      private var _totalScore:uint;
      
      private var _totalExp:uint;
      
      private var _totalLoot:uint;
      
      public function FightResult()
      {
         this._pictoUris = new Array();
         this._objectsLists = new Dictionary(true);
         this._hookGridObjects = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Idol = null;
         var _loc9_:Number = NaN;
         this.uiApi.addComponentHook(this.tx_challenge1,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_challenge1,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_challenge2,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_challenge2,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_close_fightResultWindow,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_challenge_result1,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_challenge_result1,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_challenge_result2,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_challenge_result2,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_stars,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_stars,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_drop,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_drop,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.gd_drop,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_drop,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_share,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_share,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_idols,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_idols,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_idols,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.ctr_drop.visible = false;
         var _loc2_:int = param1.duration;
         this._ageBonus = param1.ageBonus;
         this._sizeMalus = param1.sizeMalus;
         var _loc3_:Object = param1.results;
         this._challenges = param1.challenges;
         this._winnersName = param1.winnersName;
         this._losersName = param1.losersName;
         this._headsUri = this.uiApi.me().getConstant("heads");
         this._pictoUris.push(this.uiApi.me().getConstant("winner_uri"));
         this._pictoUris.push(this.uiApi.me().getConstant("loser_uri"));
         this._pictoUris.push(this.uiApi.me().getConstant("pony_uri"));
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this._heightBg = int(this.uiApi.me().getConstant("bg_height"));
         this._heightGrid = int(this.uiApi.me().getConstant("grid_height"));
         this._heightGridBg = int(this.uiApi.me().getConstant("gridBg_height"));
         this._heightLine = int(this.uiApi.me().getConstant("line_height"));
         this._widthName = int(this.uiApi.me().getConstant("name_width"));
         this._xXpShort = this.uiApi.me().getConstant("lbl_xp_short_x");
         this._widthXpShort = this.uiApi.me().getConstant("lbl_xp_short_width");
         this._xXpShortHonour = this.uiApi.me().getConstant("lbl_xp_shortHonour_x");
         this._widthXpShortHonour = this.uiApi.me().getConstant("lbl_xp_shortHonour_width");
         this._xXpLong = this.uiApi.me().getConstant("lbl_xp_long_x");
         this._widthXpLong = this.uiApi.me().getConstant("lbl_xp_long_width");
         var _loc4_:* = " (" + this.uiApi.getText("ui.fight.turnCount",param1.turns) + ")";
         if(param1.turns > 1)
         {
            _loc4_ = this.uiApi.processText(_loc4_,"m",false);
         }
         else
         {
            _loc4_ = this.uiApi.processText(_loc4_,"m",true);
         }
         this.lbl_time.text = this.timeApi.getShortDuration(_loc2_,true) + _loc4_;
         if(param1.fightType == FightTypeEnum.FIGHT_TYPE_AGRESSION || param1.fightType == FightTypeEnum.FIGHT_TYPE_PvMA)
         {
            this._isPvpFight = true;
            this.lbl_xp.x = this.uiApi.me().getConstant("lbl_xpTitle_withHonor");
         }
         else
         {
            this.lbl_xp.x = this.uiApi.me().getConstant("lbl_xpTitle_noHonor");
         }
         this.lbl_xp.finalize();
         this.lbl_honour.visible = this._isPvpFight;
         this.tx_honor_separator.visible = this._isPvpFight;
         this.displayBonuses();
         this.displayChallenges();
         this.displayResults(_loc3_);
         this._idols = param1.idols;
         var _loc5_:Array = new Array();
         var _loc6_:uint = this._idols.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = this.dataApi.getIdol(this._idols[_loc7_]);
            _loc9_ = this.getIdolCoeff(_loc8_);
            this._totalScore = this._totalScore + _loc8_.score * _loc9_;
            this._totalExp = this._totalExp + _loc8_.experienceBonus * _loc9_;
            this._totalLoot = this._totalLoot + _loc8_.dropBonus * _loc9_;
            _loc5_.push(this.dataApi.getItemWrapper(_loc8_.itemId));
            _loc7_++;
         }
         this.gd_idols.dataProvider = _loc5_;
         this.lbl_score.text = this._totalScore.toString();
         var _loc10_:uint = this.playerApi.getPlayedCharacterInfo().level;
         if(_loc10_ > ProtocolConstantsEnum.MAX_LEVEL)
         {
            _loc10_ = ProtocolConstantsEnum.MAX_LEVEL;
         }
         var _loc11_:int = this.playerApi.characteristics().wisdom.base + this.playerApi.characteristics().wisdom.additionnal + this.playerApi.characteristics().wisdom.objectsAndMountBonus + this.playerApi.characteristics().wisdom.alignGiftBonus + this.playerApi.characteristics().wisdom.contextModif;
         var _loc12_:int = this.playerApi.characteristics().prospecting.base + this.playerApi.characteristics().prospecting.additionnal + this.playerApi.characteristics().prospecting.objectsAndMountBonus + this.playerApi.characteristics().prospecting.alignGiftBonus + this.playerApi.characteristics().prospecting.contextModif;
         this._totalExp = (2.5 * _loc10_ + 100) * this._totalExp / (_loc11_ + 100);
         this._totalLoot = (0.5 * _loc10_ + 100) * this._totalLoot / (_loc12_ + 100);
         if(this.sysApi.getPlayerManager().subscriptionEndDate == 0)
         {
            this.btn_share.softDisabled = true;
         }
         else if(this.uiApi.getUi("sharePopup"))
         {
            this.uiApi.unloadUi("sharePopup");
         }
      }
      
      public function unload() : void
      {
         if(this.uiApi.getUi("sharePopup"))
         {
            this.uiApi.unloadUi("sharePopup");
         }
         this.sysApi.dispatchHook(FightResultClosed);
      }
      
      public function updateLine(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         var _loc5_:* = null;
         var _loc6_:Monster = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         switch(this.getLineType(param1,param4))
         {
            case CTR_TYPE_TITLE:
               param2.tx_titleIcon.uri = this.uiApi.createUri(this._pictoUris[param1.icon]);
               param2.lbl_titleName.text = param1.name;
               break;
            case CTR_TYPE_FIGHTER:
               if(!this._hookGridObjects[param2.gd_objects.name])
               {
                  this.uiApi.addComponentHook(param2.gd_objects,ComponentHookList.ON_ITEM_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.gd_objects,ComponentHookList.ON_ITEM_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.gd_objects,ComponentHookList.ON_SELECT_ITEM);
                  this.uiApi.addComponentHook(param2.gd_objects,ComponentHookList.ON_ITEM_RIGHT_CLICK);
               }
               this._hookGridObjects[param2.gd_objects.name] = param1;
               if(!this._hookGridObjects[param2.btn_seeMore.name])
               {
                  this.uiApi.addComponentHook(param2.btn_seeMore,ComponentHookList.ON_RELEASE);
                  this.uiApi.addComponentHook(param2.btn_seeMore,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_seeMore,ComponentHookList.ON_ROLL_OUT);
               }
               this._hookGridObjects[param2.btn_seeMore.name] = param1;
               if(!this._hookGridObjects[param2.pb_xpGauge.name])
               {
                  this.uiApi.addComponentHook(param2.pb_xpGauge,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.pb_xpGauge,ComponentHookList.ON_ROLL_OUT);
               }
               this._hookGridObjects[param2.pb_xpGauge.name] = param1;
               if(!this._hookGridObjects[param2.tx_xpBonusPicto.name])
               {
                  this.uiApi.addComponentHook(param2.tx_xpBonusPicto,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.tx_xpBonusPicto,ComponentHookList.ON_ROLL_OUT);
               }
               this._hookGridObjects[param2.tx_xpBonusPicto.name] = param1;
               if(!this._hookGridObjects[param2.lbl_xpPerso.name])
               {
                  this.uiApi.addComponentHook(param2.lbl_xpPerso,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.lbl_xpPerso,ComponentHookList.ON_ROLL_OUT);
               }
               this._hookGridObjects[param2.lbl_xpPerso.name] = param1;
               if(!this._hookGridObjects[param2.lbl_honour.name])
               {
                  this.uiApi.addComponentHook(param2.lbl_honour,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.lbl_honour,ComponentHookList.ON_ROLL_OUT);
               }
               this._hookGridObjects[param2.lbl_honour.name] = param1;
               if(!this._hookGridObjects[param2.tx_arrow.name])
               {
                  this.uiApi.addComponentHook(param2.tx_arrow,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.tx_arrow,ComponentHookList.ON_ROLL_OUT);
               }
               this._hookGridObjects[param2.tx_arrow.name] = param1;
               param2.tx_deathPicto.visible = !param1.alive;
               if(param1.id == this.playerApi.id() || param1.fightInitiator)
               {
                  param2.lbl_name.width = this._widthName - param2.tx_arrow.width - 3;
                  param2.tx_arrow.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "icon_man.png");
                  if(param1.fightInitiator)
                  {
                     param2.tx_arrow.gotoAndStop = 2;
                  }
                  else
                  {
                     param2.tx_arrow.gotoAndStop = 1;
                  }
               }
               else
               {
                  param2.tx_arrow.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "icon_crossed_swords.png");
               }
               _loc5_ = param1.name;
               if(param1.type == 0)
               {
                  _loc5_ = "{player," + param1.name + "," + param1.id + "::" + param1.name + "}";
               }
               else if(param1.type == 1)
               {
                  _loc6_ = this.dataApi.getMonsterFromId(param1.id);
                  if(_loc6_)
                  {
                     _loc5_ = "{bestiary," + param1.id + "::" + param1.name + "}";
                  }
               }
               param2.lbl_name.text = _loc5_;
               if(param1.type == 0 && param1.level > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  param2.lbl_level.text = "" + (param1.level - ProtocolConstantsEnum.MAX_LEVEL);
                  param2.tx_level.uri = this._bgPrestigeUri;
               }
               else
               {
                  param2.lbl_level.text = param1.level;
                  param2.tx_level.uri = this._bgLevelUri;
               }
               if(param1.breed > 0)
               {
                  param2.tx_head.uri = this.uiApi.createUri(this._headsUri + "" + param1.breed + "" + int(param1.gender) + ".png");
                  param2.tx_head.visible = true;
                  param2.tx_fighterHeadSlot.visible = true;
               }
               else
               {
                  param2.tx_head.visible = false;
                  param2.tx_fighterHeadSlot.visible = false;
               }
               if(param1.showExperience)
               {
                  param2.pb_xpGauge.visible = true;
                  _loc7_ = (param1.experience - param1.experienceLevelFloor) * 100 / (param1.experienceNextLevelFloor - param1.experienceLevelFloor);
                  param2.pb_xpGauge.value = _loc7_ / 100;
               }
               else
               {
                  param2.pb_xpGauge.visible = false;
               }
               if(this._isPvpFight)
               {
                  param2.lbl_xpPerso.x = this._xXpShortHonour;
                  param2.lbl_xpPerso.width = this._widthXpShort;
               }
               else
               {
                  param2.lbl_xpPerso.x = this._xXpShort;
                  param2.lbl_xpPerso.width = this._widthXpShort;
               }
               param2.lbl_xpPerso.y = 8;
               param2.lbl_xpPerso.finalize();
               if(param1.honorDelta == -1)
               {
                  param2.lbl_honour.visible = false;
               }
               else
               {
                  param2.lbl_honour.visible = true;
                  param2.lbl_honour.text = param1.honorDelta;
               }
               if(param1.honorDelta == -1 && param1.rerollXpMultiplicator != 0)
               {
                  _loc8_ = param1.rerollXpMultiplicator.toString();
                  if(_loc8_ > 3)
                  {
                     _loc8_ = 3;
                  }
                  param2.tx_xpBonusPicto.visible = true;
                  param2.tx_xpBonusPicto.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "XPBonus" + _loc8_.toString() + ".png");
               }
               else
               {
                  param2.tx_xpBonusPicto.visible = false;
               }
               if(param1.showExperienceFightDelta)
               {
                  param2.lbl_xpPerso.text = this.utilApi.kamasToString(param1.experienceFightDelta,"");
               }
               else
               {
                  param2.lbl_xpPerso.text = "";
               }
               if(param1.rewards.kamas > 0)
               {
                  param2.lbl_kamas.text = this.utilApi.kamasToString(param1.rewards.kamas,"");
               }
               else if(param1.type != 0)
               {
                  param2.lbl_kamas.text = "";
               }
               else
               {
                  param2.lbl_kamas.text = "0";
               }
               if(param1.rewards.objects.length > 0)
               {
                  _loc9_ = new Array();
                  for each(_loc10_ in param1.rewards.objects)
                  {
                     _loc9_.push(_loc10_);
                  }
                  param2.gd_objects.dataProvider = _loc9_;
               }
               else
               {
                  param2.gd_objects.dataProvider = new Array();
               }
               if(param1.rewards.objects.length > 10)
               {
                  param2.btn_seeMore.visible = true;
                  _loc11_ = "";
                  _loc12_ = 10;
                  while(_loc12_ < param1.rewards.objects.length)
                  {
                     _loc11_ = _loc11_ + (param1.rewards.objects[_loc12_].quantity + " x " + param1.rewards.objects[_loc12_].name + " \n");
                     _loc12_++;
                  }
                  this._objectsLists[param1.id] = _loc11_;
               }
               else
               {
                  param2.btn_seeMore.visible = false;
               }
         }
      }
      
      public function getLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1 && param1.hasOwnProperty("level"))
               {
                  return CTR_TYPE_FIGHTER;
               }
               return CTR_TYPE_TITLE;
            default:
               return CTR_TYPE_TITLE;
         }
      }
      
      public function getDataLength(param1:*, param2:Boolean) : *
      {
         if(!param2)
         {
         }
         return 2 + (!!param2?param1.subcats.length:0);
      }
      
      public function displayBonuses() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Texture = null;
         if(this._ageBonus <= 0)
         {
            this.ctr_stars.visible = false;
         }
         else
         {
            _loc1_ = 0;
            _loc2_ = this._ageBonus;
            this.ctr_stars.visible = true;
            if(_loc2_ > 100)
            {
               _loc1_ = 1;
               _loc2_ = _loc2_ - 100;
            }
            _loc3_ = Math.round(_loc2_ / 20);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this["tx_star" + _loc4_];
               _loc5_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("star_uri" + (1 + _loc1_)));
               _loc5_.finalize();
               _loc4_++;
            }
            _loc4_ = _loc4_;
            while(_loc4_ < 5)
            {
               _loc5_ = this["tx_star" + _loc4_];
               _loc5_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("star_uri" + _loc1_));
               _loc5_.finalize();
               _loc4_++;
            }
         }
      }
      
      public function displayChallenge(param1:Object, param2:Object) : void
      {
         param1.tx_challenge.visible = true;
         param1.tx_challenge.uri = param2.iconUri;
         switch(param2.result)
         {
            case RESULT_COMPLETE:
               param1.tx_challenge_result.visible = true;
               param1.tx_challenge_result.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/filter_iconChallenge_check.png");
               break;
            case RESULT_FAILED:
               param1.tx_challenge_result.visible = true;
               param1.tx_challenge_result.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/filter_iconChallenge_cross.png");
         }
      }
      
      public function displayChallenges() : void
      {
         var _loc1_:Array = [{
            "tx_challenge":this.tx_challenge1,
            "tx_challenge_result":this.tx_challenge_result1,
            "tx_challengeSlot":this.tx_challenge1Slot
         },{
            "tx_challenge":this.tx_challenge2,
            "tx_challenge_result":this.tx_challenge_result2,
            "tx_challengeSlot":this.tx_challenge2Slot
         }];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc1_[_loc2_].tx_challenge.visible = false;
            _loc1_[_loc2_].tx_challenge_result.visible = false;
            _loc2_++;
         }
         var _loc3_:uint = this._challenges.length <= 2?uint(this._challenges.length):uint(2);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.displayChallenge(_loc1_[_loc2_],this._challenges[_loc2_]);
            _loc2_++;
         }
      }
      
      public function displayResults(param1:Object) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         for(_loc6_ in param1)
         {
            param1[_loc6_].rewards.objects.sort(this.compareItemsAveragePrices);
            if(param1[_loc6_].outcome == FightOutcomeEnum.RESULT_VICTORY)
            {
               _loc3_.push(param1[_loc6_]);
               if(param1[_loc6_].id == this.playerApi.id())
               {
                  this.lbl_result.text = this.uiApi.getText("ui.fightend.victory");
                  this.tx_result.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "tx_flag_victory.png");
                  this.soundApi.playSound(SoundTypeEnum.FIGHT_WIN);
               }
            }
            else if(param1[_loc6_].outcome == FightOutcomeEnum.RESULT_LOST)
            {
               _loc4_.push(param1[_loc6_]);
               if(param1[_loc6_].id == this.playerApi.id())
               {
                  this.lbl_result.text = this.uiApi.getText("ui.fightend.loss");
                  this.tx_result.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "tx_flag_defeat.png");
                  this.soundApi.playSound(SoundTypeEnum.FIGHT_LOSE);
               }
            }
            else if(param1[_loc6_].outcome == FightOutcomeEnum.RESULT_TAX)
            {
               _loc5_.push(param1[_loc6_]);
            }
         }
         _loc7_ = this._winnersName != ""?this._winnersName:this.uiApi.getText("ui.fightend.winners");
         _loc2_.push({
            "name":_loc7_,
            "icon":0
         });
         for each(_loc8_ in _loc3_)
         {
            _loc2_.push(_loc8_);
         }
         _loc9_ = this._losersName != ""?this._losersName:this.uiApi.getText("ui.fightend.losers");
         _loc2_.push({
            "name":_loc9_,
            "icon":1
         });
         for each(_loc10_ in _loc4_)
         {
            _loc2_.push(_loc10_);
         }
         if(_loc5_.length > 0)
         {
            _loc2_.push({
               "name":this.uiApi.getText("ui.common.taxCollector"),
               "icon":2
            });
            for each(_loc11_ in _loc5_)
            {
               _loc2_.push(_loc11_);
            }
         }
         if(_loc2_.length < MAXIMAL_SIZE)
         {
            _loc12_ = _loc2_.length * this._heightLine;
            _loc13_ = this.ctr_fightResult.height + 160 + _loc12_;
            this.fightResultWindow.height = _loc13_;
            this.mainCtr.height = _loc13_;
            this.ctr_gridResult.height = _loc12_ + this.tx_gridHeader.height + 20;
            this.gd_fighters.height = _loc12_;
            this.tx_gdFighterBg.height = _loc12_;
            this.uiApi.me().render();
         }
         this.gd_fighters.dataProvider = _loc2_;
      }
      
      private function compareItemsAveragePrices(param1:Object, param2:Object) : int
      {
         var _loc3_:int = this.averagePricesApi.getItemAveragePrice(param1.objectGID) * param1.quantity;
         var _loc4_:int = this.averagePricesApi.getItemAveragePrice(param2.objectGID) * param2.quantity;
         return _loc3_ < _loc4_?1:_loc3_ > _loc4_?-1:0;
      }
      
      private function getIdolCoeff(param1:Idol) : Number
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Number = 1;
         var _loc3_:Object = param1.synergyIdolsIds;
         var _loc4_:Object = param1.synergyIdolsCoeff;
         var _loc5_:uint = _loc3_.length;
         var _loc8_:uint = this._idols.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               if(_loc3_[_loc7_] == this._idols[_loc6_])
               {
                  _loc2_ = _loc2_ * _loc4_[_loc7_];
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      private function onUrlReceived(param1:String = null) : void
      {
         if(this.btn_share)
         {
            this.btn_share.disabled = false;
            this.btn_share.visible = true;
            if(param1)
            {
               this.uiApi.loadUi("Ankama_Web::sharePopup","sharePopup",{"url":param1},StrataEnum.STRATA_HIGH,null,true);
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.btn_close_fightResultWindow:
            case this.btn_close2:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_closeDrop:
               this.ctr_drop.visible = false;
               break;
            case this.btn_share:
               _loc2_ = this.uiApi.getUi("sharePopup");
               if(!_loc2_)
               {
                  this.uiApi.hideTooltip();
                  _loc3_ = this.captureApi.getScreenAsJpgCompressedBase64();
                  if(_loc3_)
                  {
                     this.sysApi.getUrltoShareContent({
                        "title":this.uiApi.getText("ui.social.share.staticPage.defaultTitle",this.playerApi.getPlayedCharacterInfo().name),
                        "description":this.uiApi.getText("ui.social.share.staticPage.defaultDescription"),
                        "image":_loc3_
                     },this.onUrlReceived,ScreenshotTypeEnum.ENDFIGHT);
                     this.btn_share.disabled = true;
                     this.btn_share.visible = false;
                  }
                  else
                  {
                     this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.social.share.popup.error"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,this.timeApi.getTimestamp());
                     this.sysApi.log(16,"Failed to get screenshot of the game view as base64!");
                  }
               }
               else
               {
                  _loc2_.uiClass.toggleVisibility();
               }
               break;
            case this.btn_idols:
               if(!this.uiApi.getUi("idolsTab"))
               {
                  this.sysApi.sendAction(new OpenIdols());
               }
               else
               {
                  this.sysApi.sendAction(new OpenBook("idolsTab"));
               }
               break;
            default:
               if(param1.name.indexOf("btn_seeMore") != -1)
               {
                  _loc4_ = this._hookGridObjects[param1.name];
                  if(this.ctr_drop.visible && this.lbl_drop.text == _loc4_.name)
                  {
                     this.ctr_drop.visible = false;
                  }
                  else
                  {
                     this.ctr_drop.visible = true;
                     this.gd_drop.dataProvider = _loc4_.rewards.objects;
                     this.lbl_drop.text = _loc4_.name;
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = "";
         var _loc3_:Object = {
            "point":7,
            "relativePoint":7,
            "offset":0
         };
         switch(param1)
         {
            case this.tx_challenge_result1:
               this.uiApi.showTooltip(this._challenges[0],param1,false,"standard",2,8,0,null,null,null);
               break;
            case this.tx_challenge_result2:
               this.uiApi.showTooltip(this._challenges[1],param1,false,"standard",2,8,0,null,null,null);
               break;
            case this.ctr_stars:
               _loc2_ = this.uiApi.getText("ui.fightend.bonus") + this.uiApi.getText("ui.common.colon") + this._ageBonus + "%";
               break;
            case this.lbl_score:
               _loc2_ = this.gd_idols.dataProvider && this.gd_idols.dataProvider.length > 0?this.uiApi.getText("ui.idol.fightScore",this._totalScore,this._totalLoot + "%",this._totalExp + "%"):this.uiApi.getText("ui.idol.noIdols");
               break;
            case this.btn_share:
               if(!this.btn_share.softDisabled)
               {
                  _loc2_ = this.uiApi.getText("ui.common.socialNetworkShare");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.payzone.limit");
               }
               break;
            default:
               if(param1.name.indexOf("btn_seeMore") != -1)
               {
                  _loc2_ = this._objectsLists[this._hookGridObjects[param1.name].id];
                  _loc2_ = _loc2_ + ("<br/><font color=\'#6d6d6d\'><i>" + this.uiApi.getText("ui.tooltip.loot.more") + "</i></font>");
               }
               else if(param1.name.indexOf("lbl_honour") != -1)
               {
                  _loc4_ = this._hookGridObjects[param1.name];
                  if(_loc4_)
                  {
                     _loc2_ = this.uiApi.getText("ui.pvp.rank") + this.uiApi.getText("ui.common.colon") + _loc4_.grade + "\n" + this.uiApi.getText("ui.pvp.honourPoints") + this.uiApi.getText("ui.common.colon") + (_loc4_.honorDelta > 0?"+":"") + _loc4_.honorDelta;
                  }
               }
               else if(param1.name.indexOf("lbl_xpPerso") != -1)
               {
                  _loc4_ = this._hookGridObjects[param1.name];
                  if(_loc4_)
                  {
                     if(_loc4_.showExperienceFightDelta)
                     {
                        _loc2_ = this.uiApi.getText("ui.fightend.xp") + this.uiApi.getText("ui.common.colon") + this.utilApi.kamasToString(_loc4_.experienceFightDelta,"");
                        if(_loc4_.isIncarnationExperience)
                        {
                           _loc2_ = _loc2_ + (" (" + this.uiApi.getText("ui.common.incarnation") + ")");
                        }
                     }
                     if(_loc4_.showExperienceForGuild)
                     {
                        _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.guild") + this.uiApi.getText("ui.common.colon") + this.utilApi.kamasToString(_loc4_.experienceForGuild,""));
                     }
                     if(_loc4_.showExperienceForRide)
                     {
                        _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.ride") + this.uiApi.getText("ui.common.colon") + this.utilApi.kamasToString(_loc4_.experienceForRide,""));
                     }
                  }
               }
               else if(param1.name.indexOf("pb_xpGauge") != -1)
               {
                  _loc4_ = this._hookGridObjects[param1.name];
                  if(_loc4_)
                  {
                     _loc5_ = Math.floor((_loc4_.experience - _loc4_.experienceLevelFloor) * 100 / (_loc4_.experienceNextLevelFloor - _loc4_.experienceLevelFloor));
                     _loc2_ = "" + _loc5_ + "% (" + this.utilApi.kamasToString(_loc4_.experience - _loc4_.experienceLevelFloor,"") + " / " + this.utilApi.kamasToString(_loc4_.experienceNextLevelFloor - _loc4_.experienceLevelFloor,"") + ")";
                  }
               }
               else if(param1.name.indexOf("tx_xpBonusPicto") != -1)
               {
                  _loc4_ = this._hookGridObjects[param1.name];
                  if(_loc4_)
                  {
                     _loc6_ = _loc4_.rerollXpMultiplicator;
                     if(_loc6_ > 1)
                     {
                        _loc2_ = this.uiApi.getText("ui.common.experiencePoint") + " x " + _loc6_ + "\n\n" + this.uiApi.getText("ui.information.xpFamilyBonus");
                     }
                  }
               }
               else if(param1.name.indexOf("tx_arrow") != -1)
               {
                  _loc4_ = this._hookGridObjects[param1.name];
                  if(_loc4_)
                  {
                     if(_loc4_.fightInitiator)
                     {
                        _loc2_ = this.uiApi.getText("ui.fightend.fightInitiator");
                     }
                  }
               }
         }
         if(_loc2_ != "")
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,_loc3_.offset,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(param1.name.indexOf("gd_objects") != -1 || param1 == this.gd_drop)
         {
            if(!this.sysApi.getOption("displayTooltips","dofus") && (param2 == GridItemSelectMethodEnum.CLICK || param2 == GridItemSelectMethodEnum.MANUAL))
            {
               _loc4_ = param1.selectedItem;
               this.sysApi.dispatchHook(ShowObjectLinked,_loc4_);
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:Idol = null;
         var _loc4_:ItemTooltipSettings = null;
         var _loc5_:* = undefined;
         if(param2.data)
         {
            if(param2.data.typeId == 178)
            {
               _loc3_ = this.dataApi.getIdolByItemId(param2.data.objectGID);
               this.uiApi.showTooltip(_loc3_.spellPair,param2.container,false,"standard",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_BOTTOM,0,null,null,{
                  "smallSpell":true,
                  "header":false,
                  "footer":false,
                  "effects":false,
                  "currentCC_EC":false,
                  "baseCC_EC":false,
                  "spellTab":false
               });
            }
            else
            {
               _loc4_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
               if(!_loc4_)
               {
                  _loc4_ = this.tooltipApi.createItemSettings();
                  this.sysApi.setData("itemTooltipSettings",_loc4_,DataStoreEnum.BIND_ACCOUNT);
               }
               _loc5_ = param2.data;
               if(!_loc4_.header && !_loc4_.conditions && !_loc4_.effects && !_loc4_.description && !_loc4_.averagePrice)
               {
                  _loc5_ = param2.data.name;
               }
               this.uiApi.showTooltip(param2.data,param2.container,false,"standard",7,7,0,"itemName",null,{
                  "header":_loc4_.header,
                  "conditions":_loc4_.conditions,
                  "description":_loc4_.description,
                  "averagePrice":_loc4_.averagePrice,
                  "showEffects":_loc4_.effects
               },"ItemInfo");
            }
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         if(param2.data == null)
         {
            return;
         }
         var _loc3_:Object = param2.data;
         var _loc4_:Object = this.menuApi.create(_loc3_);
         var _loc5_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(!_loc5_)
         {
            _loc5_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc5_,DataStoreEnum.BIND_ACCOUNT);
         }
         this.modContextMenu.createContextMenu(_loc4_);
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemDetails(param1:Object, param2:Object) : void
      {
         this.uiApi.showTooltip(param1,param2,false,"Hyperlink",0,2,3,null,null,null,null,true);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
            case "closeUi":
               if(this.ctr_drop.visible)
               {
                  this.ctr_drop.visible = false;
               }
               else
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function onGameFightEnd(param1:Object) : void
      {
      }
   }
}
