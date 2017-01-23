package ui
{
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2hooks.ActivateSound;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import types.ConfigProperty;
   
   public class ConfigAudio extends ConfigUi
   {
       
      
      public var output:Object;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var btn_playSoundForGuildMessage:ButtonContainer;
      
      public var btn_playSoundAtTurnStart:ButtonContainer;
      
      public var btn_infiniteLoopMusics:ButtonContainer;
      
      public var btn_lessGlobal:ButtonContainer;
      
      public var btn_moreGlobal:ButtonContainer;
      
      public var btn_lessMusic:ButtonContainer;
      
      public var btn_moreMusic:ButtonContainer;
      
      public var btn_lessSound:ButtonContainer;
      
      public var btn_moreSound:ButtonContainer;
      
      public var btn_lessAmbientSound:ButtonContainer;
      
      public var btn_moreAmbientSound:ButtonContainer;
      
      public var pb_global:ProgressBar;
      
      public var pb_music:ProgressBar;
      
      public var pb_sound:ProgressBar;
      
      public var pb_ambientSound:ProgressBar;
      
      public var btn_globalMute:ButtonContainer;
      
      public var btn_musicMute:ButtonContainer;
      
      public var btn_soundMute:ButtonContainer;
      
      public var btn_ambientSoundMute:ButtonContainer;
      
      public var input_bus1:Object;
      
      public var input_bus2:Object;
      
      public var input_bus3:Object;
      
      public var input_bus4:Object;
      
      public var input_bus5:Object;
      
      public var input_bus6:Object;
      
      public var input_bus7:Object;
      
      public var input_bus8:Object;
      
      public var soundOptionCtr:GraphicContainer;
      
      public var lbl_updater:TextArea;
      
      private var _textfieldDico:Dictionary;
      
      public function ConfigAudio()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("btn_globalMute","tubulIsDesactivated","tubul"));
         _loc2_.push(new ConfigProperty("","volumeMusic","tubul"));
         _loc2_.push(new ConfigProperty("","volumeSound","tubul"));
         _loc2_.push(new ConfigProperty("","volumeAmbientSound","tubul"));
         _loc2_.push(new ConfigProperty("","globalVolume","tubul"));
         _loc2_.push(new ConfigProperty("btn_musicMute","muteMusic","tubul"));
         _loc2_.push(new ConfigProperty("btn_soundMute","muteSound","tubul"));
         _loc2_.push(new ConfigProperty("btn_ambientSoundMute","muteAmbientSound","tubul"));
         _loc2_.push(new ConfigProperty("btn_playSoundForGuildMessage","playSoundForGuildMessage","tubul"));
         _loc2_.push(new ConfigProperty("btn_playSoundAtTurnStart","playSoundAtTurnStart","tubul"));
         _loc2_.push(new ConfigProperty("btn_infiniteLoopMusics","infiniteLoopMusics","tubul"));
         init(_loc2_);
         sysApi.addHook(ActivateSound,this.onActivateSound);
         uiApi.addComponentHook(this.pb_global,"onRelease");
         uiApi.addComponentHook(this.pb_music,"onRelease");
         uiApi.addComponentHook(this.pb_sound,"onRelease");
         uiApi.addComponentHook(this.pb_ambientSound,"onRelease");
         uiApi.addComponentHook(this.btn_moreGlobal,"onRelease");
         uiApi.addComponentHook(this.btn_lessGlobal,"onRelease");
         uiApi.addComponentHook(this.btn_moreMusic,"onRelease");
         uiApi.addComponentHook(this.btn_lessMusic,"onRelease");
         uiApi.addComponentHook(this.btn_moreSound,"onRelease");
         uiApi.addComponentHook(this.btn_lessSound,"onRelease");
         uiApi.addComponentHook(this.btn_moreAmbientSound,"onRelease");
         uiApi.addComponentHook(this.btn_lessAmbientSound,"onRelease");
         uiApi.addComponentHook(this.btn_globalMute,"onRelease");
         uiApi.addComponentHook(this.btn_musicMute,"onRelease");
         uiApi.addComponentHook(this.btn_soundMute,"onRelease");
         uiApi.addComponentHook(this.btn_ambientSoundMute,"onRelease");
         this._textfieldDico = new Dictionary();
         this.displayUpdate();
      }
      
      override public function reset() : void
      {
         super.reset();
         this.displayUpdate();
      }
      
      public function unload() : void
      {
      }
      
      public function displayUpdate() : void
      {
         var _loc1_:Number = sysApi.getOption("volumeMusic","tubul");
         var _loc2_:Number = sysApi.getOption("volumeSound","tubul");
         var _loc3_:Number = sysApi.getOption("volumeAmbientSound","tubul");
         var _loc4_:Number = sysApi.getOption("globalVolume","tubul");
         this.btn_musicMute.selected = sysApi.getOption("muteMusic","tubul");
         this.btn_soundMute.selected = sysApi.getOption("muteSound","tubul");
         this.btn_ambientSoundMute.selected = sysApi.getOption("muteAmbientSound","tubul");
         this.btn_playSoundForGuildMessage.selected = sysApi.getOption("playSoundForGuildMessage","tubul");
         this.btn_playSoundAtTurnStart.selected = sysApi.getOption("playSoundAtTurnStart","tubul");
         this.btn_infiniteLoopMusics.selected = sysApi.getOption("infiniteLoopMusics","tubul");
         this.btn_globalMute.selected = sysApi.getOption("tubulIsDesactivated","tubul");
         sysApi.log(2," options de tubul : music " + sysApi.getOption("volumeMusic","tubul") + ", son " + sysApi.getOption("volumeSound","tubul") + ", son d\'ambiance " + sysApi.getOption("volumeAmbientSound","tubul") + "   --> tubul desactivé " + sysApi.getOption("tubulIsDesactivated","tubul"));
         this.pb_global.value = _loc4_;
         this.pb_sound.value = _loc2_;
         this.pb_music.value = _loc1_;
         this.pb_ambientSound.value = _loc3_;
         if(this.btn_musicMute.selected)
         {
            this.btn_musicMute.soundId = SoundEnum.CHECKBOX_CHECKED;
         }
         else
         {
            this.btn_musicMute.soundId = SoundEnum.CHECKBOX_UNCHECKED;
         }
         if(this.btn_soundMute.selected)
         {
            this.btn_soundMute.soundId = SoundEnum.CHECKBOX_CHECKED;
         }
         else
         {
            this.btn_soundMute.soundId = SoundEnum.CHECKBOX_UNCHECKED;
         }
         if(this.btn_ambientSoundMute.selected)
         {
            this.btn_ambientSoundMute.soundId = SoundEnum.CHECKBOX_CHECKED;
         }
         else
         {
            this.btn_ambientSoundMute.soundId = SoundEnum.CHECKBOX_UNCHECKED;
         }
         if(this.soundApi.updaterAvailable())
         {
            this.lbl_updater.text = uiApi.getText("ui.option.soundSocketAvailable");
         }
         else
         {
            this.lbl_updater.text = uiApi.getText("ui.option.soundSocketClosed");
         }
         this.activeOptions(this.btn_globalMute.selected);
      }
      
      private function onVolChange(param1:Event) : void
      {
         if(param1.target.text == "")
         {
            param1.target.text = 0;
         }
         this.soundApi.setBusVolume(this._textfieldDico[param1.target.name],param1.target.text);
      }
      
      private function saveOptions() : void
      {
      }
      
      private function undoOptions() : void
      {
      }
      
      private function activeOptions(param1:Boolean) : void
      {
         this.soundOptionCtr.disabled = param1;
         sysApi.dispatchHook(ActivateSound,param1);
      }
      
      private function onActivateSound(param1:Boolean) : void
      {
         this.soundOptionCtr.disabled = param1;
         this.btn_globalMute.selected = param1;
      }
      
      override public function onRelease(param1:Object) : void
      {
         super.onRelease(param1);
         switch(param1)
         {
            case this.btn_globalMute:
               this.activeOptions(this.btn_globalMute.selected);
               break;
            case this.pb_global:
               this.fixSoundValue(this.pb_global,"globalVolume");
               this.fixButtonState(this.pb_global.value,this.btn_lessGlobal,this.btn_moreGlobal);
               break;
            case this.btn_moreGlobal:
               this.pb_global.value = this.pb_global.value + 0.1;
               this.fixSoundValue(this.pb_global,"globalVolume");
               this.fixButtonState(this.pb_global.value,this.btn_lessGlobal,this.btn_moreGlobal);
               break;
            case this.btn_lessGlobal:
               this.pb_global.value = this.pb_global.value - 0.21;
               this.fixSoundValue(this.pb_global,"globalVolume");
               this.fixButtonState(this.pb_global.value,this.btn_lessGlobal,this.btn_moreGlobal);
               break;
            case this.pb_music:
               this.fixSoundValue(this.pb_music,"volumeMusic");
               this.fixButtonState(this.pb_music.value,this.btn_lessMusic,this.btn_moreMusic);
               break;
            case this.btn_moreMusic:
               this.pb_music.value = this.pb_music.value + 0.1;
               this.fixSoundValue(this.pb_music,"volumeMusic");
               this.fixButtonState(this.pb_music.value,this.btn_lessMusic,this.btn_moreMusic);
               break;
            case this.btn_lessMusic:
               this.pb_music.value = this.pb_music.value - 0.21;
               this.fixSoundValue(this.pb_music,"volumeMusic");
               this.fixButtonState(this.pb_music.value,this.btn_lessMusic,this.btn_moreMusic);
               break;
            case this.pb_sound:
               this.fixSoundValue(this.pb_sound,"volumeSound");
               this.fixButtonState(this.pb_sound.value,this.btn_lessSound,this.btn_moreSound);
               break;
            case this.btn_moreSound:
               this.pb_sound.value = this.pb_sound.value + 0.1;
               this.fixSoundValue(this.pb_sound,"volumeSound");
               this.fixButtonState(this.pb_sound.value,this.btn_lessSound,this.btn_moreSound);
               break;
            case this.btn_lessSound:
               this.pb_sound.value = this.pb_sound.value - 0.21;
               this.fixSoundValue(this.pb_sound,"volumeSound");
               this.fixButtonState(this.pb_sound.value,this.btn_lessSound,this.btn_moreSound);
               break;
            case this.pb_ambientSound:
               this.fixSoundValue(this.pb_ambientSound,"volumeAmbientSound");
               this.fixButtonState(this.pb_ambientSound.value,this.btn_lessAmbientSound,this.btn_moreAmbientSound);
               break;
            case this.btn_moreAmbientSound:
               this.pb_ambientSound.value = this.pb_ambientSound.value + 0.1;
               this.fixSoundValue(this.pb_ambientSound,"volumeAmbientSound");
               this.fixButtonState(this.pb_ambientSound.value,this.btn_lessAmbientSound,this.btn_moreAmbientSound);
               break;
            case this.btn_lessAmbientSound:
               this.pb_ambientSound.value = this.pb_ambientSound.value - 0.21;
               this.fixSoundValue(this.pb_ambientSound,"volumeAmbientSound");
               this.fixButtonState(this.pb_ambientSound.value,this.btn_lessAmbientSound,this.btn_moreAmbientSound);
               break;
            case this.btn_musicMute:
               if(this.btn_musicMute.selected)
               {
                  this.btn_musicMute.soundId = SoundEnum.CHECKBOX_CHECKED;
                  setProperty("tubul","muteMusic",true);
               }
               else
               {
                  this.btn_musicMute.soundId = SoundEnum.CHECKBOX_UNCHECKED;
                  setProperty("tubul","muteMusic",false);
               }
               break;
            case this.btn_soundMute:
               if(this.btn_soundMute.selected)
               {
                  this.btn_soundMute.soundId = SoundEnum.CHECKBOX_CHECKED;
                  setProperty("tubul","muteSound",true);
               }
               else
               {
                  this.btn_soundMute.soundId = SoundEnum.CHECKBOX_UNCHECKED;
                  setProperty("tubul","muteSound",false);
               }
               break;
            case this.btn_ambientSoundMute:
               if(this.btn_ambientSoundMute.selected)
               {
                  this.btn_ambientSoundMute.soundId = SoundEnum.CHECKBOX_CHECKED;
                  setProperty("tubul","muteAmbientSound",true);
               }
               else
               {
                  this.btn_ambientSoundMute.soundId = SoundEnum.CHECKBOX_UNCHECKED;
                  setProperty("tubul","muteAmbientSound",false);
               }
         }
      }
      
      private function fixButtonState(param1:Number, param2:ButtonContainer, param3:ButtonContainer) : void
      {
         param2.disabled = param1 == 0;
         param3.disabled = param1 == 1;
      }
      
      private function fixSoundValue(param1:ProgressBar, param2:String) : void
      {
         var _loc3_:Number = param1.value;
         param1.value = _loc3_;
         setProperty("tubul",param2,_loc3_);
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(0)
         {
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_musicMute:
               _loc2_ = uiApi.getText("ui.option.muteMusic");
               _loc3_ = 3;
               _loc4_ = 5;
               break;
            case this.btn_soundMute:
               _loc2_ = uiApi.getText("ui.option.muteSound");
               _loc3_ = 3;
               _loc4_ = 5;
               break;
            case this.btn_ambientSoundMute:
               _loc2_ = uiApi.getText("ui.option.muteAmbience");
               _loc3_ = 3;
               _loc4_ = 5;
               break;
            case this.btn_globalMute:
               _loc2_ = uiApi.getText("ui.option.mute");
               _loc3_ = 3;
               _loc4_ = 5;
               break;
            case this.pb_global:
               _loc2_ = this.pb_global.value * 100 + "%";
               break;
            case this.pb_music:
               _loc2_ = this.pb_music.value * 100 + "%";
               break;
            case this.pb_sound:
               _loc2_ = this.pb_sound.value * 100 + "%";
               break;
            case this.pb_ambientSound:
               _loc2_ = this.pb_ambientSound.value * 100 + "%";
         }
         uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
