package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ColorPicker;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbolCategory;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.AllianceCreationValid;
   import d2actions.AllianceModificationEmblemValid;
   import d2actions.AllianceModificationNameAndTagValid;
   import d2actions.AllianceModificationValid;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.SocialGroupCreationResultEnum;
   import d2hooks.KeyUp;
   import d2hooks.LeaveDialog;
   import d2hooks.UiLoaded;
   
   public class AllianceCreator
   {
      
      public static const CREATION:uint = 0;
      
      public static const NAME_MODIFICATION:uint = 1;
      
      public static const EMBLEM_MODIFICATION:uint = 2;
      
      public static const MODIFICATION:uint = 3;
      
      public static const EMBLEM_TAB_ICON:uint = 0;
      
      public static const EMBLEM_TAB_BACKGROUND:uint = 1;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      private var _mode:uint = 0;
      
      private var _nCurrentTab:int = -1;
      
      private var _emblemList:Object;
      
      private var _background:Object;
      
      private var _backgroundIdx:uint;
      
      private var _backgroundColor:uint;
      
      private var _icon:EmblemWrapper;
      
      private var _iconIdx:uint;
      
      private var _iconColor:uint;
      
      private var _stickEmblem:Boolean = false;
      
      private var _iconCategories:Array;
      
      private var _currentIconCat:Object;
      
      private var _emblemsHash:String;
      
      public var tx_emblem:Texture;
      
      public var tx_icon:Texture;
      
      public var bgcbb_emblemCategory:TextureBitmap;
      
      public var tx_nameRules:ButtonContainer;
      
      public var tx_tagRules:ButtonContainer;
      
      public var inp_alliancename:Input;
      
      public var inp_alliancetag:Input;
      
      public var gd_emblemBack:Grid;
      
      public var gd_emblemFront:Grid;
      
      public var cbb_emblemCategory:ComboBox;
      
      public var cp_colorPk:ColorPicker;
      
      public var btn_create:ButtonContainer;
      
      public var btn_background:ButtonContainer;
      
      public var btn_icon:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var allianceNameCtr:GraphicContainer;
      
      public var emblemCreatorCtr:GraphicContainer;
      
      public var ctr_hexaColor:GraphicContainer;
      
      public var inp_hexaValue:Input;
      
      public var btn_hexaOk:ButtonContainer;
      
      public function AllianceCreator()
      {
         this._iconCategories = new Array();
         super();
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
      
      public function set mode(param1:uint) : void
      {
         this._mode = param1;
         this.refreshUIMode();
      }
      
      public function main(... rest) : void
      {
         var _loc4_:EmblemSymbolCategory = null;
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         this.sysApi.addHook(d2hooks.LeaveDialog,this.onLeaveDialog);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addComponentHook(this.tx_emblem,"onTextureReady");
         this.uiApi.addComponentHook(this.gd_emblemBack,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_emblemFront,"onSelectItem");
         this.uiApi.addComponentHook(this.cbb_emblemCategory,"onSelectItem");
         this.uiApi.addComponentHook(this.cp_colorPk,"onColorChange");
         this.uiApi.addComponentHook(this.cp_colorPk,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_create,"onRelease");
         this.uiApi.addComponentHook(this.btn_background,"onRelease");
         this.uiApi.addComponentHook(this.btn_icon,"onRelease");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.tx_nameRules,"onRollOver");
         this.uiApi.addComponentHook(this.tx_nameRules,"onRollOut");
         this.uiApi.addComponentHook(this.tx_tagRules,"onRollOver");
         this.uiApi.addComponentHook(this.tx_tagRules,"onRollOut");
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.ctr_hexaColor.visible = false;
         if(rest[0][0])
         {
            if(rest[0][1])
            {
               this._mode = MODIFICATION;
            }
            else
            {
               this._mode = NAME_MODIFICATION;
            }
         }
         else if(rest[0][1])
         {
            this._mode = EMBLEM_MODIFICATION;
         }
         else
         {
            this._mode = CREATION;
         }
         this.gd_emblemBack.visible = true;
         this.gd_emblemBack.disabled = false;
         this.gd_emblemFront.visible = false;
         this.tx_emblem.dispatchMessages = true;
         this._emblemList = this.dataApi.getEmblems();
         this.inp_alliancename.maxChars = 30;
         this.inp_alliancetag.maxChars = 5;
         var _loc2_:Object = this.dataApi.getAllEmblemSymbolCategories();
         var _loc3_:int = this.socialApi.getAllowedGuildEmblemSymbolCategories();
         for each(_loc4_ in _loc2_)
         {
            if(_loc3_ & Math.pow(2,_loc4_.id - 1))
            {
               this._iconCategories.push({
                  "label":_loc4_.name,
                  "value":_loc4_.id
               });
            }
         }
         this.cbb_emblemCategory.dataProvider = this._iconCategories;
         this._currentIconCat = this._iconCategories[0];
      }
      
      public function unload() : void
      {
      }
      
      public function selectBackground(param1:Object, param2:Boolean) : void
      {
         if(param1 != null)
         {
            if(param2 && this._nCurrentTab == EMBLEM_TAB_BACKGROUND)
            {
               this.gd_emblemBack.selectedItem = param1;
            }
            this._background = param1;
            this.tx_emblem.uri = this.uiApi.createUri(this.uiApi.me().getConstant("picto_uri") + "backalliance/" + param1.iconUri.fileName.split(".")[0] + ".swf");
         }
      }
      
      public function selectIcon(param1:EmblemWrapper, param2:Boolean) : void
      {
         var _loc3_:EmblemSymbol = null;
         if(param1 != null)
         {
            if(param2 && this._nCurrentTab == EMBLEM_TAB_ICON)
            {
               this.gd_emblemFront.selectedItem = param1;
            }
            this._icon = param1;
            this.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("picto_uri") + "up/" + param1.iconUri.fileName.split(".")[0] + ".swf");
            _loc3_ = this.dataApi.getEmblemSymbol(this._icon.idEmblem);
            if(_loc3_.colorizable)
            {
               this.utilApi.changeColor(this.tx_icon,this._iconColor,0);
            }
            else
            {
               this.utilApi.changeColor(this.tx_icon,this._iconColor,0,true);
            }
         }
      }
      
      public function getCurrentTab() : int
      {
         return this._nCurrentTab;
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(param2 == 9)
         {
            if(this.inp_alliancename.haveFocus)
            {
               this.inp_alliancetag.focus();
               this.inp_alliancetag.setSelection(0,this.inp_alliancetag.text.length);
            }
            else if(this.inp_alliancetag.haveFocus)
            {
               this.inp_alliancename.focus();
               this.inp_alliancename.setSelection(0,this.inp_alliancename.text.length);
            }
         }
      }
      
      private function refreshUIMode() : void
      {
         switch(this._mode)
         {
            case CREATION:
               this.allianceNameCtr.disabled = false;
               this.emblemCreatorCtr.disabled = false;
               this.btn_background.selected = true;
               this.randomEmblem();
               break;
            case NAME_MODIFICATION:
               this.allianceNameCtr.disabled = false;
               this.emblemCreatorCtr.disabled = true;
               break;
            case EMBLEM_MODIFICATION:
               this.allianceNameCtr.disabled = true;
               this.emblemCreatorCtr.disabled = false;
               this.btn_background.selected = true;
               break;
            case MODIFICATION:
               this.allianceNameCtr.disabled = false;
               this.emblemCreatorCtr.disabled = false;
               this.btn_background.selected = true;
         }
         this.updateLogoFromPlayerAlliance();
         this.openSelectedTab(EMBLEM_TAB_BACKGROUND);
         this.uiApi.me().render();
      }
      
      private function updateLogoFromPlayerAlliance() : void
      {
         var _loc1_:AllianceWrapper = null;
         if(this.socialApi.hasAlliance())
         {
            _loc1_ = this.socialApi.getAlliance();
            if(!_loc1_)
            {
               return;
            }
            if(!this.socialApi.isAllianceNameInvalid())
            {
               this.inp_alliancename.text = _loc1_.allianceName;
            }
            if(!this.socialApi.isAllianceTagInvalid())
            {
               this.inp_alliancetag.text = _loc1_.allianceTag;
            }
            this._background = _loc1_.backEmblem;
            this.tx_emblem.uri = this._background.fullSizeIconUri;
            this._backgroundColor = this._background.color;
            this._icon = _loc1_.upEmblem;
            this.tx_icon.uri = this._icon.fullSizeIconUri;
            this._iconColor = this._icon.color;
            this.setIconColor(this._iconColor);
         }
      }
      
      private function randomEmblem() : void
      {
         var _loc1_:int = 0;
         _loc1_ = Math.floor(Math.random() * this._emblemList[EMBLEM_TAB_BACKGROUND].length);
         this.selectBackground(this._emblemList[EMBLEM_TAB_BACKGROUND][_loc1_],false);
         this.setBackgroundColor(Math.random() * 16777215);
         _loc1_ = Math.floor(Math.random() * this._emblemList[EMBLEM_TAB_ICON].length);
         this.selectIcon(this._emblemList[EMBLEM_TAB_ICON][_loc1_],false);
         this.setIconColor(Math.random() * 16777215);
      }
      
      private function openSelectedTab(param1:int) : void
      {
         var _loc2_:Object = null;
         if(this._nCurrentTab == param1)
         {
            return;
         }
         this._nCurrentTab = param1;
         this._stickEmblem = true;
         switch(param1)
         {
            case EMBLEM_TAB_ICON:
               if(this.gd_emblemFront.dataProvider.length == 0)
               {
                  if(this._icon)
                  {
                     for each(_loc2_ in this._iconCategories)
                     {
                        if(this._icon.category == _loc2_.value)
                        {
                           this._currentIconCat = _loc2_;
                           this.cbb_emblemCategory.selectedItem = this._currentIconCat;
                        }
                     }
                  }
                  this.updateIconGrid();
                  this.gd_emblemFront.selectedItem = this._icon;
               }
               this.gd_emblemBack.visible = false;
               this.gd_emblemFront.visible = true;
               this.cbb_emblemCategory.visible = this.bgcbb_emblemCategory.visible = true;
               this.cp_colorPk.color = this._iconColor;
               break;
            case EMBLEM_TAB_BACKGROUND:
               if(this.gd_emblemBack.dataProvider.length == 0)
               {
                  this.gd_emblemBack.dataProvider = this._emblemList[EMBLEM_TAB_BACKGROUND];
                  this.gd_emblemBack.selectedItem = this._background;
               }
               this.gd_emblemBack.visible = true;
               this.gd_emblemFront.visible = false;
               this.cbb_emblemCategory.visible = this.bgcbb_emblemCategory.visible = false;
               this.cp_colorPk.color = this._backgroundColor;
         }
         this._stickEmblem = false;
      }
      
      private function setBackgroundColor(param1:Number) : void
      {
         this._backgroundColor = param1;
         if(this.tx_emblem && this.tx_emblem.uri && this.tx_emblem.child && this.tx_emblem.child.hasOwnProperty("back") && Object(this.tx_emblem.child).back)
         {
            this.utilApi.changeColor(this.tx_emblem.getChildByName("back"),this._backgroundColor,1);
         }
      }
      
      private function setIconColor(param1:Number) : void
      {
         var _loc2_:EmblemSymbol = this.dataApi.getEmblemSymbol(this._icon.idEmblem);
         this._iconColor = param1;
         if(_loc2_.colorizable)
         {
            this.utilApi.changeColor(this.tx_icon,this._iconColor,0);
         }
         else
         {
            this.utilApi.changeColor(this.tx_icon,this._iconColor,0,true);
         }
      }
      
      private function unloadAllianceCreation() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      private function updateIconGrid() : void
      {
         var _loc3_:EmblemWrapper = null;
         var _loc1_:Array = new Array();
         var _loc2_:String = "";
         for each(_loc3_ in this._emblemList[EMBLEM_TAB_ICON])
         {
            if(_loc3_.category == this._currentIconCat.value || this._currentIconCat.value == uint.MAX_VALUE)
            {
               _loc1_.push(_loc3_);
               _loc2_ = _loc2_ + (_loc3_.idEmblem + "-");
            }
         }
         if(this._emblemsHash != _loc2_)
         {
            this.gd_emblemFront.dataProvider = _loc1_;
            this._emblemsHash = _loc2_;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         switch(param1)
         {
            case this.btn_close:
               this.sysApi.sendAction(new d2actions.LeaveDialog());
               this.unloadAllianceCreation();
               break;
            case this.btn_background:
               this.openSelectedTab(EMBLEM_TAB_BACKGROUND);
               break;
            case this.btn_icon:
               this.openSelectedTab(EMBLEM_TAB_ICON);
               this.setBackgroundColor(this._backgroundColor);
               break;
            case this.btn_hexaOk:
               _loc2_ = int(Number("0x" + this.inp_hexaValue.text));
               this.onColorChange(new Object(),_loc2_);
               this.cp_colorPk.color = _loc2_;
               break;
            case this.cp_colorPk:
               if(this.uiApi.keyIsDown(16))
               {
                  this.inp_hexaValue.text = this.cp_colorPk.color.toString(16);
                  this.ctr_hexaColor.visible = true;
                  this.inp_hexaValue.focus();
                  _loc3_ = this.inp_hexaValue.text.length;
                  this.inp_hexaValue.setSelection(_loc3_,_loc3_);
               }
               break;
            case this.btn_create:
               if(this._mode != EMBLEM_MODIFICATION && (this.inp_alliancename.text.length < ProtocolConstantsEnum.MIN_ALLIANCENAME_LEN || this.inp_alliancename.text.length > ProtocolConstantsEnum.MAX_ALLIANCENAME_LEN))
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.invalidLengthName",ProtocolConstantsEnum.MIN_ALLIANCENAME_LEN,ProtocolConstantsEnum.MAX_ALLIANCENAME_LEN),[this.uiApi.getText("ui.common.ok")]);
               }
               else if(this._mode != EMBLEM_MODIFICATION && (this.inp_alliancetag.text.length < ProtocolConstantsEnum.MIN_ALLIANCETAG_LEN || this.inp_alliancetag.text.length > ProtocolConstantsEnum.MAX_ALLIANCETAG_LEN))
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.invalidLengthTag",ProtocolConstantsEnum.MIN_ALLIANCETAG_LEN,ProtocolConstantsEnum.MAX_ALLIANCETAG_LEN),[this.uiApi.getText("ui.common.ok")]);
               }
               else if(this._mode == CREATION)
               {
                  this.sysApi.sendAction(new AllianceCreationValid(this.inp_alliancename.text,this.inp_alliancetag.text,this._icon.idEmblem,this._iconColor,this._background.idEmblem,this._backgroundColor));
               }
               else if(this._mode == NAME_MODIFICATION)
               {
                  this.sysApi.sendAction(new AllianceModificationNameAndTagValid(this.inp_alliancename.text,this.inp_alliancetag.text));
               }
               else if(this._mode == EMBLEM_MODIFICATION)
               {
                  this.sysApi.sendAction(new AllianceModificationEmblemValid(this._icon.idEmblem,this._iconColor,this._background.idEmblem,this._backgroundColor));
               }
               else if(this._mode == MODIFICATION)
               {
                  this.sysApi.sendAction(new AllianceModificationValid(this.inp_alliancename.text,this.inp_alliancetag.text,this._icon.idEmblem,this._iconColor,this._background.idEmblem,this._backgroundColor));
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.tx_nameRules)
         {
            _loc2_ = this.uiApi.getText("ui.social.nameRules");
         }
         else if(param1 == this.tx_tagRules)
         {
            _loc2_ = this.uiApi.getText("ui.alliance.tagRules");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",0,0,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onColorChange(param1:Object, param2:int = -1) : void
      {
         var _loc3_:Number = NaN;
         if(!this.ctr_hexaColor.visible)
         {
            _loc3_ = this.cp_colorPk.color;
         }
         else
         {
            _loc3_ = param2;
            this.ctr_hexaColor.visible = false;
         }
         switch(this._nCurrentTab)
         {
            case 0:
               if(!this._stickEmblem)
               {
                  this.setIconColor(_loc3_);
               }
               break;
            case 1:
               if(!this._stickEmblem)
               {
                  this.setBackgroundColor(_loc3_);
               }
         }
      }
      
      public function onAllianceCreationResult(param1:uint) : void
      {
         switch(param1)
         {
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_OK:
               this.unloadAllianceCreation();
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_NAME_ALREADY_EXISTS:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.AlreadyUseName"),[this.uiApi.getText("ui.common.ok")]);
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_NAME_INVALID:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.invalidName"),[this.uiApi.getText("ui.common.ok")]);
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_TAG_ALREADY_EXISTS:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.AlreadyUseName"),[this.uiApi.getText("ui.common.ok")]);
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_TAG_INVALID:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.invalidName"),[this.uiApi.getText("ui.common.ok")]);
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_EMBLEM_ALREADY_EXISTS:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.AlreadyUseEmblem"),[this.uiApi.getText("ui.common.ok")]);
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_CANCEL:
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_LEAVE:
               break;
            case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_REQUIREMENT_UNMET:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.alliance.requirementUnmet"),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.gd_emblemBack:
               if(param3 && !this._stickEmblem && param2 != SelectMethodEnum.AUTO)
               {
                  this.selectBackground(param1.selectedItem,false);
               }
               break;
            case this.gd_emblemFront:
               if(!this._stickEmblem && param2 != SelectMethodEnum.AUTO && (param3 || this.gd_emblemFront.dataProvider.length == 1))
               {
                  this.selectIcon(param1.selectedItem as EmblemWrapper,false);
               }
               break;
            case this.cbb_emblemCategory:
               if(param3)
               {
                  this._currentIconCat = this._iconCategories[this.cbb_emblemCategory.selectedIndex];
                  switch(param2)
                  {
                     case 0:
                     case 3:
                     case 4:
                     case 8:
                        this._stickEmblem = true;
                        this.updateIconGrid();
                        this._stickEmblem = false;
                  }
                  break;
               }
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_emblem:
               this.utilApi.changeColor(param1.getChildByName("back"),this._backgroundColor,1);
         }
      }
      
      public function onUiLoaded(param1:String) : void
      {
         if(param1 == "allianceCreator")
         {
            this.refreshUIMode();
         }
      }
      
      public function onLeaveDialog() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
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
               return true;
            case "closeUi":
               if(this.ctr_hexaColor.visible)
               {
                  this.ctr_hexaColor.visible = false;
               }
               else
               {
                  this.sysApi.sendAction(new d2actions.LeaveDialog());
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               return true;
            default:
               return false;
         }
      }
   }
}
