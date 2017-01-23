package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.misc.Pack;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.ChangeServer;
   import d2actions.CharacterDeletion;
   import d2actions.CharacterReplayRequest;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.CharacterDeletionError;
   import d2hooks.CharacterImpossibleSelection;
   import d2hooks.CharactersListUpdated;
   import d2hooks.DownloadError;
   import d2hooks.GiftAssigned;
   import d2hooks.PackRestrictedSubArea;
   import flash.utils.Dictionary;
   
   public class CharacterSelection
   {
      
      private static const DEATH_STATE_ALIVE:uint = 0;
      
      private static const DEATH_STATE_DEAD:uint = 1;
      
      private static const DEATH_STATE_WAITING_CONFIRMATION:uint = 2;
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var soundApi:SoundApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var dataApi:DataApi;
      
      public var securityApi:SecurityApi;
      
      public var connectionApi:ConnectionApi;
      
      private var _aCharactersList:Object;
      
      private var _nbCharacters:uint;
      
      private var _selectedChar:Object;
      
      private var _interactiveComponentsList:Dictionary;
      
      private var _cbProvider:Array;
      
      private var _askedToDeleteCharacterId:Number = 0;
      
      private var _lockPopup:String;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      public var tx_breedIllu:Texture;
      
      public var lbl_characterCount:Label;
      
      public var gd_character:Grid;
      
      public var ed_chara:EntityDisplayer;
      
      public var lbl_name:Label;
      
      public var lbl_level:Label;
      
      public var hardcoreCtr:GraphicContainer;
      
      public var lbl_deathCounter:Label;
      
      public var tx_bonusXp:Texture;
      
      public var tx_bonusXpCreation:Texture;
      
      public var btn_play:ButtonContainer;
      
      public var btn_create:ButtonContainer;
      
      public var btn_changeServer:ButtonContainer;
      
      public var btn_resetCharacter:ButtonContainer;
      
      public var btn_articles:ButtonContainer;
      
      public function CharacterSelection()
      {
         this._interactiveComponentsList = new Dictionary(true);
         this._cbProvider = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.soundApi.switchIntroMusic(false);
         this.btn_changeServer.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_create.soundId = SoundEnum.OK_BUTTON;
         this.btn_play.isMute = true;
         this.sysApi.addHook(CharactersListUpdated,this.onCharactersListUpdated);
         this.sysApi.addHook(CharacterDeletionError,this.onCharacterDeletionError);
         this.sysApi.addHook(CharacterImpossibleSelection,this.onCharacterImpossibleSelection);
         this.sysApi.addHook(PackRestrictedSubArea,this.onPackRestrictedSubArea);
         this.sysApi.addHook(GiftAssigned,this.onGiftAssigned);
         this.sysApi.addHook(DownloadError,this.onDownloadError);
         this.uiApi.addComponentHook(this.gd_character,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.tx_bonusXp,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_bonusXp,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_bonusXpCreation,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_bonusXpCreation,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_play,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_play,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ed_chara,ComponentHookList.ON_DOUBLE_CLICK);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this._aCharactersList = new Array();
         this.gd_character.autoSelectMode = 2;
         this.ed_chara.clearSubEntities = false;
         this.ed_chara.handCursor = true;
         if(!this.sysApi.getPlayerManager().canCreateNewCharacter)
         {
            this.btn_create.softDisabled = true;
         }
         if(this.sysApi.getGiftList().length > 0)
         {
            this.btn_articles.visible = true;
         }
         else
         {
            this.btn_articles.visible = false;
         }
         if(!this.sysApi.isCharacterCreationAllowed())
         {
            this.btn_changeServer.disabled = true;
            this.btn_create.disabled = true;
         }
         this.onCharactersListUpdated(param1);
         if(!(this.sysApi.hasPart("all") && this.sysApi.hasPart("subscribed")) && !this.sysApi.hasUpdaterConnection() && !this.sysApi.getBuildType() != 4)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.streaming.noupdater"),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      public function unload() : void
      {
      }
      
      private function updateSelectedCharacter() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.lbl_name.text = this._selectedChar.name;
         if(this._selectedChar.level > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.lbl_level.text = this.uiApi.getText("ui.common.short.prestige") + " " + (this._selectedChar.level - ProtocolConstantsEnum.MAX_LEVEL);
         }
         else
         {
            this.lbl_level.text = this.uiApi.getText("ui.common.short.level") + " " + this._selectedChar.level;
         }
         var _loc1_:String = this._selectedChar.breedId + "" + (!!this._selectedChar.sex?"1":"0");
         this.tx_breedIllu.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus_uri") + "bgSelectCharacter/bg_" + _loc1_ + ".png");
         this.ed_chara.look = this._selectedChar.entityLook;
         if(this._selectedChar.bonusXp == 1)
         {
            this.tx_bonusXp.visible = false;
         }
         else
         {
            this.tx_bonusXp.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture_onboarding") + "xpBonusCircle" + (this._selectedChar.bonusXp - 1) + ".png");
            this.tx_bonusXp.visible = true;
         }
         var _loc2_:Object = this.sysApi.getCurrentServer();
         if(_loc2_.gameTypeId == 0)
         {
            this.btn_play.disabled = false;
            this.hardcoreCtr.visible = false;
            this.btn_resetCharacter.visible = false;
         }
         else
         {
            _loc3_ = this._selectedChar.deathCount;
            _loc4_ = this._selectedChar.deathState;
            if(_loc4_ == DEATH_STATE_ALIVE)
            {
               this.btn_play.disabled = false;
               this.hardcoreCtr.visible = false;
               this.btn_resetCharacter.visible = false;
            }
            else
            {
               this.btn_play.disabled = true;
               this.hardcoreCtr.visible = true;
               this.btn_resetCharacter.visible = true;
               this.lbl_deathCounter.text = "x " + _loc3_;
            }
         }
         if(this._selectedChar.unusable)
         {
            this.btn_play.softDisabled = true;
         }
         else
         {
            this.btn_play.softDisabled = false;
         }
      }
      
      private function validateCharacterChoice() : void
      {
         var _loc1_:Object = null;
         if(this._selectedChar)
         {
            _loc1_ = this.sysApi.getCurrentServer();
            if(this.securityApi.SecureModeisActive() && this.connectionApi.isCharacterWaitingForChange(this._selectedChar.id))
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.characterToBeModifiedForbidden"),[this.uiApi.getText("ui.common.ok")]);
            }
            else
            {
               if(_loc1_.gameTypeId == 1 || _loc1_.gameTypeId == 4)
               {
                  if(this._selectedChar.deathState != DEATH_STATE_ALIVE)
                  {
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.popup.resetCharacter"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onPopupReset,this.onPopupClose],this.onPopupReset,this.onPopupClose);
                     return;
                  }
               }
               this.btn_play.disabled = true;
               this.sysApi.sendAction(new d2actions.CharacterSelection(this._selectedChar.id,false));
               this.soundApi.playSound(SoundTypeEnum.PLAY_BUTTON);
            }
         }
      }
      
      public function updateCharacterLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._interactiveComponentsList[param2.btn_cross.name])
         {
            this.uiApi.addComponentHook(param2.btn_cross,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_cross,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_cross,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.btn_cross.name] = param1;
         if(param1)
         {
            param2.tx_bonusXp.gotoAndStop = param1.bonusXp.toString();
            param2.lbl_name.text = param1.name;
            param2.lbl_breed.text = this.dataApi.getBreed(param1.breedId).shortName;
            if(param1.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               param2.lbl_level.text = param1.level - ProtocolConstantsEnum.MAX_LEVEL;
               param2.tx_level.uri = this._bgPrestigeUri;
            }
            else
            {
               param2.lbl_level.text = param1.level;
               param2.tx_level.uri = this._bgLevelUri;
            }
            if(!this.sysApi.isCharacterCreationAllowed())
            {
               param2.btn_cross.disabled = true;
            }
            param2.btn_gridCharacter.selected = param3;
            param2.btn_cross.visible = true;
         }
         else
         {
            param2.lbl_name.text = "";
            param2.lbl_breed.text = "";
            param2.lbl_level.text = "";
            param2.tx_level.uri = null;
            param2.tx_bonusXp.gotoAndStop = "1";
            param2.btn_cross.visible = false;
            param2.btn_gridCharacter.selected = false;
         }
      }
      
      public function newArticles(param1:Boolean) : void
      {
         this.btn_articles.visible = param1;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_play:
            case this.btn_resetCharacter:
               this.validateCharacterChoice();
               break;
            case this.btn_create:
               Connection.getInstance().characterCreationStart();
               break;
            case this.btn_changeServer:
               this.sysApi.sendAction(new ChangeServer());
               break;
            case this.btn_articles:
               this.uiApi.loadUi("giftMenu","giftMenu",{
                  "gift":this.sysApi.getGiftList(),
                  "chara":this.sysApi.getCharaListMinusDeadPeople()
               });
               break;
            default:
               if(param1.name.indexOf("btn_cross") != -1)
               {
                  _loc2_ = this._interactiveComponentsList[param1.name];
                  this._askedToDeleteCharacterId = _loc2_.id;
                  if(_loc2_.level >= 20 && this.sysApi.getPlayerManager().secretQuestion != "")
                  {
                     this.uiApi.loadUi("secretPopup","secretPopup",[_loc2_.id,_loc2_.name]);
                  }
                  else
                  {
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.popup.warnBeforeDelete",_loc2_.name),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onPopupDelete,this.onPopupClose],this.onPopupDelete,this.onPopupClose);
                  }
               }
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_play:
               this.validateCharacterChoice();
               break;
            case this.ed_chara:
               this.validateCharacterChoice();
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(this._askedToDeleteCharacterId == 0)
               {
                  this.validateCharacterChoice();
               }
               return true;
            default:
               return false;
         }
      }
      
      public function onCharactersListUpdated(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(this._askedToDeleteCharacterId > 0)
         {
            this.soundApi.playSound(SoundTypeEnum.DELETE_CHARACTER);
            this._askedToDeleteCharacterId = 0;
            this.btn_play.disabled = false;
            this._lockPopup = null;
         }
         var _loc2_:int = 0;
         this._aCharactersList = new Array();
         for each(_loc3_ in param1)
         {
            this._aCharactersList.push(_loc3_);
            if(_loc3_.level > 1)
            {
               _loc2_++;
            }
         }
         _loc4_ = this.sysApi.getCurrentServer();
         if(_loc4_.gameTypeId == 0)
         {
            _loc5_ = _loc2_ > 3?3:int(_loc2_);
            if(_loc5_ == 0)
            {
               this.tx_bonusXpCreation.visible = false;
            }
            else
            {
               this.tx_bonusXpCreation.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture_onboarding") + "xpBonusRectangle" + _loc5_ + ".png");
               this.tx_bonusXpCreation.visible = true;
            }
         }
         else
         {
            this.tx_bonusXpCreation.visible = false;
         }
         this._nbCharacters = this._aCharactersList.length;
         if(this._nbCharacters == 0)
         {
            this.btn_play.disabled = true;
            this.btn_resetCharacter.visible = false;
            this.gd_character.dataProvider = new Array();
            this._selectedChar = null;
            this.updateSelectedCharacter();
         }
         else
         {
            if(this._aCharactersList.length == 1)
            {
               this.lbl_characterCount.text = "";
            }
            else
            {
               this.lbl_characterCount.text = this.uiApi.getText("ui.connection.listCharacterLabel",this._aCharactersList.length);
            }
            this.gd_character.dataProvider = this._aCharactersList;
            this._selectedChar = this.gd_character.selectedItem;
            if(!this._selectedChar)
            {
               this._selectedChar = this._aCharactersList[this._nbCharacters - 1];
            }
            this.updateSelectedCharacter();
         }
      }
      
      public function lockSelection() : void
      {
         this.btn_play.disabled = true;
         this._lockPopup = this.modCommon.openLockedPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.queue.wait"),null,true,[CharactersListUpdated,CharacterDeletionError],true,true);
      }
      
      public function onCharacterDeletionError(param1:String) : void
      {
         this._askedToDeleteCharacterId = 0;
         this.btn_play.disabled = false;
         this._lockPopup = null;
         this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.charSel.deletionError" + param1),[this.uiApi.getText("ui.common.ok")]);
      }
      
      public function onCharacterImpossibleSelection(param1:Number) : void
      {
         this.btn_play.disabled = false;
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.impossible_action"),this.uiApi.getText("ui.common.cantSelectThisCharacter"),[this.uiApi.getText("ui.common.ok")]);
      }
      
      public function onPackRestrictedSubArea(param1:uint) : void
      {
         var _loc2_:SubArea = this.dataApi.getSubArea(param1);
         var _loc3_:Pack = this.dataApi.getPack(_loc2_.packId);
         if(this.sysApi.hasPart(_loc3_.name) && this.sysApi.isDownloadFinished())
         {
            this.onAllDownloadTerminated();
         }
         else if(!this.uiApi.getUi("unavailableCharacterPopup"))
         {
            this.uiApi.loadUi("unavailableCharacterPopup");
         }
      }
      
      private function onGiftAssigned(param1:uint) : void
      {
         if(this.sysApi.getGiftList().length > 0)
         {
            this.btn_articles.visible = true;
         }
         else
         {
            this.btn_articles.visible = false;
         }
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupDelete() : void
      {
         this.lockSelection();
         this.sysApi.sendAction(new CharacterDeletion(this._askedToDeleteCharacterId,"000000000000000000"));
      }
      
      public function onPopupReset() : void
      {
         this.sysApi.sendAction(new CharacterReplayRequest(this._selectedChar.id));
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_articles:
               _loc2_ = this.uiApi.getText("ui.charsel.newGift");
               break;
            case this.btn_play:
               if(this._selectedChar.unusable)
               {
                  _loc2_ = this.uiApi.getText("ui.split.unavailableCharacter");
               }
               break;
            case this.tx_bonusXp:
            case this.tx_bonusXpCreation:
               _loc2_ = this.uiApi.getText("ui.information.xpFamilyBonus");
               break;
            default:
               if(param1.name.indexOf("btn_cross") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.charsel.characterDelete");
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",0,8,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.gd_character:
               this._selectedChar = this.gd_character.selectedItem;
               if(!this._selectedChar)
               {
                  return;
               }
               if(param3)
               {
                  this.updateSelectedCharacter();
               }
               if(param2 == SelectMethodEnum.DOUBLE_CLICK)
               {
                  this.validateCharacterChoice();
               }
               break;
         }
      }
      
      public function onAllDownloadTerminated() : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.split.rebootConfirm",[]),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmRestart,null],this.onConfirmRestart);
      }
      
      public function onConfirmRestart() : void
      {
         this.sysApi.reset();
      }
      
      public function onDownloadError(param1:String) : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.split.downloadError",[]),[this.uiApi.getText("ui.common.ok")]);
      }
   }
}
