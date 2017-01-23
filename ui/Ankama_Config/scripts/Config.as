package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.BuildTypeEnum;
   import d2enums.StrataEnum;
   import d2hooks.ActivateSound;
   import d2hooks.AuthentificationStart;
   import d2hooks.CharacterSelectionStart;
   import d2hooks.GameStart;
   import d2hooks.QualitySelectionRequired;
   import d2hooks.ServersList;
   import d2hooks.SetDofusQuality;
   import flash.display.Sprite;
   import ui.ConfigAudio;
   import ui.ConfigCache;
   import ui.ConfigChat;
   import ui.ConfigCompatibility;
   import ui.ConfigGeneral;
   import ui.ConfigModules;
   import ui.ConfigNotification;
   import ui.ConfigPerformance;
   import ui.ConfigShortcut;
   import ui.ConfigShortcutPopup;
   import ui.ConfigSupport;
   import ui.ConfigTheme;
   import ui.ModuleInfo;
   import ui.ModuleMarketplace;
   import ui.QualitySelection;
   import ui.ThemeInstaller;
   import ui.item.ChannelColorizedItem;
   import ui.item.ModuleItem;
   import ui.item.ThemeItem;
   
   public class Config extends Sprite
   {
       
      
      private var include_ConfigGeneral:ConfigGeneral = null;
      
      private var include_ConfigChat:ConfigChat = null;
      
      private var include_ConfigModules:ConfigModules = null;
      
      private var include_ConfigPerformance:ConfigPerformance = null;
      
      private var include_ConfigShortcut:ConfigShortcut = null;
      
      private var include_ConfigShortcutPopup:ConfigShortcutPopup = null;
      
      private var include_ChannelColorizedItem:ChannelColorizedItem = null;
      
      private var include_ConfigAudio:ConfigAudio = null;
      
      private var include_ConfigCache:ConfigCache;
      
      private var include_ConfigSupport:ConfigSupport;
      
      private var include_ConfigCompatibility:ConfigCompatibility;
      
      private var include_ConfigNotification:ConfigNotification;
      
      private var include_ConfigTheme:ConfigTheme;
      
      private var include_QualitySelection:QualitySelection;
      
      private var include_ModuleInfo:ModuleInfo;
      
      private var include_ModuleMarketplace:ModuleMarketplace;
      
      private var include_ModuleItem:ModuleItem;
      
      private var include_ThemeInstaller:ThemeInstaller;
      
      private var include_ThemeItem:ThemeItem;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var commonMod:Object;
      
      public var configApi:ConfigApi;
      
      public function Config()
      {
         super();
      }
      
      public function main() : void
      {
         Config.uiApi = this.uiApi;
         this.defineItems();
         this.sysApi.addHook(AuthentificationStart,this.onAuthentificationStart);
         this.sysApi.addHook(ServersList,this.onServersList);
         this.sysApi.addHook(CharacterSelectionStart,this.onCharacterSelectionStart);
         this.sysApi.addHook(GameStart,this.onGameStart);
         this.sysApi.addHook(QualitySelectionRequired,this.onQualitySelectionRequired);
         this.sysApi.addHook(SetDofusQuality,this.onSetDofusQuality);
         this.uiApi.addShortcutHook("muteSound",this.onShortcut);
         var _loc1_:uint = this.sysApi.getOption("dofusQuality","dofus");
         if(_loc1_ == 0)
         {
            this.configApi.setConfigProperty("atouin","groundCacheMode",0);
         }
      }
      
      private function defineItems() : void
      {
         Config.register("performance","ui.option.performance","ui.option.performanceSubtitle","Ankama_Config::configPerformance");
         Config.register("sound","ui.option.audio","ui.option.audioSubtitle","Ankama_Config::configAudio");
         Config.register("compatibility","ui.option.compatibility","ui.option.compatibilitySubtitle","Ankama_Config::configCompatibility");
         Config.register("notification","ui.option.notifications","ui.option.notificationsSubtitle","Ankama_Config::configNotification");
         Config.register("cache","ui.option.cache","ui.option.cacheSubtitle","Ankama_Config::configCache");
         Config.register("support","ui.option.support","ui.option.supportSubtitle","Ankama_Config::configSupport");
         Config.register("theme","ui.option.theme","ui.option.themeSubtitle","Ankama_Config::configTheme");
         Config.register("modules","ui.option.modules","ui.option.modulesSubtitle","Ankama_Config::configModules");
         Config.register("ui","ui.option.interface","ui.option.interfaceSubtitle","Ankama_Config::configChat");
         Config.register("general","ui.option.feature","ui.option.featureSubtitle","Ankama_Config::configGeneral");
         Config.register("shortcut","ui.option.shortcut","ui.option.shortcutSubtitle","Ankama_Config::configShortcut");
      }
      
      private function addItem(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:ConfigItem = null;
         if(param2)
         {
            _loc3_ = Config.getItem(param1);
            this.commonMod.addOptionItem(_loc3_.id,_loc3_.name,_loc3_.description,_loc3_.ui);
         }
      }
      
      private function onGameStart() : void
      {
         this.addItem("performance");
         this.addItem("ui");
         this.addItem("general");
         this.addItem("shortcut");
         this.addItem("sound");
         this.addItem("notification",this.sysApi.hasAir());
         this.addItem("cache");
         this.addItem("theme",this.sysApi.hasAir());
         this.addItem("support");
         if(this.sysApi.getBuildType() > BuildTypeEnum.TESTING || this.sysApi.getBuildType() != BuildTypeEnum.RELEASE && this.sysApi.getConfigEntry("config.dev.mode"))
         {
            this.addItem("modules",this.sysApi.hasAir());
         }
      }
      
      private function gameApproachInit() : void
      {
         this.addItem("performance");
         this.addItem("sound");
         this.addItem("cache");
         this.addItem("theme",this.sysApi.hasAir());
         this.addItem("support");
         if(this.sysApi.getBuildType() == BuildTypeEnum.DEBUG || this.sysApi.getBuildType() != BuildTypeEnum.RELEASE && this.sysApi.getConfigEntry("config.dev.mode"))
         {
            this.addItem("modules",this.sysApi.hasAir());
         }
      }
      
      private function onAuthentificationStart(param1:Boolean) : void
      {
         this.gameApproachInit();
      }
      
      private function onServersList(param1:Object) : void
      {
         this.gameApproachInit();
      }
      
      private function onCharacterSelectionStart(param1:Object) : void
      {
         this.gameApproachInit();
      }
      
      private function onQualitySelectionRequired() : void
      {
         if(this.configApi.getConfigProperty("dofus","askForQualitySelection"))
         {
            this.uiApi.loadUi("qualitySelection",null,null,StrataEnum.STRATA_HIGH);
         }
      }
      
      private function onSetDofusQuality(param1:uint) : void
      {
         if(param1 == 0)
         {
            this.configApi.setConfigProperty("dofus","showEveryMonsters",false);
            this.configApi.setConfigProperty("dofus","allowAnimsFun",false);
            this.configApi.setConfigProperty("tiphon","alwaysShowAuraOnFront",false);
            this.configApi.setConfigProperty("berilia","uiShadows",false);
            this.configApi.setConfigProperty("berilia","uiAnimations",false);
            this.configApi.setConfigProperty("tubul","allowSoundEffects",false);
            this.configApi.setConfigProperty("dofus","turnPicture",false);
            this.configApi.setConfigProperty("dofus","allowSpellEffects",this.sysApi.setQualityIsEnable());
            this.configApi.setConfigProperty("dofus","allowHitAnim",this.sysApi.setQualityIsEnable());
            this.configApi.setConfigProperty("dofus","cacheMapEnabled",false);
            this.configApi.setConfigProperty("atouin","allowAnimatedGfx",false);
            this.configApi.setConfigProperty("atouin","allowParticlesFx",false);
            this.configApi.setConfigProperty("atouin","groundCacheMode",0);
         }
         else if(param1 == 1)
         {
            this.configApi.setConfigProperty("dofus","showEveryMonsters",false);
            this.configApi.setConfigProperty("dofus","allowAnimsFun",false);
            this.configApi.setConfigProperty("tiphon","alwaysShowAuraOnFront",false);
            this.configApi.setConfigProperty("berilia","uiShadows",false);
            this.configApi.setConfigProperty("berilia","uiAnimations",true);
            this.configApi.setConfigProperty("tubul","allowSoundEffects",true);
            this.configApi.setConfigProperty("dofus","turnPicture",true);
            this.configApi.setConfigProperty("dofus","allowSpellEffects",true);
            this.configApi.setConfigProperty("dofus","allowHitAnim",true);
            this.configApi.setConfigProperty("dofus","cacheMapEnabled",true);
            this.configApi.setConfigProperty("atouin","allowAnimatedGfx",false);
            this.configApi.setConfigProperty("atouin","allowParticlesFx",true);
            this.configApi.setConfigProperty("atouin","groundCacheMode",1);
         }
         else if(param1 == 2)
         {
            this.configApi.setConfigProperty("dofus","showEveryMonsters",true);
            this.configApi.setConfigProperty("dofus","allowAnimsFun",true);
            this.configApi.setConfigProperty("tiphon","alwaysShowAuraOnFront",true);
            this.configApi.setConfigProperty("berilia","uiShadows",true);
            this.configApi.setConfigProperty("berilia","uiAnimations",true);
            this.configApi.setConfigProperty("tubul","allowSoundEffects",true);
            this.configApi.setConfigProperty("dofus","turnPicture",true);
            this.configApi.setConfigProperty("dofus","allowSpellEffects",true);
            this.configApi.setConfigProperty("dofus","allowHitAnim",true);
            this.configApi.setConfigProperty("dofus","cacheMapEnabled",true);
            this.configApi.setConfigProperty("atouin","allowAnimatedGfx",true);
            this.configApi.setConfigProperty("atouin","allowParticlesFx",true);
            this.configApi.setConfigProperty("atouin","groundCacheMode",1);
         }
         else
         {
            return;
         }
         this.configApi.setConfigProperty("dofus","dofusQuality",param1);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         switch(param1)
         {
            case "muteSound":
               _loc2_ = false;
               if(this.configApi.getConfigProperty("tubul","tubulIsDesactivated"))
               {
                  _loc2_ = true;
               }
               this.configApi.setConfigProperty("tubul","tubulIsDesactivated",!_loc2_);
               this.sysApi.dispatchHook(ActivateSound,!_loc2_);
               return true;
            default:
               return false;
         }
      }
      
      public function unload() : void
      {
         Config.uiApi = null;
      }
   }
}

import com.ankamagames.berilia.api.UiApi;

class ConfigItem
{
   
   private static var _items:Array = [];
   
   public static var uiApi:UiApi;
    
   
   public var id:String;
   
   public var name:String;
   
   public var description:String;
   
   public var ui:String;
   
   function ConfigItem()
   {
      super();
   }
   
   public static function getItem(param1:String) : ConfigItem
   {
      return _items[param1];
   }
   
   public static function register(param1:String, param2:String, param3:String, param4:String) : void
   {
      var _loc5_:ConfigItem = new ConfigItem();
      _loc5_.id = param1;
      _loc5_.name = uiApi.getText(param2);
      _loc5_.description = uiApi.getText(param3);
      _loc5_.ui = param4;
      _items[param1] = _loc5_;
   }
}
