package ui
{
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import types.ConfigProperty;
   
   public class ConfigPerformance extends ConfigUi
   {
       
      
      public var bindsApi:BindsApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _lastSelectedIndex:int;
      
      private var qualitiesName:Array;
      
      private var qualityBtns:Array;
      
      private var pointsDisplayType:Array;
      
      private var _creatureLimits:Array;
      
      private var _auraChoices:Array;
      
      private var _infinityText:String;
      
      public var btn_left:ButtonContainer;
      
      public var btn_right:ButtonContainer;
      
      public var btn_quality0:ButtonContainer;
      
      public var btn_quality1:ButtonContainer;
      
      public var btn_quality2:ButtonContainer;
      
      public var btn_quality3:ButtonContainer;
      
      public var btn_showAllMonsters:ButtonContainer;
      
      public var btn_allowAnimsFun:ButtonContainer;
      
      public var btn_allowUiShadows:ButtonContainer;
      
      public var btn_allowUiAnimations:ButtonContainer;
      
      public var btn_allowAnimatedGfx:ButtonContainer;
      
      public var btn_allowParticlesFx:ButtonContainer;
      
      public var btn_allowSpellEffects:ButtonContainer;
      
      public var btn_allowHitAnim:ButtonContainer;
      
      public var btn_optimizeMultiAccount:ButtonContainer;
      
      public var btn_fullScreen:ButtonContainer;
      
      public var btn_useLDSkin:ButtonContainer;
      
      public var cb_creatures:ComboBox;
      
      public var cb_flashQuality:ComboBox;
      
      public var cb_auras:ComboBox;
      
      public var cb_pointsOverHead:ComboBox;
      
      public var btn_groundCacheEnabled:ButtonContainer;
      
      public var btn_groundCacheQuality1:ButtonContainer;
      
      public var btn_groundCacheQuality2:ButtonContainer;
      
      public var btn_groundCacheQuality3:ButtonContainer;
      
      public var lbl_diskUsed:Label;
      
      public var btn_clearGroundCache:ButtonContainer;
      
      public var lbl_showPointsOverhead:Label;
      
      public var btn_showTurnPicture:ButtonContainer;
      
      public var btn_showAuraOnFront:ButtonContainer;
      
      public function ConfigPerformance()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         this.btn_left.soundId = SoundEnum.SCROLL_DOWN;
         this.btn_right.soundId = SoundEnum.SCROLL_UP;
         this.btn_quality0.soundId = SoundEnum.SPEC_BUTTON;
         this.btn_quality1.soundId = SoundEnum.SPEC_BUTTON;
         this.btn_quality2.soundId = SoundEnum.SPEC_BUTTON;
         this.btn_quality3.soundId = SoundEnum.SPEC_BUTTON;
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("cb_flashQuality","flashQuality","dofus"));
         _loc2_.push(new ConfigProperty("cb_creatures","creaturesMode","tiphon"));
         _loc2_.push(new ConfigProperty("btn_showAllMonsters","showEveryMonsters","dofus"));
         _loc2_.push(new ConfigProperty("btn_allowAnimsFun","allowAnimsFun","dofus"));
         _loc2_.push(new ConfigProperty("btn_allowUiShadows","uiShadows","berilia"));
         _loc2_.push(new ConfigProperty("btn_allowUiAnimations","uiAnimations","berilia"));
         _loc2_.push(new ConfigProperty("btn_allowAnimatedGfx","allowAnimatedGfx","atouin"));
         _loc2_.push(new ConfigProperty("btn_allowParticlesFx","allowParticlesFx","atouin"));
         _loc2_.push(new ConfigProperty("btn_allowSpellEffects","allowSpellEffects","dofus"));
         _loc2_.push(new ConfigProperty("btn_allowHitAnim","allowHitAnim","dofus"));
         _loc2_.push(new ConfigProperty("","dofusQuality","dofus"));
         _loc2_.push(new ConfigProperty("btn_groundCacheEnabled","groundCacheMode","atouin"));
         _loc2_.push(new ConfigProperty("btn_showPointsOverhead","pointsOverhead","tiphon"));
         _loc2_.push(new ConfigProperty("btn_showTurnPicture","turnPicture","dofus"));
         _loc2_.push(new ConfigProperty("cb_auras","auraMode","tiphon"));
         _loc2_.push(new ConfigProperty("btn_showAuraOnFront","alwaysShowAuraOnFront","tiphon"));
         _loc2_.push(new ConfigProperty("btn_optimizeMultiAccount","optimizeMultiAccount","dofus"));
         _loc2_.push(new ConfigProperty("btn_fullScreen","fullScreen","dofus"));
         _loc2_.push(new ConfigProperty("btn_useLDSkin","useLowDefSkin","atouin"));
         init(_loc2_);
         uiApi.addComponentHook(this.btn_quality0,"onRelease");
         uiApi.addComponentHook(this.btn_quality0,"onRollOver");
         uiApi.addComponentHook(this.btn_quality0,"onRollOut");
         uiApi.addComponentHook(this.btn_quality0,"onMouseUp");
         uiApi.addComponentHook(this.btn_quality1,"onRelease");
         uiApi.addComponentHook(this.btn_quality1,"onRollOver");
         uiApi.addComponentHook(this.btn_quality1,"onRollOut");
         uiApi.addComponentHook(this.btn_quality1,"onMouseUp");
         uiApi.addComponentHook(this.btn_quality2,"onRelease");
         uiApi.addComponentHook(this.btn_quality2,"onRollOver");
         uiApi.addComponentHook(this.btn_quality2,"onRollOut");
         uiApi.addComponentHook(this.btn_quality2,"onMouseUp");
         uiApi.addComponentHook(this.btn_quality3,"onRelease");
         uiApi.addComponentHook(this.btn_quality3,"onRollOver");
         uiApi.addComponentHook(this.btn_quality3,"onRollOut");
         uiApi.addComponentHook(this.btn_quality3,"onMouseUp");
         uiApi.addComponentHook(this.btn_groundCacheEnabled,"onRollOver");
         uiApi.addComponentHook(this.btn_groundCacheEnabled,"onRollOut");
         uiApi.addComponentHook(this.btn_groundCacheQuality1,"onRollOver");
         uiApi.addComponentHook(this.btn_groundCacheQuality1,"onRollOut");
         uiApi.addComponentHook(this.btn_groundCacheQuality2,"onRollOver");
         uiApi.addComponentHook(this.btn_groundCacheQuality2,"onRollOut");
         uiApi.addComponentHook(this.btn_groundCacheQuality3,"onRollOver");
         uiApi.addComponentHook(this.btn_groundCacheQuality3,"onRollOut");
         uiApi.addComponentHook(this.btn_left,"onRelease");
         uiApi.addComponentHook(this.btn_right,"onRelease");
         uiApi.addComponentHook(this.btn_showAllMonsters,"onRelease");
         uiApi.addComponentHook(this.btn_allowAnimsFun,"onRelease");
         uiApi.addComponentHook(this.btn_allowUiShadows,"onRelease");
         uiApi.addComponentHook(this.btn_allowUiAnimations,"onRelease");
         uiApi.addComponentHook(this.btn_allowAnimatedGfx,"onRelease");
         uiApi.addComponentHook(this.btn_allowParticlesFx,"onRelease");
         uiApi.addComponentHook(this.btn_allowSpellEffects,"onRelease");
         uiApi.addComponentHook(this.btn_allowHitAnim,"onRelease");
         uiApi.addComponentHook(this.btn_groundCacheEnabled,"onRelease");
         uiApi.addComponentHook(this.btn_groundCacheQuality1,"onRelease");
         uiApi.addComponentHook(this.btn_groundCacheQuality2,"onRelease");
         uiApi.addComponentHook(this.btn_groundCacheQuality3,"onRelease");
         uiApi.addComponentHook(this.lbl_showPointsOverhead,"onRollOver");
         uiApi.addComponentHook(this.lbl_showPointsOverhead,"onRollOut");
         uiApi.addComponentHook(this.btn_showAllMonsters,"onRollOver");
         uiApi.addComponentHook(this.btn_showAllMonsters,"onRollOut");
         uiApi.addComponentHook(this.btn_showAuraOnFront,"onRollOver");
         uiApi.addComponentHook(this.btn_showAuraOnFront,"onRollOut");
         uiApi.addComponentHook(this.btn_showTurnPicture,"onRelease");
         uiApi.addComponentHook(this.btn_showTurnPicture,"onRollOver");
         uiApi.addComponentHook(this.btn_showTurnPicture,"onRollOut");
         uiApi.addComponentHook(this.btn_optimizeMultiAccount,"onRelease");
         uiApi.addComponentHook(this.btn_optimizeMultiAccount,"onRollOver");
         uiApi.addComponentHook(this.btn_optimizeMultiAccount,"onRollOut");
         uiApi.addComponentHook(this.btn_fullScreen,"onRelease");
         uiApi.addComponentHook(this.btn_useLDSkin,"onRelease");
         this._infinityText = uiApi.getText("ui.common.infinit");
         this.qualityBtns = [this.btn_quality0,this.btn_quality1,this.btn_quality2,this.btn_quality3];
         this.qualitiesName = new Array(uiApi.getText("ui.common.none"),"2x","4x");
         this.cb_flashQuality.dataProvider = this.qualitiesName;
         this.cb_flashQuality.value = !!sysApi.setQualityIsEnable()?this.qualitiesName[sysApi.getOption("flashQuality","dofus")]:this.qualitiesName[2];
         this.cb_flashQuality.disabled = !sysApi.setQualityIsEnable();
         this.cb_flashQuality.dataNameField = "";
         this._creatureLimits = ["0","10","20","40",this._infinityText];
         this.cb_creatures.dataProvider = this._creatureLimits;
         var _loc3_:int = this._creatureLimits.indexOf(sysApi.getOption("creaturesMode","tiphon").toString());
         if(_loc3_ == -1)
         {
            _loc3_ = 4;
         }
         this.cb_creatures.value = this._creatureLimits[_loc3_];
         this.cb_creatures.dataNameField = "";
         this._auraChoices = [uiApi.getText("ui.option.aura.none"),uiApi.getText("ui.option.aura.rollover"),uiApi.getText("ui.option.aura.cycle"),uiApi.getText("ui.option.aura.all")];
         this.cb_auras.dataProvider = this._auraChoices;
         _loc3_ = sysApi.getOption("auraMode","tiphon");
         this.cb_auras.value = this._auraChoices[_loc3_];
         this.cb_auras.dataNameField = "";
         this.pointsDisplayType = [uiApi.getText("ui.option.pointsOverHead.none"),uiApi.getText("ui.option.pointsOverHead.normal"),uiApi.getText("ui.option.pointsOverHead.cartoon")];
         this.cb_pointsOverHead.dataProvider = this.pointsDisplayType;
         var _loc4_:uint = sysApi.getOption("pointsOverhead","tiphon");
         this.cb_pointsOverHead.value = this.pointsDisplayType[_loc4_];
         this.cb_pointsOverHead.dataNameField = "";
         var _loc5_:uint = sysApi.getOption("dofusQuality","dofus");
         this.qualityBtns[_loc5_].selected = true;
         this.selectQualityMode(_loc5_);
         var _loc6_:int = sysApi.getOption("groundCacheMode","atouin");
         this.updateGroundCacheOption(_loc6_);
         var _loc7_:Number = sysApi.getGroundCacheSize();
         _loc7_ = _loc7_ / 1048576;
         this.lbl_diskUsed.text = uiApi.getText("ui.option.performance.groundCacheSize",int(_loc7_ * 100) / 100);
         if(sysApi.isStreaming())
         {
            setProperty("dofus","fullScreen",uiApi.isFullScreen());
         }
      }
      
      override public function reset() : void
      {
         super.reset();
         this.selectQualityMode(1);
         this.btn_quality1.selected = true;
      }
      
      private function updateGroundCacheOption(param1:int) : void
      {
         this.btn_groundCacheQuality1.selected = false;
         this.btn_groundCacheQuality2.selected = false;
         this.btn_groundCacheQuality3.selected = false;
         if(param1 == 0)
         {
            this.btn_groundCacheEnabled.selected = false;
            this.btn_groundCacheQuality1.disabled = true;
            this.btn_groundCacheQuality2.disabled = true;
            this.btn_groundCacheQuality3.disabled = true;
         }
         else
         {
            this.btn_groundCacheEnabled.selected = true;
            this.btn_groundCacheQuality1.disabled = false;
            this.btn_groundCacheQuality2.disabled = false;
            this.btn_groundCacheQuality3.disabled = false;
            this["btn_groundCacheQuality" + param1].selected = true;
         }
      }
      
      private function selectQualityMode(param1:uint) : void
      {
         if(param1 == 0)
         {
            if(sysApi.setQualityIsEnable())
            {
               this.cb_flashQuality.value = this.qualitiesName[0];
            }
            this.cb_creatures.value = this._creatureLimits[1];
            setProperty("dofus","showEveryMonsters",false);
            setProperty("dofus","allowAnimsFun",false);
            setProperty("atouin","useLowDefSkin",true);
            this.cb_auras.value = this._auraChoices[0];
            setProperty("tiphon","alwaysShowAuraOnFront",false);
            setProperty("berilia","uiShadows",false);
            setProperty("berilia","uiAnimations",false);
            setProperty("tubul","allowSoundEffects",false);
            this.cb_pointsOverHead.value = this.pointsDisplayType[1];
            setProperty("dofus","turnPicture",false);
            setProperty("dofus","allowSpellEffects",sysApi.setQualityIsEnable());
            setProperty("dofus","allowHitAnim",sysApi.setQualityIsEnable());
            configApi.setConfigProperty("dofus","cacheMapEnabled",false);
            setProperty("atouin","allowAnimatedGfx",false);
            setProperty("atouin","allowParticlesFx",false);
            setProperty("atouin","groundCacheMode",3);
            this.updateGroundCacheOption(3);
         }
         else if(param1 == 1)
         {
            if(sysApi.setQualityIsEnable())
            {
               this.cb_flashQuality.value = this.qualitiesName[1];
            }
            this.cb_creatures.value = this._creatureLimits[2];
            setProperty("atouin","useLowDefSkin",true);
            setProperty("dofus","showEveryMonsters",false);
            setProperty("dofus","allowAnimsFun",false);
            this.cb_auras.value = this._auraChoices[2];
            setProperty("tiphon","alwaysShowAuraOnFront",false);
            setProperty("berilia","uiShadows",false);
            setProperty("berilia","uiAnimations",true);
            setProperty("tubul","allowSoundEffects",true);
            this.cb_pointsOverHead.value = this.pointsDisplayType[1];
            setProperty("dofus","turnPicture",true);
            setProperty("dofus","allowSpellEffects",true);
            setProperty("dofus","allowHitAnim",true);
            configApi.setConfigProperty("dofus","cacheMapEnabled",true);
            setProperty("atouin","allowAnimatedGfx",false);
            setProperty("atouin","allowParticlesFx",true);
            setProperty("atouin","groundCacheMode",1);
            this.updateGroundCacheOption(1);
         }
         else if(param1 == 2)
         {
            if(sysApi.setQualityIsEnable())
            {
               this.cb_flashQuality.value = this.qualitiesName[2];
            }
            this.cb_creatures.value = this._creatureLimits[4];
            setProperty("atouin","useLowDefSkin",false);
            setProperty("dofus","showEveryMonsters",true);
            setProperty("dofus","allowAnimsFun",true);
            this.cb_auras.value = this._auraChoices[3];
            setProperty("tiphon","alwaysShowAuraOnFront",true);
            setProperty("berilia","uiShadows",true);
            setProperty("berilia","uiAnimations",true);
            setProperty("tubul","allowSoundEffects",true);
            this.cb_pointsOverHead.value = this.pointsDisplayType[1];
            setProperty("dofus","turnPicture",true);
            setProperty("dofus","allowSpellEffects",true);
            setProperty("dofus","allowHitAnim",true);
            configApi.setConfigProperty("dofus","cacheMapEnabled",true);
            setProperty("atouin","allowAnimatedGfx",true);
            setProperty("atouin","allowParticlesFx",true);
            setProperty("atouin","groundCacheMode",1);
            this.updateGroundCacheOption(1);
         }
         setProperty("dofus","dofusQuality",param1);
      }
      
      private function onConfirmClearGroundCache() : void
      {
         sysApi.clearGroundCache();
         this.lbl_diskUsed.text = uiApi.getText("ui.option.performance.groundCacheSize","0");
      }
      
      override public function onRelease(param1:Object) : void
      {
         sysApi.log(8,"onRelease sur " + param1 + " : " + param1.name);
         switch(param1)
         {
            case this.btn_groundCacheEnabled:
               if(this.btn_groundCacheEnabled.selected)
               {
                  setProperty("atouin","groundCacheMode",1);
                  this.updateGroundCacheOption(1);
               }
               else
               {
                  setProperty("atouin","groundCacheMode",0);
                  this.updateGroundCacheOption(0);
               }
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_groundCacheQuality1:
               setProperty("atouin","groundCacheMode",1);
               this.updateGroundCacheOption(1);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_groundCacheQuality2:
               setProperty("atouin","groundCacheMode",2);
               this.updateGroundCacheOption(2);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_groundCacheQuality3:
               setProperty("atouin","groundCacheMode",3);
               this.updateGroundCacheOption(3);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_clearGroundCache:
               this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.option.performance.confirmClearGroundCache"),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmClearGroundCache,null],this.onConfirmClearGroundCache);
               break;
            case this.btn_left:
               if(this.btn_quality1.selected)
               {
                  this.selectQualityMode(0);
                  this.btn_quality0.selected = true;
               }
               else if(this.btn_quality2.selected)
               {
                  this.selectQualityMode(1);
                  this.btn_quality1.selected = true;
               }
               else if(this.btn_quality3.selected)
               {
                  this.selectQualityMode(2);
                  this.btn_quality2.selected = true;
               }
               break;
            case this.btn_right:
               if(this.btn_quality2.selected)
               {
                  this.selectQualityMode(3);
                  this.btn_quality3.selected = true;
               }
               else if(this.btn_quality1.selected)
               {
                  this.selectQualityMode(2);
                  this.btn_quality2.selected = true;
               }
               else if(this.btn_quality0.selected)
               {
                  this.selectQualityMode(1);
                  this.btn_quality1.selected = true;
               }
               break;
            case this.btn_quality0:
               this.selectQualityMode(0);
               break;
            case this.btn_quality1:
               this.selectQualityMode(1);
               break;
            case this.btn_quality2:
               this.selectQualityMode(2);
               break;
            case this.btn_quality3:
               this.selectQualityMode(3);
               break;
            case this.btn_useLDSkin:
               setProperty("atouin","useLowDefSkin",this.btn_useLDSkin.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_showAllMonsters:
               setProperty("dofus","showEveryMonsters",this.btn_showAllMonsters.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowAnimsFun:
               setProperty("dofus","allowAnimsFun",this.btn_allowAnimsFun.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowAnimatedGfx:
               setProperty("atouin","allowAnimatedGfx",this.btn_allowAnimatedGfx.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowParticlesFx:
               setProperty("atouin","allowParticlesFx",this.btn_allowParticlesFx.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowSpellEffects:
               setProperty("dofus","allowSpellEffects",this.btn_allowSpellEffects.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowHitAnim:
               setProperty("dofus","allowHitAnim",this.btn_allowHitAnim.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowUiShadows:
               setProperty("berilia","uiShadows",this.btn_allowUiShadows.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_allowUiAnimations:
               setProperty("berilia","uiAnimations",this.btn_allowUiAnimations.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_showTurnPicture:
               setProperty("dofus","turnPicture",this.btn_showTurnPicture.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_showAuraOnFront:
               setProperty("tiphon","alwaysShowAuraOnFront",this.btn_showAuraOnFront.selected);
               this.btn_quality3.selected = true;
               this.selectQualityMode(3);
               break;
            case this.btn_optimizeMultiAccount:
               setProperty("dofus","optimizeMultiAccount",this.btn_optimizeMultiAccount.selected);
               break;
            case this.btn_fullScreen:
               if(sysApi.isStreaming() && !this.btn_fullScreen.selected)
               {
                  uiApi.setShortcutUsedToExitFullScreen(true);
               }
               setProperty("dofus","fullScreen",this.btn_fullScreen.selected);
         }
      }
      
      public function onMouseUp(param1:Object) : void
      {
         sysApi.log(8,"onMouseUp sur " + param1 + " : " + param1.name);
         switch(param1)
         {
            case this.btn_quality0:
               this.selectQualityMode(0);
               this.btn_quality0.selected = true;
               break;
            case this.btn_quality1:
               this.selectQualityMode(1);
               this.btn_quality1.selected = true;
               break;
            case this.btn_quality2:
               this.selectQualityMode(2);
               this.btn_quality2.selected = true;
               break;
            case this.btn_quality3:
               this.selectQualityMode(3);
               this.btn_quality3.selected = true;
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         switch(param1)
         {
            case this.cb_creatures:
               if(this._creatureLimits[this.cb_creatures.selectedIndex] == this._infinityText)
               {
                  _loc4_ = 100;
               }
               else
               {
                  _loc4_ = int(this._creatureLimits[this.cb_creatures.selectedIndex]);
               }
               setProperty("tiphon","creaturesMode",_loc4_);
               break;
            case this.cb_pointsOverHead:
               setProperty("tiphon","pointsOverhead",this.cb_pointsOverHead.selectedIndex);
               break;
            case this.cb_flashQuality:
               setProperty("dofus","flashQuality",this.cb_flashQuality.selectedIndex);
               break;
            case this.cb_auras:
               setProperty("tiphon","auraMode",this.cb_auras.selectedIndex);
         }
         if(param2 != 2 && param2 != 7)
         {
            this.btn_quality3.selected = true;
            this.selectQualityMode(3);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_quality0:
               _loc2_ = uiApi.getText("ui.option.quality.lowText");
               break;
            case this.btn_quality1:
               _loc2_ = uiApi.getText("ui.option.quality.mediumText");
               break;
            case this.btn_quality2:
               _loc2_ = uiApi.getText("ui.option.quality.highText");
               break;
            case this.btn_quality3:
               _loc2_ = uiApi.getText("ui.option.quality.customText");
               break;
            case this.btn_groundCacheEnabled:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.performance.groundCacheTooltip");
               break;
            case this.btn_groundCacheQuality1:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.performance.groundCacheTooltipHigh");
               break;
            case this.btn_groundCacheQuality2:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.performance.groundCacheTooltipMedium");
               break;
            case this.btn_groundCacheQuality3:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.performance.groundCacheTooltipLow");
               break;
            case this.lbl_showPointsOverhead:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.overHeadInfoTooltip");
               break;
            case this.btn_showTurnPicture:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.showTurnPictureTooltip");
               break;
            case this.btn_showAuraOnFront:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.option.showAuraOnFrontTooltip");
               break;
            case this.btn_optimizeMultiAccount:
               _loc3_ = 5;
               _loc4_ = 3;
               _loc2_ = uiApi.getText("ui.config.optimizeMultiAccountInfo");
               break;
            case this.btn_showAllMonsters:
               _loc2_ = uiApi.getText("ui.option.creaturesTooltip");
         }
         uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
