package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ColorPicker;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.components.VideoPlayer;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.breeds.BreedRole;
   import com.ankamagames.dofus.datacenter.breeds.BreedRoleByBreed;
   import com.ankamagames.dofus.datacenter.breeds.Head;
   import com.ankamagames.dofus.uiApi.ColorApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.LookTypeSoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.CharacterDeselection;
   import d2actions.CharacterNameSuggestionRequest;
   import d2actions.CharacterRemodelSelection;
   import d2enums.CharacterCreationResultEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.CharacterCreationResult;
   import d2hooks.CharacterImpossibleSelection;
   import d2hooks.CharacterNameSuggestioned;
   import d2hooks.FocusChange;
   import flash.events.TextEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   
   public class CharacterCreation
   {
      
      public static const COLOR_GENERATION_METHODE_NUMBER:int = 3;
      
      private static var PROGRESS_ROLE_WIDTH:int;
      
      private static var MAX_BREED_ROLE_VALUE:Number;
      
      private static var TYPE_CREATE:String = "create";
      
      private static var TYPE_REBREED:String = "rebreed";
      
      private static var TYPE_RELOOK:String = "relook";
      
      private static var TYPE_RECOLOR:String = "recolor";
      
      private static var TYPE_RENAME:String = "rename";
      
      private static var TYPE_REGENDER:String = "regender";
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var dataApi:DataApi;
      
      public var uiApi:UiApi;
      
      public var mountApi:MountApi;
      
      public var colorApi:ColorApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      private var _lang:String;
      
      private var _hasRights:Boolean = false;
      
      private var _activeModules:Array;
      
      private var _mandatoryModules:Array;
      
      private var _assetsUri:String;
      
      private var _cinematicsUri:String;
      
      private var _currentPage:int = -1;
      
      private var _bRequestCreation:Boolean = false;
      
      private var _aColors:Array;
      
      private var _aColorsBase:Object;
      
      private var _look:Object;
      
      private var _noStuffLook:Object;
      
      private var _equipmentSkinsStr:String = "";
      
      private var _gender:int;
      
      private var _breed:int;
      
      private var _name:String;
      
      private var _head:int;
      
      private var _direction:int = 3;
      
      private var _initialGender:int;
      
      private var _initialBreed:int;
      
      private var _initialName:String;
      
      private var _initialHead:int;
      
      private var _initialColors:Array;
      
      private var _aBreeds:Array;
      
      private var _aHeads:Array;
      
      private var _aRoles:Array;
      
      private var _aRolesByBreedId:Array;
      
      private var _componentsList:Dictionary;
      
      private var _breedIndex:int;
      
      private var _aTx_color:Array;
      
      private var _yColorsUp:int;
      
      private var _yColorsDown:int;
      
      private var _selectedSlot:uint;
      
      private var _overSlot:uint;
      
      private var _frameCount:uint = 0;
      
      private var _aAnim:Array;
      
      private var _currentLook:String;
      
      private var _randomLookColors:Array;
      
      private var _randomColorEntityDisplayers:Array;
      
      private var _randomColorPage:int = -1;
      
      private var _randomInitialized:Boolean = false;
      
      private var _colorTransform:ColorTransform;
      
      private var _textGlow:GlowFilter;
      
      private var _videoIsPlaying:Boolean = false;
      
      private var _complexityTextures:Array;
      
      private var renderFlagIndex:int = 3;
      
      public var lbl_screen_title:Label;
      
      public var tx_illuBg:Texture;
      
      public var lbl_breed:Label;
      
      public var tx_breedSubtitleBg:Texture;
      
      public var lbl_breedSubtitle:Label;
      
      public var tx_breedSymbol:Texture;
      
      public var ed_chara:EntityDisplayer;
      
      public var btn_leftArrow:ButtonContainer;
      
      public var btn_rightArrow:ButtonContainer;
      
      public var btn_showEquipment:ButtonContainer;
      
      public var ctn_left:GraphicContainer;
      
      public var ctr_breedChoice:GraphicContainer;
      
      public var ctr_arrowsBreedChoice:GraphicContainer;
      
      public var ctr_breedComplexity:GraphicContainer;
      
      public var lbl_breedComplexity:Label;
      
      public var ctr_stars:GraphicContainer;
      
      public var tx_breedComplexity_0:Texture;
      
      public var tx_breedComplexity_1:Texture;
      
      public var tx_breedComplexity_2:Texture;
      
      public var btn_breedInfo:ButtonContainer;
      
      public var videoPlayerSmall:VideoPlayer;
      
      public var tx_videoPlayerSmallPlay:Texture;
      
      public var ctr_roleItem0:GraphicContainer;
      
      public var tx_role0:Texture;
      
      public var lbl_roleTitle0:Label;
      
      public var lbl_role0:Label;
      
      public var ctr_roleItem1:GraphicContainer;
      
      public var tx_role1:Texture;
      
      public var lbl_roleTitle1:Label;
      
      public var lbl_role1:Label;
      
      public var ctr_roleItem2:GraphicContainer;
      
      public var tx_role2:Texture;
      
      public var lbl_roleTitle2:Label;
      
      public var lbl_role2:Label;
      
      public var btn_breedSex0:ButtonContainer;
      
      public var btn_breedSex1:ButtonContainer;
      
      public var gd_breed:Grid;
      
      public var btn_left:ButtonContainer;
      
      public var btn_right:ButtonContainer;
      
      public var ctr_breedInfos:GraphicContainer;
      
      public var lbl_title_ctr_breedInfos:Label;
      
      public var texta_breedInfo:TextArea;
      
      public var gd_breedAllRoles:Grid;
      
      public var gd_spells:Grid;
      
      public var btn_close_ctr_breedInfos:ButtonContainer;
      
      public var ctr_breedCustomization:GraphicContainer;
      
      public var ctr_breedPresentation:GraphicContainer;
      
      public var btn_customSex0:ButtonContainer;
      
      public var btn_customSex1:ButtonContainer;
      
      public var gd_heads:Grid;
      
      public var btn_color0:ButtonContainer;
      
      public var btn_color1:ButtonContainer;
      
      public var btn_color2:ButtonContainer;
      
      public var btn_color3:ButtonContainer;
      
      public var btn_color4:ButtonContainer;
      
      public var btn_reinitColor0:ButtonContainer;
      
      public var btn_reinitColor1:ButtonContainer;
      
      public var btn_reinitColor2:ButtonContainer;
      
      public var btn_reinitColor3:ButtonContainer;
      
      public var btn_reinitColor4:ButtonContainer;
      
      public var tx_color0:Texture;
      
      public var tx_color1:Texture;
      
      public var tx_color2:Texture;
      
      public var tx_color3:Texture;
      
      public var tx_color4:Texture;
      
      public var tx_colorDisabled0:Texture;
      
      public var tx_colorDisabled1:Texture;
      
      public var tx_colorDisabled2:Texture;
      
      public var tx_colorDisabled3:Texture;
      
      public var tx_colorDisabled4:Texture;
      
      public var cp_colorPk:ColorPicker;
      
      public var btn_reinitColor:ButtonContainer;
      
      public var btn_generateColor:ButtonContainer;
      
      public var tx_name:TextureBitmap;
      
      public var input_name:Input;
      
      public var tx_nameRules:Texture;
      
      public var btn_generateName:ButtonContainer;
      
      public var ctr_hexaColor:GraphicContainer;
      
      public var inp_hexaValue:Input;
      
      public var btn_hexaOk:ButtonContainer;
      
      public var btn_next:ButtonContainer;
      
      public var btn_previous:ButtonContainer;
      
      public var btn_lbl_btn_next:Label;
      
      public var ctr_videoPlayerFull:GraphicContainer;
      
      public var videoPlayerFull:VideoPlayer;
      
      public var btn_closeVideo:ButtonContainer;
      
      public function CharacterCreation()
      {
         this._activeModules = new Array();
         this._mandatoryModules = new Array();
         this._componentsList = new Dictionary(true);
         this._randomLookColors = new Array();
         this._randomColorEntityDisplayers = new Array();
         this._colorTransform = new ColorTransform();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:BreedRole = null;
         var _loc3_:int = 0;
         var _loc4_:Breed = null;
         var _loc5_:GlowFilter = null;
         var _loc6_:Head = null;
         var _loc7_:* = undefined;
         var _loc8_:BreedRoleByBreed = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Breed = null;
         var _loc14_:Array = null;
         var _loc15_:Breed = null;
         var _loc16_:Head = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:String = null;
         var _loc21_:Array = null;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         this.ctr_breedInfos.visible = false;
         this.ctr_hexaColor.visible = false;
         this.texta_breedInfo.hideScroll = true;
         this.btn_leftArrow.soundId = SoundEnum.SCROLL_DOWN;
         this.btn_rightArrow.soundId = SoundEnum.SCROLL_UP;
         this.btn_breedSex0.soundId = SoundEnum.CHECKBOX_UNCHECKED;
         this.btn_breedSex1.soundId = SoundEnum.CHECKBOX_CHECKED;
         this.btn_customSex0.soundId = SoundEnum.CHECKBOX_UNCHECKED;
         this.btn_customSex1.soundId = SoundEnum.CHECKBOX_CHECKED;
         this.btn_breedInfo.soundId = SoundEnum.SPEC_BUTTON;
         this.btn_previous.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_close_ctr_breedInfos.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_showEquipment.visible = false;
         this.sysApi.addHook(CharacterCreationResult,this.onCharacterCreationResult);
         this.sysApi.addHook(CharacterNameSuggestioned,this.onCharacterNameSuggestioned);
         this.sysApi.addHook(CharacterImpossibleSelection,this.onCharacterImpossibleSelection);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.tx_nameRules,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_nameRules,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_showEquipment,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_showEquipment,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_generateColor,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_generateColor,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_generateName,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_generateName,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_breedComplexity_0,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_breedComplexity_0,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_breedComplexity_1,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_breedComplexity_1,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_breedComplexity_2,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_breedComplexity_2,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ed_chara,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ed_chara,ComponentHookList.ON_ENTITY_READY);
         this.uiApi.addComponentHook(this.input_name,"onChange");
         this.uiApi.addComponentHook(this.input_name,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.videoPlayerSmall,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.videoPlayerSmall,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.videoPlayerSmall,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.videoPlayerFull,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_left,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_right,ComponentHookList.ON_RELEASE);
         this._complexityTextures = new Array();
         this._complexityTextures.push(this.tx_breedComplexity_0);
         this._complexityTextures.push(this.tx_breedComplexity_1);
         this._complexityTextures.push(this.tx_breedComplexity_2);
         this.videoPlayerSmall.handCursor = true;
         this.videoPlayerSmall.mute = true;
         if(param1 && param1[0] is Array && param1[1] is Array)
         {
            this._activeModules = param1[0];
            this._mandatoryModules = param1[1];
         }
         else
         {
            this._activeModules.push(TYPE_CREATE);
         }
         this._assetsUri = this.uiApi.me().getConstant("breed_uri");
         this._cinematicsUri = this.sysApi.getConfigEntry("config.gfx.path.cinematic") + this.sysApi.getCurrentLanguage();
         PROGRESS_ROLE_WIDTH = int(this.uiApi.me().getConstant("progressbar_role_width"));
         this.input_name.maxChars = ProtocolConstantsEnum.MAX_PLAYER_NAME_LEN - 1;
         this._lang = this.sysApi.getCurrentLanguage();
         this._hasRights = this.sysApi.getPlayerManager().hasRights;
         if(!this._hasRights)
         {
            switch(this._lang)
            {
               case "ru":
                  this.input_name.restrict = "^ ";
                  break;
               case "ja":
                  this.input_name.restrict = "[ァ-ヾぁ-ゞA-Za-z\\-]+";
                  break;
               case "fr":
               case "en":
               case "es":
               case "de":
               case "it":
               case "nl":
               case "pt":
               default:
                  this.input_name.restrict = "A-Z\\-a-z";
            }
         }
         this._aTx_color = new Array(this.tx_color0,this.tx_color1,this.tx_color2,this.tx_color3,this.tx_color4);
         this._aColors = new Array(-1,-1,-1,-1,-1);
         this._initialColors = new Array(-1,-1,-1,-1,-1);
         this._aRoles = new Array();
         for each(_loc2_ in this.dataApi.getBreedRoles())
         {
            this._aRoles[_loc2_.id] = _loc2_;
         }
         this._aBreeds = new Array();
         this._aRolesByBreedId = new Array();
         MAX_BREED_ROLE_VALUE = 0;
         for each(_loc4_ in this.dataApi.getBreeds())
         {
            if((Math.pow(2,_loc4_.id - 1) & Connection.BREEDS_VISIBLE) > 0)
            {
               this._aBreeds.push(_loc4_);
               this._aRolesByBreedId[_loc4_.id] = new Array();
               for each(_loc8_ in _loc4_.breedRoles)
               {
                  if(MAX_BREED_ROLE_VALUE < _loc8_.value)
                  {
                     MAX_BREED_ROLE_VALUE = _loc8_.value;
                  }
                  this._aRolesByBreedId[_loc4_.id][_loc8_.roleId] = {
                     "id":_loc8_.roleId,
                     "name":this._aRoles[_loc8_.roleId].name,
                     "color":this._aRoles[_loc8_.roleId].color,
                     "value":_loc8_.value,
                     "description":_loc8_.description,
                     "assetId":this._aRoles[_loc8_.roleId].assetId,
                     "order":_loc8_.order
                  };
               }
            }
         }
         this._aBreeds.sortOn(["complexity","sortIndex"],[Array.NUMERIC,Array.NUMERIC]);
         this.gd_breed.dataProvider = this._aBreeds;
         this._textGlow = new GlowFilter(this.sysApi.getConfigEntry("colors.text.glow.light"),1,12,12,1);
         _loc5_ = new GlowFilter(this.sysApi.getConfigEntry("colors.text.glow.red"),0.4,5,5,1,1,true);
         this.videoPlayerSmall.filters = [this._textGlow];
         this._aHeads = new Array();
         for each(_loc6_ in this.dataApi.getHeads())
         {
            this._aHeads.push(_loc6_);
         }
         if(param1 && param1[2])
         {
            _loc9_ = param1[2];
            this._gender = int(_loc9_.gender);
            this._breed = _loc9_.breed;
            this._name = _loc9_.name;
            this._head = _loc9_.cosmeticId;
            this._initialGender = int(_loc9_.gender);
            this._initialBreed = _loc9_.breed;
            this._initialName = _loc9_.name;
            this._initialHead = _loc9_.cosmeticId;
            this.input_name.text = this._name;
            _loc10_ = 0;
            for each(_loc11_ in _loc9_.colors)
            {
               this._aColors[_loc10_] = _loc11_;
               this._initialColors[_loc10_] = _loc11_;
               _loc10_++;
            }
            this._look = this.mountApi.getRiderEntityLook(_loc9_.entityLook);
            this.ed_chara.clearSubEntities = false;
            _loc12_ = 0;
            for each(_loc13_ in this._aBreeds)
            {
               if(_loc13_.id == this._breed)
               {
                  this._breedIndex = _loc12_;
                  break;
               }
               _loc12_++;
            }
            this.gd_breed.selectedIndex = this._breedIndex;
            _loc14_ = new Array();
            for each(_loc6_ in this._aHeads)
            {
               if(_loc6_.breed == this._breed && _loc6_.gender == this._gender)
               {
                  _loc14_.push(_loc6_);
               }
            }
            _loc14_.sortOn("order",Array.NUMERIC);
            this.gd_heads.dataProvider = _loc14_;
            this.getHeadFromLook();
            _loc12_ = 0;
            for each(_loc6_ in this.gd_heads.dataProvider)
            {
               if(_loc6_.id == this._head)
               {
                  this.gd_heads.selectedIndex = _loc12_;
                  break;
               }
               _loc12_++;
            }
            if(this._look.getBone() != 1)
            {
               this._look = null;
               this.btn_showEquipment.softDisabled = true;
               this.btn_showEquipment.selected = false;
            }
            else
            {
               this.btn_showEquipment.selected = true;
               _loc15_ = this._aBreeds[this._breedIndex];
               _loc16_ = this.dataApi.getHead(this._head);
               _loc17_ = this._look.toString().split("|");
               _loc18_ = _loc17_[1].split(",");
               _loc19_ = _loc16_.skins.split(",");
               if(this._gender == 0)
               {
                  _loc20_ = _loc15_.maleLook;
               }
               else
               {
                  _loc20_ = _loc15_.femaleLook;
               }
               _loc21_ = _loc20_.split("|")[1].split(",");
               for each(_loc22_ in _loc18_)
               {
                  if(_loc21_.indexOf(_loc22_) == -1 && _loc19_.indexOf(_loc22_) == -1)
                  {
                     this._equipmentSkinsStr = this._equipmentSkinsStr + (_loc22_ + ",");
                  }
               }
               if(this._equipmentSkinsStr != "")
               {
                  this._equipmentSkinsStr = this._equipmentSkinsStr.slice(0,this._equipmentSkinsStr.length - 1);
               }
            }
         }
         else
         {
            this._gender = Math.round(Math.random());
            _loc23_ = -1;
            if(Connection.BREEDS_AVAILABLE > 0)
            {
               do
               {
                  _loc23_ = Math.floor(Math.random() * this._aBreeds.length);
               }
               while((Math.pow(2,this._aBreeds[_loc23_].id - 1) & Connection.BREEDS_AVAILABLE) <= 0);
               
               this.gd_breed.selectedIndex = _loc23_;
            }
            else
            {
               this.gd_breed.selectedIndex = -1;
            }
            this.gd_heads.selectedIndex = 0;
         }
         if(this._activeModules.indexOf(TYPE_CREATE) != -1)
         {
            this.input_name.text = this.uiApi.getText("ui.charcrea.titleRename");
            this.input_name.textfield.addEventListener(TextEvent.TEXT_INPUT,this.onInput);
            this.displayPage(0);
         }
         else
         {
            if(this._activeModules.indexOf(TYPE_REBREED) != -1)
            {
               this.displayPage(0);
            }
            else
            {
               this.displayPage(1);
            }
            if(this._activeModules.indexOf(TYPE_RECOLOR) != -1 || this._activeModules.indexOf(TYPE_RELOOK) != -1 || this._activeModules.indexOf(TYPE_REBREED) != -1)
            {
               this.btn_showEquipment.visible = true;
            }
            if(this._activeModules.indexOf(TYPE_RENAME) != -1)
            {
               this.input_name.textfield.addEventListener(TextEvent.TEXT_INPUT,this.onInput);
            }
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.charcrea.characterModificationWarning"),[this.uiApi.getText("ui.common.ok")]);
         }
         for(_loc7_ in this._aColors)
         {
            if(this._aTx_color[_loc7_])
            {
               this.changeColor(this._aTx_color[_loc7_],this._aColors[_loc7_]);
            }
         }
         this.uiApi.setRadioGroupSelectedItem("colorGroup",this.btn_color0,this.uiApi.me());
         this._aAnim = new Array("AnimStatique","AnimMarche","AnimCourse","AnimAttaque0");
         this.switchMode();
         this.ctr_stars.x = this.lbl_breedComplexity.x + this.lbl_breedComplexity.textWidth + 15;
         this.updateRolesAndVideoPosition();
         this.renderFlagIndex = 2;
      }
      
      public function renderUpdate() : void
      {
         this.renderFlagIndex--;
         if(this.renderFlagIndex == 0)
         {
            this.ctn_left.visible = true;
            this.renderFlagIndex = -1;
         }
      }
      
      public function unload() : void
      {
         this.input_name.textfield.removeEventListener(TextEvent.TEXT_INPUT,this.onInput);
         this.videoPlayerSmall.stop();
         this.videoPlayerFull.stop();
      }
      
      private function displayPage(param1:int) : void
      {
         var _loc2_:* = undefined;
         if(param1 == this._currentPage)
         {
            return;
         }
         if(param1 == 0)
         {
            this.btn_lbl_btn_next.text = this.uiApi.getText("ui.charcrea.selectClass");
            this.ctr_breedChoice.visible = true;
            this.ctr_arrowsBreedChoice.visible = true;
            this.ctr_breedCustomization.visible = false;
            this.ctr_breedPresentation.visible = true;
            this.videoPlayerSmall.play();
            this._videoIsPlaying = true;
            this.lbl_screen_title.text = this.uiApi.getText("ui.charcrea.choseClass");
         }
         else
         {
            for(_loc2_ in this._aColorsBase)
            {
               if(this._aColors[_loc2_] == -1)
               {
                  this._aColors[_loc2_] = this._aColorsBase[_loc2_];
               }
            }
            this.btn_lbl_btn_next.text = this.uiApi.getText("ui.common.play");
            this.ctr_breedChoice.visible = false;
            this.ctr_arrowsBreedChoice.visible = false;
            this.ctr_breedCustomization.visible = true;
            this.ctr_breedPresentation.visible = false;
            this.lbl_screen_title.text = this.uiApi.getText("ui.charcrea.personalized");
            this.ctr_videoPlayerFull.visible = false;
            this.videoPlayerSmall.pause();
            this.videoPlayerFull.pause();
            this._videoIsPlaying = false;
         }
         this._currentPage = param1;
      }
      
      private function switchMode() : void
      {
         if(this._activeModules.indexOf(TYPE_CREATE) != -1)
         {
            return;
         }
         this.gd_breed.disabled = true;
         this.btn_breedInfo.disabled = true;
         this.btn_breedSex0.disabled = true;
         this.btn_customSex0.disabled = true;
         this.btn_breedSex1.disabled = true;
         this.btn_customSex1.disabled = true;
         this.btn_color0.disabled = true;
         this.btn_color1.disabled = true;
         this.btn_color2.disabled = true;
         this.btn_color3.disabled = true;
         this.btn_color4.disabled = true;
         this.tx_colorDisabled0.visible = true;
         this.tx_colorDisabled1.visible = true;
         this.tx_colorDisabled2.visible = true;
         this.tx_colorDisabled3.visible = true;
         this.tx_colorDisabled4.visible = true;
         this.btn_reinitColor0.visible = false;
         this.btn_reinitColor1.visible = false;
         this.btn_reinitColor2.visible = false;
         this.btn_reinitColor3.visible = false;
         this.btn_reinitColor4.visible = false;
         this.cp_colorPk.disabled = true;
         this.btn_reinitColor.disabled = true;
         this.btn_generateColor.disabled = true;
         this.gd_heads.disabled = true;
         this.input_name.disabled = true;
         this.tx_name.disabled = true;
         this.btn_generateName.disabled = true;
         this.btn_showEquipment.visible = false;
         if(this._activeModules.indexOf(TYPE_RENAME) != -1)
         {
            this.input_name.disabled = false;
            this.tx_name.disabled = false;
            this.btn_generateName.disabled = false;
         }
         if(this._activeModules.indexOf(TYPE_RELOOK) != -1)
         {
            this.gd_heads.disabled = false;
            this.btn_showEquipment.visible = true;
         }
         if(this._activeModules.indexOf(TYPE_RECOLOR) != -1)
         {
            this.btn_color0.disabled = false;
            this.btn_color1.disabled = false;
            this.btn_color2.disabled = false;
            this.btn_color3.disabled = false;
            this.btn_color4.disabled = false;
            this.tx_colorDisabled0.visible = false;
            this.tx_colorDisabled1.visible = false;
            this.tx_colorDisabled2.visible = false;
            this.tx_colorDisabled3.visible = false;
            this.tx_colorDisabled4.visible = false;
            this.btn_reinitColor0.visible = true;
            this.btn_reinitColor1.visible = true;
            this.btn_reinitColor2.visible = true;
            this.btn_reinitColor3.visible = true;
            this.btn_reinitColor4.visible = true;
            this.cp_colorPk.disabled = false;
            this.btn_reinitColor.disabled = false;
            this.btn_generateColor.disabled = false;
            this.btn_showEquipment.visible = true;
         }
         if(this._activeModules.indexOf(TYPE_REBREED) != -1)
         {
            this.gd_breed.disabled = false;
            this.btn_breedInfo.disabled = false;
            this.btn_showEquipment.visible = true;
         }
         if(this._activeModules.indexOf(TYPE_REGENDER) != -1)
         {
            this.btn_breedSex0.disabled = false;
            this.btn_customSex0.disabled = false;
            this.btn_breedSex1.disabled = false;
            this.btn_customSex1.disabled = false;
            this.btn_showEquipment.visible = true;
         }
      }
      
      private function displayCharacter() : void
      {
         var _loc5_:* = undefined;
         var _loc6_:Head = null;
         var _loc7_:String = null;
         var _loc1_:String = "";
         var _loc2_:* = "";
         var _loc3_:Breed = this._aBreeds[this._breedIndex];
         if(this._gender == 0)
         {
            _loc1_ = _loc3_.maleLook;
            _loc2_ = "{" + _loc3_.maleArtwork + "}";
            this._aColorsBase = _loc3_.maleColors;
         }
         else
         {
            _loc1_ = _loc3_.femaleLook;
            _loc2_ = "{" + _loc3_.femaleArtwork + "}";
            this._aColorsBase = _loc3_.femaleColors;
         }
         var _loc4_:String = "";
         for(_loc5_ in this._aColors)
         {
            if(this._aColors[_loc5_] != -1)
            {
               _loc7_ = this._aColors[_loc5_].toString(16);
            }
            else if(this._aColorsBase && this._aColorsBase.length > _loc5_)
            {
               _loc7_ = this._aColorsBase[_loc5_].toString(16);
               this.changeColor(this["tx_color" + _loc5_],this._aColorsBase[_loc5_]);
            }
            else
            {
               _loc7_ = (Math.random() * 16777215).toString(16);
            }
            _loc4_ = _loc4_ + (_loc5_ + 1 + "=#" + _loc7_ + ",");
         }
         _loc4_ = _loc4_.substring(0,_loc4_.length - 1);
         _loc6_ = this.dataApi.getHead(this._head);
         if(_loc6_ && _loc6_.skins && _loc6_.skins != "0")
         {
            _loc1_ = _loc1_.replace("||","," + _loc6_.skins + "||");
         }
         _loc1_ = _loc1_.replace("||","|" + _loc4_ + "|");
         _loc2_ = _loc2_.replace("}","||" + _loc4_ + "}");
         if(!this.btn_showEquipment.disabled && !this.btn_showEquipment.softDisabled && this.btn_showEquipment.visible)
         {
            this.displayEquipment(_loc1_);
         }
         else
         {
            this.ed_chara.look = this.sysApi.getEntityLookFromString(_loc1_);
         }
         this.updateDirection(this._direction);
         this._currentLook = _loc1_;
         this.tx_illuBg.uri = this.uiApi.createUri(this._assetsUri + "bg_" + this._breed + "" + this._gender + ".jpg");
      }
      
      private function colorizeCharacter() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._aColors)
         {
            if(this._aColors[_loc1_] != -1)
            {
               this.ed_chara.setColor(_loc1_ + 1,this._aColors[_loc1_]);
            }
            else if(this._aColorsBase.length > _loc1_)
            {
               this.ed_chara.setColor(_loc1_ + 1,this._aColorsBase[_loc1_]);
            }
         }
      }
      
      private function generateColors() : void
      {
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(this._breed)
         {
            case 12:
               _loc2_ = Math.random() * 750 + 250;
               if(_loc2_ > 750)
               {
                  _loc1_ = Math.random() * 1000;
               }
               else
               {
                  _loc1_ = Math.random() * 90 + 50;
               }
               _loc3_ = Math.random() * 100;
               break;
            case 6:
               _loc1_ = Math.random() * 140 + 25;
               _loc2_ = Math.random() * 700 + 200;
               _loc3_ = Math.random() * 80 + 10;
               break;
            default:
               _loc1_ = Math.random() * 90 + 50;
               _loc2_ = Math.random() * 650 + 250;
               _loc3_ = Math.random() * 80 + 10;
         }
         var _loc4_:uint = this.getColorByXYSlideX(_loc1_,_loc2_,_loc3_);
         var _loc5_:Array = new Array();
         _loc7_ = 0;
         while(_loc7_ <= COLOR_GENERATION_METHODE_NUMBER)
         {
            _loc8_ = new Array();
            _loc8_[0] = _loc4_;
            _loc6_ = this.colorApi.generateColorList(_loc7_);
            _loc9_ = Math.min(4,_loc6_.length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc8_[_loc10_ + 1] = _loc6_[_loc10_];
               _loc10_++;
            }
            _loc5_.push(_loc8_);
            _loc7_++;
         }
         this._randomLookColors.push(_loc5_);
         this._randomColorPage = this._randomLookColors.length - 1;
         this.updateRandomColorLook();
      }
      
      private function changeRandomPage(param1:int) : void
      {
         if(param1 == 99)
         {
            param1 = 0;
         }
         else if(param1 == -1)
         {
            param1 = 99;
         }
         this._randomColorPage = param1;
         this.updateRandomColorLook();
      }
      
      private function getHeadFromLook() : void
      {
         var _loc2_:Head = null;
         var _loc1_:Array = this._look.toString().split("|");
         for each(_loc2_ in this._aHeads)
         {
            if(_loc2_.breed == this._breed && _loc2_.gender == this._gender)
            {
               if(_loc1_[1] && _loc1_[1].indexOf(_loc2_.skins) != -1)
               {
                  this._head = _loc2_.id;
                  return;
               }
            }
         }
      }
      
      public function updateBreed(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.ctr_breed.name])
         {
            this.uiApi.addComponentHook(param2.ctr_breed,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_breed,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.ctr_breed.name] = param1;
         if(param1)
         {
            if(param1.id < 10)
            {
               param2.tx_breed.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus") + "vignettingMiniCharacter/" + "mini_" + param1.id + "_" + this._gender + ".png");
            }
            else
            {
               param2.tx_breed.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus") + "vignettingMiniCharacter/" + "mini_" + param1.id + "_" + this._gender + ".png");
            }
            if(param3)
            {
               param2.tx_selected.visible = true;
               param2.tx_veil.visible = false;
               param2.tx_selected_arrow.visible = true;
            }
            else
            {
               param2.tx_selected.visible = false;
               param2.tx_veil.visible = true;
               param2.tx_selected_arrow.visible = false;
            }
            if(Connection.BREEDS_AVAILABLE > 0 && (Math.pow(2,param1.id - 1) & Connection.BREEDS_AVAILABLE) > 0 && param1.id != this._initialBreed)
            {
               param2.tx_grey.visible = false;
            }
            else
            {
               param2.tx_grey.visible = true;
            }
         }
         else
         {
            param2.tx_veil.visible = false;
            param2.tx_selected_arrow.visible = false;
         }
      }
      
      public function updateHead(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.btn_head.name])
         {
            this.uiApi.addComponentHook(param2.btn_head,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_head,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.btn_head.name] = param1;
         if(param1)
         {
            param2.tx_head.uri = this.uiApi.createUri(this.uiApi.me().getConstant("heads_uri") + param1.assetId + ".png");
            if(param3)
            {
               param2.tx_hselected.visible = true;
            }
            else
            {
               param2.tx_hselected.visible = false;
            }
         }
      }
      
      public function updateInfoRole(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         if(!this._componentsList[param2.lbl_role.name])
         {
            this.uiApi.addComponentHook(param2.lbl_role,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_role,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.lbl_role.name] = param1;
         if(param1)
         {
            param2.lbl_role.text = param1.name;
            param2.tx_roleSmall.uri = this.uiApi.createUri(this.uiApi.me().getConstant("breed_uri") + "icon_caracteristics/role_" + param1.assetId + ".png");
            _loc4_ = param1.value / MAX_BREED_ROLE_VALUE;
            if(_loc4_ > 1)
            {
               _loc4_ = 1;
            }
            param2.pb_progressBar.barColor = param1.color;
            param2.pb_progressBar.value = _loc4_;
         }
      }
      
      public function updatePreviewLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.btn_randomLook.name])
         {
            this.uiApi.addComponentHook(param2.btn_randomLook,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_randomLook,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.btn_randomLook.name] = param1;
         if(param1 && this._randomColorEntityDisplayers.length <= 6)
         {
            this._randomColorEntityDisplayers.push(param2.ed_charPreview);
         }
      }
      
      private function displayComplexity(param1:int) : void
      {
         var _loc2_:Object = this.uiApi.createUri(this.uiApi.me().getConstant("star_green_uri"));
         var _loc3_:Object = this.uiApi.createUri(this.uiApi.me().getConstant("star_black_uri"));
         var _loc4_:int = 0;
         while(_loc4_ < this._complexityTextures.length)
         {
            this._complexityTextures[_loc4_].uri = param1 <= _loc4_?_loc3_:_loc2_;
            _loc4_++;
         }
      }
      
      private function displayBreed() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         this.tx_breedSymbol.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illus") + "symbol_" + this._breed + ".png");
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._aRolesByBreedId[this._breed])
         {
            if(_loc3_.order > 0)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_.push(_loc3_);
         }
         _loc1_.sortOn("order",Array.NUMERIC);
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            this["tx_role" + _loc4_].uri = this.uiApi.createUri(this.uiApi.me().getConstant("breed_uri") + "icon_caracteristics/role_" + _loc1_[_loc4_].assetId + ".png");
            this["lbl_roleTitle" + _loc4_].text = (_loc1_[_loc4_].name as String).toLocaleUpperCase();
            this["lbl_role" + _loc4_].text = _loc1_[_loc4_].description;
            _loc4_++;
         }
         this.updateRolesAndVideoPosition();
         this.gd_breedAllRoles.dataProvider = _loc2_;
         this.updateGender(this._gender);
         if(!this._aBreeds[this._breedIndex])
         {
            this.lbl_breed.text = "?";
            this.lbl_breedSubtitle.text = "?";
            this.texta_breedInfo.text = "?";
            this.lbl_title_ctr_breedInfos.text = "?";
            this.displayComplexity(0);
         }
         else
         {
            this.lbl_breed.text = (this._aBreeds[this._breedIndex].shortName as String).toLocaleUpperCase();
            this.lbl_breedSubtitle.text = this._aBreeds[this._breedIndex].gameplayDescription;
            this.displayComplexity(this._aBreeds[this._breedIndex].complexity);
            this.lbl_title_ctr_breedInfos.text = this._aBreeds[this._breedIndex].longName;
            this.lbl_title_ctr_breedInfos.forceUppercase = true;
            this.texta_breedInfo.text = this._aBreeds[this._breedIndex].description;
            _loc6_ = new Array();
            for each(_loc7_ in this._aBreeds[this._breedIndex].breedSpellsId)
            {
               _loc6_.push(this.dataApi.getSpellWrapper(_loc7_));
            }
            this.gd_spells.dataProvider = _loc6_;
         }
         var _loc5_:* = this._cinematicsUri + "/class_" + this._aBreeds[this._breedIndex].id + ".mp4";
         this.videoPlayerSmall.flv = _loc5_;
         this.videoPlayerFull.flv = _loc5_;
         if(this.ctr_videoPlayerFull.visible)
         {
            this.videoPlayerFull.play();
         }
         else
         {
            this.videoPlayerSmall.play();
         }
         this._videoIsPlaying = true;
      }
      
      private function updateRolesAndVideoPosition() : void
      {
         this.uiApi.me().render();
      }
      
      private function updateGender(param1:int, param2:Boolean = false) : void
      {
         var _loc6_:Head = null;
         if(param2 || param1 == 0 && !this.btn_breedSex0.selected && !this.btn_customSex0.selected || param1 == 1 && !this.btn_breedSex1.selected && !this.btn_customSex1.selected)
         {
            this._gender = param1;
            if(param1 == 0)
            {
               this.uiApi.setRadioGroupSelectedItem("genderGroupBreed",this.btn_breedSex0,this.uiApi.me());
               this.uiApi.setRadioGroupSelectedItem("genderGroupCustom",this.btn_customSex0,this.uiApi.me());
            }
            else
            {
               this.uiApi.setRadioGroupSelectedItem("genderGroupBreed",this.btn_breedSex1,this.uiApi.me());
               this.uiApi.setRadioGroupSelectedItem("genderGroupCustom",this.btn_customSex1,this.uiApi.me());
            }
            this.gd_breed.dataProvider = this._aBreeds;
         }
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in this._aHeads)
         {
            if(_loc6_.breed == this._breed && _loc6_.gender == this._gender)
            {
               _loc3_.push(_loc6_);
               if(this._head > 0 && _loc6_.id == this._head)
               {
                  _loc5_ = _loc4_;
               }
               _loc4_++;
            }
         }
         _loc3_.sortOn("order",Array.NUMERIC);
         this._head = _loc3_[_loc5_].id;
         this.gd_heads.dataProvider = _loc3_;
         this.gd_heads.silent = true;
         this.gd_heads.selectedIndex = _loc5_;
         this.gd_heads.silent = false;
         this.displayCharacter();
      }
      
      private function createCharacter() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         if(Connection.BREEDS_AVAILABLE == 0)
         {
            return;
         }
         var _loc1_:uint = 0;
         if(this._activeModules.indexOf(TYPE_CREATE) != -1 || this._activeModules.indexOf(TYPE_RENAME) != -1)
         {
            this._name = this.input_name.text;
            if(this._hasRights)
            {
               if(this._name.length < 2)
               {
                  this.sysApi.log(8,this._name + " trop court");
                  _loc1_ = 1;
               }
            }
            else if(this._lang != "ru")
            {
               if(this._lang != "ja")
               {
                  _loc1_ = this.verifName();
               }
               else
               {
                  _loc1_ = this.verifNameJa();
               }
            }
         }
         if(!this._name || this._name == "")
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.noName"),[this.uiApi.getText("ui.common.ok")]);
            this._bRequestCreation = false;
            this.btn_next.disabled = false;
            return;
         }
         if(_loc1_ > 0)
         {
            _loc2_ = this.uiApi.getText("ui.charcrea.invalidNameReason" + _loc1_);
            this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.invalidName") + "\n\n" + _loc2_,[this.uiApi.getText("ui.common.ok")]);
            this._bRequestCreation = false;
            this.btn_next.disabled = false;
            return;
         }
         if(this._activeModules.indexOf(TYPE_CREATE) == -1)
         {
            _loc3_ = "";
            if(this._mandatoryModules.indexOf(TYPE_RENAME) != -1 && this._name == this._initialName)
            {
               _loc3_ = this.uiApi.getText("ui.charcrea.mandatoryName");
            }
            if(this._mandatoryModules.indexOf(TYPE_RECOLOR) != -1)
            {
               _loc4_ = 0;
               _loc5_ = 0;
               for each(_loc6_ in this._aColors)
               {
                  if(this._aColors[_loc4_] == this._initialColors[_loc4_])
                  {
                     _loc5_++;
                  }
                  _loc4_++;
               }
               if(_loc5_ == _loc4_)
               {
                  _loc3_ = this.uiApi.getText("ui.charcrea.mandatoryColors");
               }
            }
            if(this._mandatoryModules.indexOf(TYPE_RELOOK) != -1 && this._head == this._initialHead)
            {
               _loc3_ = this.uiApi.getText("ui.charcrea.mandatoryHead");
            }
            if(this._mandatoryModules.indexOf(TYPE_REGENDER) != -1 && this._gender == this._initialGender)
            {
               _loc3_ = this.uiApi.getText("ui.charcrea.mandatoryGender");
            }
            if(this._mandatoryModules.indexOf(TYPE_REBREED) != -1 && this._breed == this._initialBreed)
            {
               _loc3_ = this.uiApi.getText("ui.charcrea.mandatoryBreed");
            }
            if(_loc3_ != "")
            {
               _loc2_ = this.uiApi.getText("ui.charcrea.invalidNameReason" + _loc1_);
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc3_,[this.uiApi.getText("ui.common.ok")]);
               this._bRequestCreation = false;
               this.btn_next.disabled = false;
               return;
            }
         }
         Connection.waitingForCharactersList = true;
         this.lockCreation();
         if(this._activeModules.indexOf(TYPE_CREATE) != -1)
         {
            this.sysApi.sendAction(new d2actions.CharacterCreation(this._name,this._breed,this._gender != 0,this._aColors,this._head));
         }
         else
         {
            _loc7_ = new Vector.<int>();
            for each(_loc8_ in this._aColors)
            {
               _loc7_.push(_loc8_);
            }
            this.sysApi.sendAction(new CharacterRemodelSelection(0,this._gender != 0,this._breed,this._head,this._name,_loc7_));
         }
      }
      
      private function changeColor(param1:Object, param2:Number = 16777215) : void
      {
         var _loc3_:ColorTransform = null;
         if(param2 != -1)
         {
            _loc3_ = new ColorTransform();
            _loc3_.color = param2;
            param1.transform.colorTransform = _loc3_;
            param1.visible = true;
            this.ed_chara.setColor(this._aColors.indexOf(param2),this._aColors[param2]);
         }
         else
         {
            param1.visible = false;
            this.ed_chara.resetColor(param2 + 1);
         }
      }
      
      private function wheelChara(param1:int) : void
      {
         var _loc2_:int = (this._direction + param1 + 8) % 8;
         this.updateDirection(_loc2_);
      }
      
      private function resetColor(param1:int = -1) : void
      {
         var _loc2_:* = undefined;
         if(param1 == -1)
         {
            for(_loc2_ in this._aTx_color)
            {
               this._aColors[_loc2_] = -1;
               this.changeColor(this._aTx_color[_loc2_],this._aColorsBase[_loc2_]);
            }
            this.cp_colorPk.color = this._aColorsBase[this._selectedSlot];
         }
         else
         {
            this._aColors[param1] = -1;
            this.changeColor(this._aTx_color[param1],-1);
         }
         this.colorizeCharacter();
      }
      
      private function verifName() : uint
      {
         var _loc3_:* = undefined;
         var _loc5_:int = 0;
         if(this._name.length < ProtocolConstantsEnum.MIN_PLAYER_NAME_LEN)
         {
            this.sysApi.log(8,this._name + " trop court");
            return 1;
         }
         if(this._name.length > ProtocolConstantsEnum.MAX_PLAYER_NAME_LEN)
         {
            this.sysApi.log(8,this._name + " trop long");
            return 1;
         }
         var _loc1_:String = this._name.toLowerCase();
         if(_loc1_.indexOf("xelor") != -1 || _loc1_.indexOf("iop") != -1 || _loc1_.indexOf("feca") != -1 || _loc1_.indexOf("eniripsa") != -1 || _loc1_.indexOf("sadida") != -1 || _loc1_.indexOf("ecaflip") != -1 || _loc1_.indexOf("enutrof") != -1 || _loc1_.indexOf("pandawa") != -1 || _loc1_.indexOf("sram") != -1 || _loc1_.indexOf("cra") != -1 || _loc1_.indexOf("osamodas") != -1 || _loc1_.indexOf("sacrieur") != -1 || _loc1_.indexOf("drop") != -1 || _loc1_.indexOf("mule") != -1)
         {
            this.sysApi.log(8,this._name + " contenant un mot interdit");
            return 2;
         }
         var _loc2_:Array = this._name.split("-");
         if(_loc2_.length > 2)
         {
            this.sysApi.log(8,this._name + " contenant plus d\'un tiret");
            return 3;
         }
         if(this._name.indexOf("-") == 0 || this._name.indexOf("-") == 1)
         {
            this.sysApi.log(8,this._name + " tiret placé en 1 ou 2");
            return 3;
         }
         if(_loc2_[0].charAt(0) != _loc2_[0].charAt(0).toUpperCase())
         {
            this.sysApi.log(8,this._name + " manque de majuscule");
            return 4;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(_loc3_.charAt(_loc5_) == _loc3_.charAt(_loc5_).toUpperCase())
               {
                  if(_loc5_ != 0)
                  {
                     this.sysApi.log(8,this._name + " majuscule en milieu de nom");
                     return 4;
                  }
               }
               _loc5_++;
            }
         }
         if(_loc1_.indexOf("a") == -1 && _loc1_.indexOf("e") == -1 && _loc1_.indexOf("i") == -1 && _loc1_.indexOf("o") == -1 && _loc1_.indexOf("u") == -1 && _loc1_.indexOf("y") == -1)
         {
            this.sysApi.log(8,this._name + " pas de voyelles");
            return 5;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._name.length - 2)
         {
            if(this._name.charAt(_loc4_) == this._name.charAt(_loc4_ + 1))
            {
               if(this._name.charAt(_loc4_) == this._name.charAt(_loc4_ + 2))
               {
                  this.sysApi.log(8,this._name + " plus de 2 lettres identiques à la suite");
                  return 6;
               }
            }
            _loc4_++;
         }
         return 0;
      }
      
      private function verifNameJa() : uint
      {
         if(this._name.length < 2)
         {
            this.sysApi.log(8,this._name + " trop court");
            return 1;
         }
         if(this._name.length > 19)
         {
            this.sysApi.log(8,this._name + " trop long");
            return 1;
         }
         return 0;
      }
      
      private function pickColor(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         this._selectedSlot = param1;
         if(this.uiApi.keyIsDown(16))
         {
            if(this._aColors[param1] != -1)
            {
               this.inp_hexaValue.text = this._aColors[param1].toString(16);
            }
            else
            {
               this.inp_hexaValue.text = "";
            }
            this.ctr_hexaColor.visible = true;
            this.inp_hexaValue.focus();
            _loc2_ = this.inp_hexaValue.text.length;
            this.inp_hexaValue.setSelection(_loc2_,_loc2_);
         }
         else
         {
            this.cp_colorPk.color = this._aColors[param1] == -1?uint(this._aColorsBase[param1]):uint(this._aColors[param1]);
            for(_loc3_ in this._aColorsBase)
            {
               if(this._aColors[_loc3_] == this._aColorsBase[_loc3_])
               {
                  this._aColors[_loc3_] = -1;
               }
            }
         }
      }
      
      private function updateDirection(param1:int) : void
      {
         var _loc2_:EntityDisplayer = null;
         if(param1 % 2 == 0 && this.ed_chara.animation == "AnimAttaque0")
         {
            this._direction = (param1 + 1) % 8;
         }
         else
         {
            this._direction = param1;
         }
         this.ed_chara.direction = this._direction;
         for each(_loc2_ in this._randomColorEntityDisplayers)
         {
            _loc2_.direction = this._direction;
         }
      }
      
      private function updateRandomColorLook() : void
      {
         this._aColors = this._randomLookColors[this._randomColorPage][0].concat();
         var _loc1_:int = 0;
         while(_loc1_ < this._aTx_color.length)
         {
            this.changeColor(this._aTx_color[_loc1_],this._aColors[_loc1_]);
            _loc1_++;
         }
         this.colorizeCharacter();
      }
      
      private function displayEquipment(param1:String = "") : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this._equipmentSkinsStr == "")
         {
            if(param1 != "")
            {
               this.ed_chara.look = param1;
            }
            return;
         }
         var _loc2_:String = param1 != ""?param1:this.ed_chara.look.toString();
         var _loc3_:Array = _loc2_.split("|");
         if(this.btn_showEquipment.selected)
         {
            if(_loc3_[1].indexOf(this._equipmentSkinsStr) != -1)
            {
               return;
            }
            _loc2_ = _loc3_[0] + "|" + _loc3_[1] + "," + this._equipmentSkinsStr;
            _loc4_ = 2;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = _loc2_ + ("|" + _loc3_[_loc4_]);
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = _loc3_[1].toString().replace("," + this._equipmentSkinsStr,"");
            _loc2_ = _loc3_[0] + "|" + _loc5_;
            _loc4_ = 2;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = _loc2_ + ("|" + _loc3_[_loc4_]);
               _loc4_++;
            }
         }
         this.ed_chara.look = _loc2_;
      }
      
      public function lockCreation() : void
      {
         this.btn_next.disabled = true;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case this.ed_chara:
               break;
            case this.btn_generateName:
               if(!this._bRequestCreation)
               {
                  this.sysApi.sendAction(new CharacterNameSuggestionRequest());
               }
               break;
            case this.btn_generateColor:
               if(this._randomLookColors.length < 100)
               {
                  this.generateColors();
               }
               else
               {
                  this.changeRandomPage(0);
               }
               if(this._aColors[this._selectedSlot] != -1)
               {
                  this.cp_colorPk.color = this._aColors[this._selectedSlot];
               }
               break;
            case this.btn_reinitColor:
               this.resetColor();
               if(this._aColors[this._selectedSlot] != -1)
               {
                  this.cp_colorPk.color = this._aColors[this._selectedSlot];
               }
               break;
            case this.btn_leftArrow:
               this.wheelChara(1);
               break;
            case this.btn_rightArrow:
               this.wheelChara(-1);
               break;
            case this.btn_breedSex0:
            case this.btn_customSex0:
               if(this._gender != 0)
               {
                  this._direction = 3;
                  this.updateGender(0,true);
               }
               break;
            case this.btn_breedSex1:
            case this.btn_customSex1:
               if(this._gender != 1)
               {
                  this._direction = 3;
                  this.updateGender(1,true);
               }
               break;
            case this.btn_closeVideo:
               this.ctr_videoPlayerFull.visible = false;
               this.videoPlayerSmall.resume();
               this.videoPlayerFull.pause();
               this.soundApi.fadeBusVolume(0,1,0);
               break;
            case this.videoPlayerSmall:
               this.videoPlayerSmall.pause();
               this.videoPlayerFull.play();
               this.ctr_videoPlayerFull.visible = true;
               this.soundApi.fadeBusVolume(0,0,0);
               break;
            case this.videoPlayerFull:
               if(this._videoIsPlaying)
               {
                  this.videoPlayerFull.pause();
               }
               else
               {
                  this.videoPlayerFull.resume();
               }
               this._videoIsPlaying = !this._videoIsPlaying;
               break;
            case this.btn_color0:
               this.pickColor(0);
               break;
            case this.btn_color1:
               this.pickColor(1);
               break;
            case this.btn_color2:
               this.pickColor(2);
               break;
            case this.btn_color3:
               this.pickColor(3);
               break;
            case this.btn_color4:
               this.pickColor(4);
               break;
            case this.btn_reinitColor0:
               this.resetColor(0);
               break;
            case this.btn_reinitColor1:
               this.resetColor(1);
               break;
            case this.btn_reinitColor2:
               this.resetColor(2);
               break;
            case this.btn_reinitColor3:
               this.resetColor(3);
               break;
            case this.btn_reinitColor4:
               this.resetColor(4);
               break;
            case this.btn_hexaOk:
               _loc2_ = int(Number("0x" + this.inp_hexaValue.text));
               this.onColorChange(new Object(),_loc2_);
               this.cp_colorPk.color = _loc2_;
               break;
            case this.btn_breedInfo:
               this.ctr_breedInfos.visible = !this.ctr_breedInfos.visible;
               break;
            case this.btn_close_ctr_breedInfos:
               this.texta_breedInfo.visible = true;
               this.gd_spells.visible = true;
               this.ctr_breedInfos.visible = false;
               this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
               break;
            case this.btn_previous:
               this.soundApi.fadeBusVolume(0,1,0);
               if(this._currentPage == 1)
               {
                  this.displayPage(0);
               }
               else
               {
                  this.sysApi.sendAction(new CharacterDeselection());
                  Connection.getInstance().openPreviousUi();
               }
               break;
            case this.btn_next:
               this.soundApi.fadeBusVolume(0,1,0);
               if(this._currentPage == 0)
               {
                  this.displayPage(1);
               }
               else if(!this._bRequestCreation)
               {
                  this._bRequestCreation = true;
                  this.createCharacter();
               }
               break;
            case this.btn_showEquipment:
               this.displayEquipment();
               this.onRollOver(param1);
               break;
            case this.btn_left:
               this._breedIndex = Math.max(this._breedIndex - 1,0);
               this.gd_breed.selectedIndex = this._breedIndex;
               break;
            case this.btn_right:
               this._breedIndex = Math.min(this._breedIndex + 1,this.gd_breed.dataProvider.length - 1);
               this.gd_breed.selectedIndex = this._breedIndex;
               break;
            case this.input_name:
               if(this.uiApi.getText("ui.charcrea.titleRename") == this.input_name.text)
               {
                  this.input_name.text = "";
               }
         }
         if(param1 != this.input_name && this.input_name && this.input_name.text.length == 0)
         {
            this.input_name.text = this.uiApi.getText("ui.charcrea.titleRename");
         }
      }
      
      public function onFocusChange(param1:Object) : void
      {
         if(param1 && param1 != this.input_name && this.input_name.text.length <= 0)
         {
            this.input_name.text = this.uiApi.getText("ui.charcrea.titleRename");
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_leftArrow:
               this.wheelChara(1);
               break;
            case this.btn_rightArrow:
               this.wheelChara(-1);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(param2 != GridItemSelectMethodEnum.AUTO)
         {
            if(param1 == this.gd_breed)
            {
               this._breedIndex = this.gd_breed.selectedIndex;
               this._direction = 3;
               _loc6_ = this._aBreeds[this._breedIndex];
               if(!_loc6_)
               {
                  return;
               }
               _loc4_ = _loc6_.id;
               if(this._activeModules.indexOf(TYPE_CREATE) == -1 || Connection.BREEDS_AVAILABLE > 0 && (Math.pow(2,_loc4_ - 1) & Connection.BREEDS_AVAILABLE) > 0)
               {
                  if(_loc4_)
                  {
                     this._breed = _loc4_;
                     this.displayBreed();
                  }
               }
               else
               {
                  _loc5_ = "ui.charcrea.breedNotAvailable";
                  if(_loc4_ == 12 || _loc4_ == 13 || _loc4_ == 14)
                  {
                     _loc5_ = _loc5_ + ("." + _loc4_);
                  }
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText(_loc5_),[this.uiApi.getText("ui.common.ok")],null,null,null,null,false,true);
                  this.gd_breed.selectedIndex = 0;
               }
            }
            else if(param1 == this.gd_heads)
            {
               this._head = this.gd_heads.selectedItem.id;
               this.displayCharacter();
            }
         }
      }
      
      public function onEntityReady(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(!this._randomInitialized)
         {
            _loc2_ = 0;
            while(_loc2_ < this._randomColorEntityDisplayers.length)
            {
               this._randomColorEntityDisplayers[_loc2_].direction = this._direction;
               this._randomColorEntityDisplayers[_loc2_].look = this.ed_chara.look;
               _loc2_++;
            }
            this._randomInitialized = true;
         }
         else if(this._activeModules.indexOf(TYPE_RECOLOR) != -1)
         {
            this.colorizeCharacter();
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.uiApi.showTooltip(param2.data,param2.container,false,"standard",LocationEnum.POINT_BOTTOMRIGHT);
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Breed = null;
         switch(param1)
         {
            case this.tx_nameRules:
               _loc2_ = this.uiApi.getText("ui.charcrea.nameRules");
               break;
            case this.btn_generateColor:
               _loc2_ = this.uiApi.getText("ui.charcrea.generateColors");
               break;
            case this.btn_generateName:
               _loc2_ = this.uiApi.getText("ui.charcrea.generateName");
               break;
            case this.btn_breedSex0:
            case this.btn_customSex0:
               _loc2_ = this.uiApi.getText("ui.tooltip.male");
               break;
            case this.btn_breedSex1:
            case this.btn_customSex1:
               _loc2_ = this.uiApi.getText("ui.tooltip.female");
               break;
            case this.videoPlayerSmall:
               _loc2_ = this.uiApi.getText("ui.charcrea.enlargeYourVideo");
               break;
            case this.btn_color0:
               this._overSlot = 0;
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               break;
            case this.btn_color1:
               this._overSlot = 1;
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               break;
            case this.btn_color2:
               this._overSlot = 2;
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               break;
            case this.btn_color3:
               this._overSlot = 3;
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               break;
            case this.btn_color4:
               this._overSlot = 4;
               this.sysApi.addEventListener(this.onEnterFrame,"time");
               break;
            case this.btn_showEquipment:
               if(this.btn_showEquipment.selected)
               {
                  _loc2_ = this.uiApi.getText("ui.charcrea.hideStuff");
               }
               else if(this.btn_showEquipment.softDisabled)
               {
                  _loc2_ = this.uiApi.getText("ui.charcrea.cannotshowstuff");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.charcrea.showStuff");
               }
               break;
            default:
               if(param1.name.indexOf("btn_head") != -1)
               {
                  if(this._componentsList[param1.name])
                  {
                     _loc2_ = this.uiApi.getText("ui.charcrea.face") + " " + this._componentsList[param1.name].label;
                  }
               }
               if(param1.name.indexOf("ctr_breed") != -1)
               {
                  _loc3_ = this._componentsList[param1.name] as Breed;
                  if(_loc3_)
                  {
                     _loc2_ = "<b>" + _loc3_.shortName + "</b>" + this.uiApi.getText("ui.common.colon") + _loc3_.gameplayDescription;
                     if(Connection.BREEDS_AVAILABLE <= 0 || (Math.pow(2,_loc3_.id - 1) & Connection.BREEDS_AVAILABLE) <= 0 || _loc3_.id == this._initialBreed)
                     {
                        _loc2_ = _loc2_ + ("\n<i>" + this.uiApi.getText("ui.item.averageprice.unavailable") + "</i>");
                     }
                  }
               }
               else if(param1.name.indexOf("lbl_role") != -1)
               {
                  if(this._componentsList[param1.name])
                  {
                     _loc2_ = this._aRoles[this._componentsList[param1.name].id].description;
                  }
               }
               else if(param1.name.indexOf("btn_randomLook") != -1)
               {
                  if(this._componentsList[param1.name])
                  {
                     _loc2_ = this.uiApi.getText("ui.charcrea.clickCharToColor");
                  }
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onColorChange(param1:Object, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         if(!this.ctr_hexaColor.visible || param2 == -1)
         {
            _loc3_ = this.cp_colorPk.color;
         }
         else
         {
            _loc3_ = param2;
         }
         this.ctr_hexaColor.visible = false;
         var _loc4_:Object = this.uiApi.getRadioGroupSelectedItem("colorGroup",this.uiApi.me());
         switch(_loc4_.name)
         {
            case this.btn_color0.name:
               this._aColors[0] = _loc3_;
               this.changeColor(this.tx_color0,_loc3_);
               break;
            case this.btn_color1.name:
               this._aColors[1] = _loc3_;
               this.changeColor(this.tx_color1,_loc3_);
               break;
            case this.btn_color2.name:
               this._aColors[2] = _loc3_;
               this.changeColor(this.tx_color2,_loc3_);
               break;
            case this.btn_color3.name:
               this._aColors[3] = _loc3_;
               this.changeColor(this.tx_color3,_loc3_);
               break;
            case this.btn_color4.name:
               this._aColors[4] = _loc3_;
               this.changeColor(this.tx_color4,_loc3_);
         }
         this.colorizeCharacter();
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
         this.sysApi.removeEventListener(this.onEnterFrame);
         if(param1 == this.btn_color0 || param1 == this.btn_color1 || param1 == this.btn_color2 || param1 == this.btn_color3 || param1 == this.btn_color4)
         {
            if(this._aColors[this._overSlot] != -1)
            {
               this.ed_chara.setColor(this._overSlot + 1,this._aColors[this._overSlot]);
            }
            else
            {
               this.ed_chara.setColor(this._overSlot + 1,this._aColorsBase[this._overSlot]);
            }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case "validUi":
               if(this.ctr_hexaColor.visible)
               {
                  _loc2_ = int(Number("0x" + this.inp_hexaValue.text));
                  this.onColorChange(new Object(),_loc2_);
                  this.cp_colorPk.color = _loc2_;
               }
               else if(!this._bRequestCreation && this._currentPage == 1)
               {
                  this._bRequestCreation = true;
                  this.createCharacter();
               }
               return true;
            case "closeUi":
               if(this.ctr_hexaColor.visible)
               {
                  this.ctr_hexaColor.visible = false;
                  return true;
               }
            default:
               return false;
         }
      }
      
      public function onCharacterCreationResult(param1:int) : void
      {
         if(param1 > 0)
         {
            switch(param1)
            {
               case CharacterCreationResultEnum.ERR_INVALID_NAME:
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.invalidName"),[this.uiApi.getText("ui.common.ok")]);
                  break;
               case CharacterCreationResultEnum.ERR_NAME_ALREADY_EXISTS:
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.nameAlreadyExist"),[this.uiApi.getText("ui.common.ok")]);
                  this.sysApi.log(16,"Ce nom existe deja.");
                  break;
               case CharacterCreationResultEnum.ERR_NOT_ALLOWED:
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.notSubscriber"),[this.uiApi.getText("ui.common.ok")]);
                  this.sysApi.log(16,"Seuls les abonnés peuvent jouer cette classe de personnage.");
                  break;
               case CharacterCreationResultEnum.ERR_TOO_MANY_CHARACTERS:
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.tooManyCharacters"),[this.uiApi.getText("ui.common.ok")]);
                  this.sysApi.log(16,"Vous avez deja trop de personnages");
                  break;
               case CharacterCreationResultEnum.ERR_NO_REASON:
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.popup.charcrea.noReason"),[this.uiApi.getText("ui.common.ok")]);
                  this.sysApi.log(16,"Echec sans raison");
                  break;
               case CharacterCreationResultEnum.ERR_RESTRICED_ZONE:
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.charSel.deletionErrorUnsecureMode"),[this.uiApi.getText("ui.common.ok")]);
                  this.sysApi.log(16,"Vous ne pouvez pas créer de personnage en mode Unsecure");
            }
         }
         else
         {
            this.soundApi.playLookSound(this._currentLook,LookTypeSoundEnum.CHARACTER_SELECTION);
            Connection.TUTORIAL_SELECTION = true;
         }
         this._bRequestCreation = false;
         this.btn_next.disabled = false;
         this.btn_generateName.disabled = false;
      }
      
      public function onCharacterImpossibleSelection(param1:Number) : void
      {
         this._bRequestCreation = false;
         this.btn_next.disabled = false;
         this.btn_generateName.disabled = false;
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.impossible_action"),this.uiApi.getText("ui.common.cantSelectThisCharacter"),[this.uiApi.getText("ui.common.ok")]);
      }
      
      public function onCharacterNameSuggestioned(param1:String) : void
      {
         this.input_name.text = param1;
      }
      
      public function onInput(param1:Object) : void
      {
         if(this._lang != "ru" && this._lang != "ja")
         {
            if(this.input_name.text.length == 1)
            {
               this.input_name.text = this.input_name.text.toLocaleUpperCase();
            }
         }
      }
      
      public function onChange(param1:Object) : void
      {
      }
      
      public function onEnterFrame() : void
      {
         this._frameCount++;
         if(this._frameCount > 4)
         {
            this.ed_chara.setColor(this._overSlot + 1,16759552);
            this._frameCount = 0;
         }
         else if(this._frameCount > 2)
         {
            this.ed_chara.setColor(this._overSlot + 1,16776960);
         }
      }
      
      private function getColorByXYSlideX(param1:Number, param2:Number, param3:Number) : uint
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc4_:uint = this.getGradientColor(param1,param2);
         var _loc5_:Number = 255 - param3 / 100 * 510;
         var _loc12_:uint = 0;
         _loc6_ = (_loc4_ & 16711680) >> 16;
         _loc7_ = (_loc4_ & 65280) >> 8;
         _loc8_ = _loc4_ & 255;
         if(_loc5_ >= 0)
         {
            _loc9_ = _loc5_ * (255 - _loc6_) / 255 + _loc6_;
            _loc10_ = _loc5_ * (255 - _loc7_) / 255 + _loc7_;
            _loc11_ = _loc5_ * (255 - _loc8_) / 255 + _loc8_;
         }
         else
         {
            _loc5_ = _loc5_ * -1;
            _loc9_ = Math.round(_loc6_ - _loc6_ * _loc5_ / 255);
            _loc10_ = Math.round(_loc7_ - _loc7_ * _loc5_ / 255);
            _loc11_ = Math.round(_loc8_ - _loc8_ * _loc5_ / 255);
         }
         _loc12_ = Math.round((_loc9_ << 16) + (_loc10_ << 8) + _loc11_);
         return _loc12_;
      }
      
      private function getGradientColor(param1:Number, param2:Number) : uint
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:Array = new Array(16711680,16776960,65280,65535,255,16711935,16711680);
         var _loc5_:Array = new Array(0,1 * 255 / 6,2 * 255 / 6,3 * 255 / 6,4 * 255 / 6,5 * 255 / 6,255);
         var _loc6_:Number = 1000;
         var _loc7_:Number = 1000;
         if(param1 >= _loc6_)
         {
            param1 = _loc6_ - 1;
         }
         _loc8_ = param1 / _loc6_;
         var _loc21_:Number = Math.floor(_loc8_ * (_loc5_.length - 1));
         _loc8_ = _loc8_ * 255;
         _loc9_ = 255 - (_loc5_[_loc21_ + 1] - _loc8_) / (_loc5_[_loc21_ + 1] - _loc5_[_loc21_]) * 255;
         _loc16_ = _loc4_[_loc21_];
         _loc17_ = _loc4_[_loc21_ + 1];
         _loc10_ = _loc16_ & 16711680;
         _loc11_ = _loc16_ & 65280;
         _loc12_ = _loc16_ & 255;
         _loc13_ = _loc17_ & 16711680;
         _loc14_ = _loc17_ & 65280;
         _loc15_ = _loc17_ & 255;
         if(_loc10_ != _loc13_)
         {
            _loc18_ = Math.round(_loc10_ > _loc13_?Number(255 - _loc9_):Number(_loc9_));
         }
         else
         {
            _loc18_ = _loc10_ >> 16;
         }
         if(_loc11_ != _loc14_)
         {
            _loc19_ = Math.round(_loc11_ > _loc14_?Number(255 - _loc9_):Number(_loc9_));
         }
         else
         {
            _loc19_ = _loc11_ >> 8;
         }
         if(_loc12_ != _loc15_)
         {
            _loc20_ = Math.round(_loc12_ > _loc15_?Number(255 - _loc9_):Number(_loc9_));
         }
         else
         {
            _loc20_ = _loc12_;
         }
         _loc8_ = param2 / _loc7_ * 255;
         _loc18_ = _loc18_ + (127 - _loc18_) * _loc8_ / 255;
         _loc19_ = _loc19_ + (127 - _loc19_) * _loc8_ / 255;
         _loc20_ = _loc20_ + (127 - _loc20_) * _loc8_ / 255;
         _loc3_ = Math.round((_loc18_ << 16) + (_loc19_ << 8) + _loc20_);
         return _loc3_;
      }
   }
}
