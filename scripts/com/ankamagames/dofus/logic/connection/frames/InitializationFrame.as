package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.berilia.managers.EmbedFontManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.ModuleExecErrorMessage;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.types.messages.NoThemeErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadedMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedErrorMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.datacenter.appearance.SkinMapping;
   import com.ankamagames.dofus.datacenter.misc.CensoredContent;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.internalDatacenter.communication.CraftSmileyItem;
   import com.ankamagames.dofus.internalDatacenter.communication.DelayedActionItem;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.ThinkBubble;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.PaddockWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.QuantifiedItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyCompanionWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsListWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.PanicMessages;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.ClassicSoundManager;
   import com.ankamagames.dofus.logic.common.frames.QueueFrame;
   import com.ankamagames.dofus.logic.common.managers.DofusFpsManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkMapPosition;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkScreenshot;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAccountMenuManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAchievementManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAllianceManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowDareChatManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowEntityManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowEstate;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowGuildManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterChatManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterFightManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterGroup;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowNpcManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowOfflineSales;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowOrnamentManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowPlayerMenuManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowQuestManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowRecipeManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowSubArea;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowTitleManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSocialManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSpellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSubstitutionManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSwapPositionRequest;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSystem;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkTaxCollectorCollected;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkTaxCollectorPosition;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkURLManager;
   import com.ankamagames.dofus.logic.connection.managers.SpecialBetaAuthentification;
   import com.ankamagames.dofus.logic.connection.messages.UpdaterConnectionStatusMessage;
   import com.ankamagames.dofus.logic.game.common.managers.SteamManager;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GroundObject;
   import com.ankamagames.dofus.logic.game.roleplay.types.MutantTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PortalTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PrismTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.TaxCollectorTooltipInformation;
   import com.ankamagames.dofus.misc.lists.AlignmentHookList;
   import com.ankamagames.dofus.misc.lists.ApiActionList;
   import com.ankamagames.dofus.misc.lists.ApiChatActionList;
   import com.ankamagames.dofus.misc.lists.ApiCraftActionList;
   import com.ankamagames.dofus.misc.lists.ApiExchangeActionList;
   import com.ankamagames.dofus.misc.lists.ApiLivingObjectActionList;
   import com.ankamagames.dofus.misc.lists.ApiMountActionList;
   import com.ankamagames.dofus.misc.lists.ApiRolePlayActionList;
   import com.ankamagames.dofus.misc.lists.ApiSocialActionList;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.CustomUiHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.ExternalGameHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.GameDataList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.LivingObjectHookList;
   import com.ankamagames.dofus.misc.lists.MountHookList;
   import com.ankamagames.dofus.misc.lists.PrismHookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.utils.CustomLoadingScreenManager;
   import com.ankamagames.dofus.misc.utils.DofusApiAction;
   import com.ankamagames.dofus.misc.utils.LoadingScreen;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterWaveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMountInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcWithQuestInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.types.data.SpellTooltipInfo;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.CaptureApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ColorApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.DocumentApi;
   import com.ankamagames.dofus.uiApi.ExchangeApi;
   import com.ankamagames.dofus.uiApi.ExternalNotificationApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.FileApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.NotificationApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TestApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.jerakine.data.CensoredContentManager;
   import com.ankamagames.jerakine.data.GameDataUpdater;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.I18nUpdater;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.LangAllFilesLoadedMessage;
   import com.ankamagames.jerakine.messages.LangFileLoadedMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.FileEvent;
   import com.ankamagames.jerakine.types.events.LangFileEvent;
   import com.ankamagames.jerakine.utils.crypto.FolderHashChecker;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemPopupUI;
   import com.ankamagames.performance.Benchmark;
   import com.ankamagames.tiphon.engine.SubstituteAnimationManager;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import com.ankamagames.tiphon.types.Skin;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class InitializationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InitializationFrame));
      
      private static var _fhct:FolderHashChecker;
       
      
      private var _aFiles:Array;
      
      private var _aLoadedFiles:Array;
      
      private var _aModuleInit:Array;
      
      private var _loadingScreen:LoadingScreen;
      
      private var _subConfigCount:uint;
      
      private var _percentPerModule:Number = 0;
      
      private var _modPercents:Array;
      
      private var _isSubLangConfig:Boolean;
      
      private var _isSubCustomConfig:Boolean;
      
      private var _isTemporaryCustomConfig:Boolean;
      
      private var _updaterConnectionSuccess:Boolean;
      
      private var _skinChangePop:SystemPopupUI;
      
      public function InitializationFrame()
      {
         this._modPercents = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:Boolean = false;
         this.initPerformancesWatcher();
         this.initStaticConstants();
         this.initModulesBindings();
         this.displayLoadingScreen();
         this._aModuleInit = new Array();
         this._aModuleInit["config"] = false;
         this._aModuleInit["colors"] = false;
         this._aModuleInit["langFiles"] = false;
         this._aModuleInit["font"] = false;
         this._aModuleInit["i18n"] = false;
         this._aModuleInit["gameData"] = false;
         this._aModuleInit["modules"] = false;
         this._aModuleInit["uiXmlParsing"] = false;
         this._aModuleInit["uiThemeCheck"] = false;
         for each(_loc1_ in this._aModuleInit)
         {
            this._percentPerModule++;
         }
         this._percentPerModule = 100 / this._percentPerModule;
         LangManager.getInstance().loadFile("config.xml");
         SubstituteAnimationManager.setDefaultAnimation("AnimStatique","AnimStatique");
         SubstituteAnimationManager.setDefaultAnimation("AnimTacle","AnimHit");
         SubstituteAnimationManager.setDefaultAnimation("AnimAttaque","AnimAttaque0");
         SubstituteAnimationManager.setDefaultAnimation("AnimArme","AnimArme0");
         SubstituteAnimationManager.setDefaultAnimation("AnimThrow","AnimStatique");
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var ucsmsg:UpdaterConnectionStatusMessage = null;
         var langMsg:LangFileLoadedMessage = null;
         var langAllMsg:LangAllFilesLoadedMessage = null;
         var ankamaModule:Boolean = false;
         var mrlfm:ModuleRessourceLoadFailedMessage = null;
         var lang:String = null;
         var subLangConfigFile:String = null;
         var subCustomConfigFile:String = null;
         var tempSubCustomConfigFile:String = null;
         var xmlPos:int = 0;
         var fileNamePos:int = 0;
         var catName:String = null;
         var newValues:Array = null;
         var key:String = null;
         var keyInfo:Array = null;
         var oldKey:String = null;
         var lastLang:String = null;
         var resetLang:Boolean = false;
         var overrideFile:Uri = null;
         var currentCommunity:String = null;
         var msg:Message = param1;
         switch(true)
         {
            case msg is UpdaterConnectionStatusMessage:
               ucsmsg = msg as UpdaterConnectionStatusMessage;
               this._updaterConnectionSuccess = ucsmsg.success;
               return true;
            case msg is LangFileLoadedMessage:
               langMsg = LangFileLoadedMessage(msg);
               if(!langMsg.success)
               {
                  if(langMsg.file.indexOf("i18n") > -1)
                  {
                     this._loadingScreen.log("Unabled to load i18n file " + langMsg.file,LoadingScreen.ERROR);
                     Kernel.panic(PanicMessages.I18N_LOADING_FAILED,[LangManager.getInstance().getEntry("config.lang.current")]);
                  }
                  else if(langMsg.file.indexOf("config.xml") > -1)
                  {
                     this._loadingScreen.log("Unabled to load main config file : " + langMsg.file,LoadingScreen.ERROR);
                     Kernel.panic(PanicMessages.CONFIG_LOADING_FAILED);
                  }
                  else if(langMsg.file.indexOf("config-") > -1)
                  {
                     this._loadingScreen.log("Unabled to load secondary config file : " + langMsg.file,LoadingScreen.INFO);
                     this._aModuleInit["config"] = true;
                     this.setModulePercent("config",100);
                  }
                  else
                  {
                     this._loadingScreen.log("Unabled to load  " + langMsg.file,LoadingScreen.ERROR);
                  }
               }
               if(this._loadingScreen)
               {
                  this._loadingScreen.log(langMsg.file + " loaded.",LoadingScreen.INFO);
               }
               return true;
            case msg is LangAllFilesLoadedMessage:
               langAllMsg = LangAllFilesLoadedMessage(msg);
               _log.debug("file : " + langAllMsg.file);
               switch(langAllMsg.file)
               {
                  case "file://config.xml":
                     if(!langAllMsg.success)
                     {
                        throw new BeriliaError("Impossible de charger " + langAllMsg.file);
                     }
                     if(Dofus.getInstance().forcedLang)
                     {
                        LangManager.getInstance().setEntry("config.lang.current",Dofus.getInstance().forcedLang);
                     }
                     lang = CommandLineArguments.getInstance().getArgument("lang");
                     if(lang)
                     {
                        LangManager.getInstance().setEntry("config.lang.current",lang);
                     }
                     this._aFiles = new Array();
                     this._aLoadedFiles = new Array();
                     subLangConfigFile = "config-" + LangManager.getInstance().getEntry("config.lang.current") + ".xml";
                     subCustomConfigFile = "config-custom.xml";
                     tempSubCustomConfigFile = "temp-config-custom.xml";
                     this._isSubLangConfig = File.applicationDirectory.resolvePath(subLangConfigFile).exists;
                     this._isSubCustomConfig = File.applicationDirectory.resolvePath(subCustomConfigFile).exists;
                     this._isTemporaryCustomConfig = File.applicationDirectory.resolvePath(tempSubCustomConfigFile).exists;
                     this._subConfigCount = 0;
                     _log.debug("checking if their is any custom config file");
                     if(this._isSubLangConfig || this._isSubCustomConfig || this._isTemporaryCustomConfig)
                     {
                        _log.debug("their is some custome config files");
                        if(this._isSubLangConfig)
                        {
                           LangManager.getInstance().loadFile(subLangConfigFile);
                           this._subConfigCount++;
                        }
                        if(this._isSubCustomConfig)
                        {
                           LangManager.getInstance().loadFile(subCustomConfigFile);
                           this._subConfigCount++;
                        }
                        else if(this._isTemporaryCustomConfig)
                        {
                           _log.debug("using temporary custom config file");
                           LangManager.getInstance().loadFile(tempSubCustomConfigFile);
                           this._subConfigCount++;
                        }
                        this.setModulePercent("config",50);
                     }
                     else
                     {
                        this._aModuleInit["config"] = true;
                        this.setModulePercent("config",100);
                        this.initAfterLoadConfig();
                     }
                     break;
                  default:
                     if(langAllMsg.file.indexOf("colors.xml") != -1)
                     {
                        if(!langAllMsg.success)
                        {
                           throw new BeriliaError("Impossible de charger " + langAllMsg.file);
                        }
                        XmlConfig.getInstance().addCategory(LangManager.getInstance().getCategory("colors"));
                        this._aModuleInit["colors"] = true;
                        this.setModulePercent("colors",100);
                        this._loadingScreen.value = this._loadingScreen.value + this._percentPerModule;
                        break;
                     }
                     if(langAllMsg.file.indexOf("config-") != -1)
                     {
                        try
                        {
                           xmlPos = langAllMsg.file.lastIndexOf(".xml");
                           fileNamePos = langAllMsg.file.lastIndexOf("config-");
                           catName = langAllMsg.file.substring(fileNamePos,xmlPos);
                           newValues = LangManager.getInstance().getCategory(catName);
                           for(key in newValues)
                           {
                              keyInfo = key.split(".");
                              keyInfo[0] = "config";
                              oldKey = keyInfo.join(".");
                              XmlConfig.getInstance().setEntry(oldKey,newValues[key]);
                              LangManager.getInstance().setEntry(oldKey,newValues[key]);
                           }
                        }
                        catch(e:Error)
                        {
                           throw e;
                        }
                        this._subConfigCount--;
                        if(!this._subConfigCount)
                        {
                           this.setModulePercent("config",100);
                           this._aModuleInit["config"] = true;
                           this.initAfterLoadConfig();
                           this.checkInit();
                        }
                     }
                     else
                     {
                        this._aLoadedFiles.push(langAllMsg.file);
                     }
                     this._aModuleInit["langFiles"] = this._aLoadedFiles.length == this._aFiles.length && XmlConfig.getInstance().getEntry("config.data.path.i18n.list");
                     if(this._aModuleInit["langFiles"])
                     {
                        this.setModulePercent("langFiles",100);
                        this.initFonts();
                        I18nUpdater.getInstance().addEventListener(Event.COMPLETE,this.onI18nReady);
                        I18nUpdater.getInstance().addEventListener(FileEvent.ERROR,this.onDataFileError);
                        I18nUpdater.getInstance().addEventListener(LangFileEvent.COMPLETE,this.onI18nPartialDataReady);
                        GameDataUpdater.getInstance().addEventListener(Event.COMPLETE,this.onGameDataReady);
                        GameDataUpdater.getInstance().addEventListener(FileEvent.ERROR,this.onDataFileError);
                        GameDataUpdater.getInstance().addEventListener(LangFileEvent.COMPLETE,this.onGameDataPartialDataReady);
                        lastLang = StoreDataManager.getInstance().getData(Constants.DATASTORE_LANG_VERSION,"lastLang");
                        resetLang = lastLang != XmlConfig.getInstance().getEntry("config.lang.current");
                        if(resetLang)
                        {
                           UiRenderManager.getInstance().clearCache();
                        }
                        currentCommunity = XmlConfig.getInstance().getEntry("config.community.current");
                        if(currentCommunity && currentCommunity.charAt(0) != "!")
                        {
                           overrideFile = new Uri(XmlConfig.getInstance().getEntry("config.data.path.root") + "com/" + currentCommunity + ".xml");
                        }
                        I18nUpdater.getInstance().initI18n(XmlConfig.getInstance().getEntry("config.lang.current"),new Uri(XmlConfig.getInstance().getEntry("config.data.path.i18n.list")),resetLang,overrideFile);
                        GameDataUpdater.getInstance().init(new Uri(XmlConfig.getInstance().getEntry("config.data.path.common.list")));
                     }
                     this.checkInit();
                     break;
               }
               return true;
            case msg is AllModulesLoadedMessage:
               this._aModuleInit["modules"] = true;
               this._loadingScreen.log("Launch main modules scripts",LoadingScreen.IMPORTANT);
               this.setModulePercent("modules",100);
               if(!_fhct && BuildInfos.BUILD_VERSION.buildType < BuildTypeEnum.INTERNAL && !AirScanner.isStreamingVersion())
               {
                  _fhct = new FolderHashChecker(new Uri(ThemeManager.getInstance().themesRoot.nativePath + "/" + ThemeManager.OFFICIAL_THEME_NAME + "/signature.xmls"),this.onFolderHashCheckInit);
                  _fhct.addEventListener(ErrorEvent.ERROR,function(param1:ErrorEvent):void
                  {
                     _loadingScreen.log("Error with selected UI theme : " + param1.text,LoadingScreen.ERROR);
                     _log.error("Error with selected UI theme : " + param1.text);
                  });
               }
               else
               {
                  this._aModuleInit["uiThemeCheck"] = true;
                  this.setModulePercent("uiThemeCheck",100);
               }
               this.checkInit();
               return true;
            case msg is ModuleLoadedMessage:
               this.setModulePercent("modules",this._percentPerModule * 1 / UiModuleManager.getInstance().moduleCount,true);
               ankamaModule = UiModuleManager.getInstance().getModule(ModuleLoadedMessage(msg).moduleName).trusted;
               this._loadingScreen.log(ModuleLoadedMessage(msg).moduleName + " script loaded " + (!!ankamaModule?"":"UNTRUSTED module"),!!ankamaModule?uint(LoadingScreen.IMPORTANT):uint(LoadingScreen.WARNING));
               return true;
            case msg is UiXmlParsedMessage:
               this._loadingScreen.log("Preparsing " + UiXmlParsedMessage(msg).url,LoadingScreen.INFO);
               this.setModulePercent("uiXmlParsing",this._percentPerModule * 1 / UiModuleManager.getInstance().unparsedXmlCount,true);
               return true;
            case msg is UiXmlParsedErrorMessage:
               this._loadingScreen.log("Error while parsing  " + UiXmlParsedErrorMessage(msg).url + " : " + UiXmlParsedErrorMessage(msg).msg,LoadingScreen.ERROR);
               this.setModulePercent("uiXmlParsing",this._percentPerModule * 1 / UiModuleManager.getInstance().unparsedXmlCount,true);
               return true;
            case msg is AllUiXmlParsedMessage:
               this._aModuleInit["uiXmlParsing"] = true;
               this.setModulePercent("uiXmlParsing",100);
               this.checkInit();
               return true;
            case msg is ModuleExecErrorMessage:
               this._loadingScreen.log("Error while executing " + ModuleExecErrorMessage(msg).moduleName + "\'s main script :\n" + ModuleExecErrorMessage(msg).stackTrace,LoadingScreen.ERROR);
               return true;
            case msg is ModuleRessourceLoadFailedMessage:
               mrlfm = msg as ModuleRessourceLoadFailedMessage;
               this._loadingScreen.log("Module " + mrlfm.moduleName + " : Cannot load " + mrlfm.uri,!!mrlfm.isImportant?uint(LoadingScreen.ERROR):uint(LoadingScreen.WARNING));
               return true;
            case msg is ThemeLoadedMessage:
               this._loadingScreen.log("Theme \"" + ThemeLoadedMessage(msg).themeName + "\" loaded",LoadingScreen.IMPORTANT);
               return true;
            case msg is ThemeLoadErrorMessage:
               this._loadingScreen.log(ThemeLoadErrorMessage(msg).themeName + " theme load failed : " + ThemeLoadErrorMessage(msg).themeName + ".dt cannot be found. If this file exists, maybe it contains an error.",LoadingScreen.ERROR);
               return true;
            case msg is NoThemeErrorMessage:
               this._loadingScreen.log(I18n.getUiText("ui.popup.noTheme"),LoadingScreen.ERROR);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(this._skinChangePop)
         {
            this._skinChangePop.destroy();
            this._skinChangePop = null;
         }
         if(AirScanner.isStreamingVersion())
         {
            Dofus.getInstance().strLoaderComplete();
         }
         this._loadingScreen.parent.removeChild(this._loadingScreen);
         this._loadingScreen = null;
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.nativeWindow.visible = true;
         }
         StageShareManager.testQuality();
         EmbedFontManager.getInstance().removeEventListener(Event.COMPLETE,this.onFontsManagerInit);
         I18nUpdater.getInstance().removeEventListener(Event.COMPLETE,this.onI18nReady);
         I18nUpdater.getInstance().removeEventListener(LangFileEvent.COMPLETE,this.onI18nPartialDataReady);
         GameDataUpdater.getInstance().removeEventListener(Event.COMPLETE,this.onGameDataReady);
         GameDataUpdater.getInstance().removeEventListener(LangFileEvent.COMPLETE,this.onGameDataPartialDataReady);
         return true;
      }
      
      public function updateLoadingScreenSize() : void
      {
         this._loadingScreen.refreshSize();
      }
      
      private function onFolderHashCheckInit() : void
      {
         if(!_loc2_)
         {
            _log.debug("onFolderHashCheckInit");
            if(_loc1_)
            {
               if(!_loc2_)
               {
               }
               this._aModuleInit["uiThemeCheck"] = true;
               if(!_loc1_)
               {
               }
               loop0:
               while(_loc2_)
               {
                  while(true)
                  {
                     §§push(this);
                     §§push("uiThemeCheck");
                     §§push(100);
                     if(!_loc1_)
                     {
                        §§push(§§pop() + 3 + 1 - 1);
                     }
                     §§pop().setModulePercent(§§pop(),§§pop());
                     if(!_loc1_)
                     {
                        loop1:
                        while(true)
                        {
                           this.checkInit();
                           if(_loc1_)
                           {
                              continue loop0;
                           }
                           addr65:
                           while(true)
                           {
                              if(_loc2_)
                              {
                                 break loop0;
                              }
                              continue loop1;
                           }
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
               }
               return;
            }
            §§goto(addr36);
         }
         §§goto(addr65);
      }
      
      private function initAfterLoadConfig() : void
      {
         if(_loc4_)
         {
            Kernel.getInstance().postInit();
         }
         §§push(LangManager.getInstance().getEntry("config.ui.asset.fontsList"));
         if(_loc4_)
         {
            §§push(§§pop());
         }
         if(!_loc3_)
         {
            this._aFiles.push(LangManager.getInstance().getEntry("config.ui.asset.fontsList"));
         }
         §§push(0);
         if(!_loc4_)
         {
            §§push(-----§§pop() - 11);
         }
         loop0:
         while(_loc2_ < this._aFiles.length)
         {
            if(_loc3_)
            {
               loop1:
               while(true)
               {
                  §§push(_loc2_);
                  if(!_loc3_)
                  {
                     §§push(uint(§§pop() + 1));
                  }
                  if(!_loc3_)
                  {
                     if(!_loc3_)
                     {
                        continue loop0;
                     }
                  }
                  addr77:
                  while(true)
                  {
                     if(!_loc4_)
                     {
                        break loop1;
                     }
                     continue loop1;
                  }
               }
               continue;
            }
            while(true)
            {
               FontManager.getInstance().loadFile(this._aFiles[_loc2_]);
               §§goto(addr77);
            }
         }
         if(!_loc3_)
         {
            if(_loc4_)
            {
            }
            §§push(this._loadingScreen);
            §§push(this._loadingScreen.value);
            if(_loc4_)
            {
               §§push(§§pop() + this._percentPerModule);
            }
            §§pop().value = §§pop();
            if(_loc3_)
            {
               addr111:
               while(true)
               {
                  this.initTubul();
                  if(!_loc3_)
                  {
                  }
                  break;
               }
               §§push(SoundManager.getInstance().manager is ClassicSoundManager);
               if(_loc4_)
               {
                  if(!§§pop())
                  {
                     if(!_loc3_)
                     {
                     }
                     Berilia.getInstance().addUIListener(SoundManager.getInstance().manager);
                     if(_loc3_)
                     {
                        addr150:
                        while(true)
                        {
                           TiphonEventsManager.addListener(SoundManager.getInstance().manager,"DataSound");
                           if(_loc4_)
                           {
                              if(!_loc3_)
                              {
                              }
                           }
                           break;
                        }
                        return;
                     }
                     while(true)
                     {
                        TiphonEventsManager.addListener(SoundManager.getInstance().manager,"Sound");
                        if(_loc4_)
                        {
                           if(_loc4_)
                           {
                              §§goto(addr150);
                           }
                        }
                        break;
                     }
                     if(!_loc3_)
                     {
                     }
                     §§push(CommandLineArguments.getInstance().hasArgument("functional-test"));
                  }
                  this.initTheme();
                  §§goto(addr180);
               }
               if(!§§pop())
               {
                  if(!_loc3_)
                  {
                  }
                  CustomLoadingScreenManager.getInstance().loadCustomScreenList(StoreDataManager.getInstance().getData(Constants.DATASTORE_COMPUTER_OPTIONS,"lastNickname"));
               }
               §§goto(addr205);
            }
            while(true)
            {
               KernelEventsManager.getInstance().processCallback(HookList.ConfigStart);
            }
         }
         while(true)
         {
            if(!_loc3_)
            {
               §§goto(addr111);
            }
            §§goto(addr129);
         }
      }
      
      private function initTheme() : void
      {
         if(_loc3_)
         {
            var currentLang:String = null;
            if(!_loc4_)
            {
            }
            var titleText:String = null;
            if(_loc4_)
            {
               addr37:
               while(true)
               {
                  ThemeManager.getInstance().init(officialthemesPath,customthemesPath,BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE);
                  if(!_loc3_)
                  {
                     addr55:
                     while(true)
                     {
                        var officialthemesPath:String = File.applicationDirectory.nativePath + File.separator + LangManager.getInstance().getEntry("config.ui.common.themes").replace("file://","");
                     }
                  }
                  break;
               }
               ThemeManager.getInstance().applyTheme(OptionManager.getOptionManager("dofus").currentUiSkin);
               if(_loc3_)
               {
               }
               if(OptionManager.getOptionManager("dofus").currentUiSkin != ThemeManager.OFFICIAL_THEME_NAME)
               {
                  currentLang = XmlConfig.getInstance().getEntry("config.lang.current");
                  §§push("fr");
                  if(!_loc4_)
                  {
                     §§push(_loc2_);
                     if(_loc3_)
                     {
                        if(§§pop() === §§pop())
                        {
                           if(!_loc4_)
                           {
                              §§push(0);
                              if(_loc4_)
                              {
                                 §§push(§§pop() * 67 * 40 + 92);
                              }
                              if(_loc4_)
                              {
                                 addr435:
                              }
                           }
                           addr526:
                           loop21:
                           switch(§§pop())
                           {
                              case 0:
                                 if(!_loc3_)
                                 {
                                    addr164:
                                    while(true)
                                    {
                                       var contentText:String = "Vous n\'utilisez pas le thème d\'interface officiel. Si vous rencontrez un problème avec, vous pouvez utiliser le bouton ci-dessous pour remettre en place le thème par défaut.";
                                       if(!_loc4_)
                                       {
                                       }
                                       break;
                                    }
                                    var btnText:String = "Rétablir le thème par défaut";
                                    if(_loc3_)
                                    {
                                    }
                                    this._skinChangePop = new SystemPopupUI("skinChangePopup");
                                    if(!_loc3_)
                                    {
                                       while(true)
                                       {
                                          §§push(this._skinChangePop);
                                          §§push(-400);
                                          if(_loc4_)
                                          {
                                             §§push(§§pop() + 104 + 36 - 17);
                                          }
                                          §§pop().y = §§pop();
                                          if(_loc4_)
                                          {
                                             addr556:
                                             while(true)
                                             {
                                                this._skinChangePop.buttons = [{
                                                   "label":btnText,
                                                   "callback":function():void
                                                   {
                                                      var _loc1_:Boolean = true;
                                                      var _loc2_:Boolean = false;
                                                      OptionManager.getOptionManager("dofus").currentUiSkin = ThemeManager.OFFICIAL_THEME_NAME;
                                                      if(_loc1_)
                                                      {
                                                         Dofus.getInstance().clearCache(true,true);
                                                      }
                                                   }
                                                }];
                                                if(_loc3_)
                                                {
                                                   break;
                                                }
                                             }
                                             continue;
                                          }
                                          break;
                                       }
                                       this._skinChangePop.show();
                                       if(_loc3_)
                                       {
                                       }
                                       return;
                                    }
                                    while(true)
                                    {
                                       this._skinChangePop.title = titleText;
                                       if(!_loc4_)
                                       {
                                       }
                                       this._skinChangePop.content = contentText;
                                       if(_loc3_)
                                       {
                                          §§goto(addr556);
                                       }
                                       §§goto(addr596);
                                    }
                                 }
                                 while(true)
                                 {
                                    titleText = "Thème d\'interface personnalisé";
                                    if(!_loc4_)
                                    {
                                       if(!_loc4_)
                                       {
                                          §§goto(addr164);
                                       }
                                       §§goto(addr184);
                                    }
                                    else
                                    {
                                       break loop21;
                                    }
                                 }
                                 §§goto(addr528);
                              case 1:
                                 if(!_loc4_)
                                 {
                                 }
                                 titleText = "Tema de interfaz personalizado";
                                 if(_loc3_)
                                 {
                                    if(!_loc4_)
                                    {
                                    }
                                    contentText = "No estás utilizando el tema de interfaz oficial. Si se produce algún problema con él, utiliza el botón que ves abajo para restablecer el tema predeterminado.";
                                    if(!_loc4_)
                                    {
                                    }
                                    btnText = "Restablecer el tema predeterminado";
                                    if(_loc3_)
                                    {
                                    }
                                    §§goto(addr528);
                                 }
                                 §§goto(addr533);
                              case 2:
                                 if(_loc4_)
                                 {
                                    while(true)
                                    {
                                       btnText = "Standarddesign wiederherstellen";
                                       if(_loc4_)
                                       {
                                          addr246:
                                          while(true)
                                          {
                                             contentText = "Ihr verwendet nicht das offizielle Design für die Benutzeroberfläche. Wenn damit ein Problem auftreten sollte, könnt ihr mithilfe der nachfolgenden Schaltfläche wieder das standardmäßige Design einstellen.";
                                             if(_loc3_)
                                             {
                                                if(_loc3_)
                                                {
                                                   break;
                                                }
                                             }
                                             else
                                             {
                                                break loop21;
                                             }
                                          }
                                          continue;
                                       }
                                       break;
                                    }
                                    §§goto(addr528);
                                 }
                                 while(true)
                                 {
                                    titleText = "Benutzerdefiniertes Design für die Benutzeroberfläche";
                                    if(!_loc4_)
                                    {
                                       §§goto(addr246);
                                    }
                                    §§goto(addr266);
                                 }
                              case 3:
                                 if(!_loc4_)
                                 {
                                 }
                                 addr275:
                                 titleText = "Tema di interfaccia personalizzato";
                                 if(!_loc3_)
                                 {
                                    addr283:
                                    while(true)
                                    {
                                       btnText = "Ripristina il tema di base";
                                       if(_loc3_)
                                       {
                                       }
                                       addr307:
                                       §§goto(addr528);
                                    }
                                 }
                                 while(true)
                                 {
                                    contentText = "Non stai utilizzando il tema ufficiale per le interfacce. Se riscontri un problema puoi usare il pulsante sottostante per ripristinare il tema di base.";
                                    if(_loc3_)
                                    {
                                       break loop21;
                                    }
                                    break;
                                    §§goto(addr275);
                                 }
                                 §§goto(addr599);
                              case 4:
                                 if(!_loc3_)
                                 {
                                    addr316:
                                    while(true)
                                    {
                                       btnText = "Restaurar o tema padrão";
                                       if(!_loc4_)
                                       {
                                       }
                                       break;
                                    }
                                    §§goto(addr528);
                                 }
                                 while(true)
                                 {
                                    titleText = "Tema de interface personalizado";
                                    if(!_loc4_)
                                    {
                                    }
                                    contentText = "Você não está usando o tema de interface oficial. Se encontrar um problema, você pode usar o botão abaixo para restaurar o tema padrão.";
                                    if(!_loc4_)
                                    {
                                       §§goto(addr316);
                                    }
                                    §§goto(addr341);
                                 }
                              case 5:
                                 if(!_loc4_)
                                 {
                                 }
                              default:
                                 if(_loc4_)
                                 {
                                    addr356:
                                    while(true)
                                    {
                                       contentText = "You\'re not using the official interface theme. If you run in to a problem with the theme, you can use the button below to restore the default theme.";
                                       if(!_loc4_)
                                       {
                                       }
                                       btnText = "Restore the default theme";
                                       if(_loc3_)
                                       {
                                       }
                                       break;
                                    }
                                    §§goto(addr528);
                                 }
                                 while(true)
                                 {
                                    titleText = "Personalized theme interface";
                                    if(_loc3_)
                                    {
                                       §§goto(addr356);
                                    }
                                    §§goto(addr381);
                                 }
                           }
                           while(true)
                           {
                              if(_loc4_)
                              {
                                 break;
                              }
                              §§goto(addr283);
                           }
                           §§goto(addr307);
                        }
                        else
                        {
                           §§push("es");
                           if(!_loc4_)
                           {
                              §§push(_loc2_);
                              if(!_loc4_)
                              {
                                 if(§§pop() === §§pop())
                                 {
                                    §§push(1);
                                    if(_loc4_)
                                    {
                                       §§push((§§pop() + 1 + 48 + 39 - 1) * 52 + 7 - 1);
                                    }
                                    §§goto(addr435);
                                 }
                                 else
                                 {
                                    §§push("de");
                                    if(!_loc3_)
                                    {
                                    }
                                    addr482:
                                    §§push(_loc2_);
                                    addr501:
                                    if(_loc4_)
                                    {
                                    }
                                    if(§§pop() === §§pop())
                                    {
                                       §§push(5);
                                       if(!_loc3_)
                                       {
                                          §§push(-(((§§pop() + 1) * 106 + 1) * 22));
                                       }
                                    }
                                    else
                                    {
                                       §§push(6);
                                       if(_loc4_)
                                       {
                                          §§push((-(§§pop() * 44) + 25) * 68);
                                       }
                                    }
                                 }
                                 §§goto(addr526);
                              }
                              addr443:
                              if(§§pop() === §§pop())
                              {
                                 §§push(2);
                                 if(!_loc3_)
                                 {
                                    §§push(-(§§pop() + 1 + 1 + 104 + 1 - 73) - 20);
                                 }
                              }
                              else
                              {
                                 §§push("it");
                                 if(!_loc4_)
                                 {
                                    §§push(_loc2_);
                                    if(_loc3_)
                                    {
                                       if(§§pop() === §§pop())
                                       {
                                          §§push(3);
                                          if(_loc4_)
                                          {
                                             §§push(--(§§pop() + 65 - 1 + 1) * 112);
                                          }
                                       }
                                       else
                                       {
                                          §§push("pt");
                                          if(_loc3_)
                                          {
                                             §§goto(addr482);
                                          }
                                       }
                                    }
                                    §§goto(addr501);
                                 }
                              }
                              §§goto(addr526);
                           }
                           §§push(_loc2_);
                           if(!_loc4_)
                           {
                              §§goto(addr443);
                           }
                        }
                        addr486:
                        §§push(4);
                        if(_loc4_)
                        {
                           §§push(§§pop() + 1 + 40 + 46 - 51 - 95);
                        }
                        §§goto(addr526);
                     }
                     if(§§pop() === §§pop())
                     {
                        §§goto(addr486);
                     }
                     else
                     {
                        §§push("en");
                     }
                     §§goto(addr526);
                  }
                  §§goto(addr501);
                  §§push(_loc2_);
               }
               §§goto(addr604);
            }
            addr78:
            while(true)
            {
               contentText = null;
               if(!_loc3_)
               {
                  addr87:
                  while(true)
                  {
                     §§push(_loc1_);
                     §§push(CustomSharedObject.getCustomSharedObjectDirectory());
                     if(!_loc4_)
                     {
                        §§push(§§pop() + File.separator + "ui");
                        if(!_loc4_)
                        {
                           §§push(§§pop() + File.separator);
                           if(!_loc4_)
                           {
                              §§push(§§pop() + "themes");
                              if(!_loc3_)
                              {
                              }
                           }
                           §§push(§§pop() + File.separator);
                        }
                        §§push(§§pop());
                     }
                     var /*UnknownSlot*/:* = §§pop();
                     if(_loc3_)
                     {
                        if(!_loc4_)
                        {
                           §§goto(addr55);
                        }
                        §§goto(addr134);
                     }
                     break;
                  }
                  §§goto(addr141);
               }
               while(true)
               {
                  btnText = null;
                  if(_loc4_)
                  {
                     §§goto(addr134);
                  }
                  else
                  {
                     §§goto(addr87);
                  }
                  §§goto(addr141);
               }
            }
         }
         while(true)
         {
            if(!_loc3_)
            {
               §§goto(addr78);
            }
            else
            {
               §§goto(addr37);
            }
            §§goto(addr55);
         }
      }
      
      private function initPerformancesWatcher() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = true;
         if(!_loc1_)
         {
            DofusFpsManager.init();
            if(_loc2_)
            {
               FpsControler.Init(ScriptedAnimation);
            }
         }
      }
      
      private function initStaticConstants() : void
      {
         HookList.AuthenticationTicket;
         if(!_loc1_)
         {
            addr20:
            while(true)
            {
               PrismHookList.PrismsList;
               if(_loc2_)
               {
                  loop1:
                  while(true)
                  {
                     InventoryHookList.BankViewContent;
                     if(!_loc1_)
                     {
                        loop2:
                        while(true)
                        {
                           ApiRolePlayActionList.PlayerFightFriendlyAnswer;
                           if(!_loc1_)
                           {
                              addr47:
                              while(true)
                              {
                                 MountHookList.CertificateMountData;
                                 if(_loc2_)
                                 {
                                    loop4:
                                    while(true)
                                    {
                                       RoleplayHookList.PlayerFightRequestSent;
                                       if(!_loc1_)
                                       {
                                          loop5:
                                          while(true)
                                          {
                                             ApiChatActionList.ChannelEnabling;
                                             if(!_loc2_)
                                             {
                                             }
                                             loop6:
                                             while(true)
                                             {
                                                ApiCraftActionList.JobCrafterDirectoryDefineSettings;
                                                if(_loc1_)
                                                {
                                                   if(!_loc1_)
                                                   {
                                                      addr131:
                                                      while(true)
                                                      {
                                                         ApiLivingObjectActionList.LivingObjectChangeSkinRequest;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      addr82:
                                                      while(true)
                                                      {
                                                         ApiSocialActionList.FriendsListRequest;
                                                         if(!_loc2_)
                                                         {
                                                            break loop6;
                                                         }
                                                      }
                                                   }
                                                   addr91:
                                                   while(true)
                                                   {
                                                      TriggerHookList.CreaturesMode;
                                                      if(_loc1_)
                                                      {
                                                      }
                                                      addr219:
                                                      while(true)
                                                      {
                                                         CustomUiHookList.ActivateSound;
                                                         addr226:
                                                         while(_loc2_)
                                                         {
                                                         }
                                                         continue loop4;
                                                      }
                                                   }
                                                }
                                                loop11:
                                                while(!_loc1_)
                                                {
                                                   while(true)
                                                   {
                                                      SocialHookList.AttackPlayer;
                                                      if(!_loc1_)
                                                      {
                                                         addr149:
                                                         loop13:
                                                         while(true)
                                                         {
                                                            ExternalGameHookList.DofusShopMoney;
                                                            if(!_loc1_)
                                                            {
                                                               loop14:
                                                               while(true)
                                                               {
                                                                  FightHookList.AfkModeChanged;
                                                                  if(!_loc1_)
                                                                  {
                                                                     addr166:
                                                                     while(true)
                                                                     {
                                                                        CraftHookList.ExchangeStartOkCraft;
                                                                        if(_loc2_)
                                                                        {
                                                                           break loop14;
                                                                        }
                                                                        addr108:
                                                                        while(true)
                                                                        {
                                                                           ExchangeHookList.AskExchangeMoveObject;
                                                                           if(_loc2_)
                                                                           {
                                                                              continue loop6;
                                                                           }
                                                                           continue loop14;
                                                                        }
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     continue loop1;
                                                                  }
                                                               }
                                                            }
                                                            while(true)
                                                            {
                                                               ApiActionList.AuthorizedCommand;
                                                               if(!_loc2_)
                                                               {
                                                                  if(!_loc1_)
                                                                  {
                                                                     loop15:
                                                                     while(true)
                                                                     {
                                                                        ApiMountActionList.MountFeedRequest;
                                                                        if(_loc1_)
                                                                        {
                                                                           if(!_loc2_)
                                                                           {
                                                                              §§goto(addr131);
                                                                           }
                                                                        }
                                                                        addr234:
                                                                        while(true)
                                                                        {
                                                                           if(!_loc1_)
                                                                           {
                                                                              break loop15;
                                                                           }
                                                                           continue loop15;
                                                                        }
                                                                     }
                                                                     break loop11;
                                                                  }
                                                                  break loop13;
                                                               }
                                                               §§goto(addr226);
                                                            }
                                                         }
                                                         continue loop5;
                                                      }
                                                      §§goto(addr91);
                                                      §§goto(addr219);
                                                   }
                                                }
                                                return;
                                             }
                                             continue loop2;
                                          }
                                       }
                                       addr203:
                                       while(true)
                                       {
                                          CraftHookList.DoNothing;
                                          if(_loc1_)
                                          {
                                          }
                                          §§goto(addr149);
                                       }
                                    }
                                 }
                                 while(true)
                                 {
                                    QuestHookList.QuestInfosUpdated;
                                    if(!_loc1_)
                                    {
                                       §§goto(addr203);
                                    }
                                    §§goto(addr140);
                                 }
                              }
                           }
                           while(true)
                           {
                              ApiExchangeActionList.BidHouseStringSearch;
                              §§goto(addr234);
                           }
                        }
                     }
                     while(true)
                     {
                        LivingObjectHookList.LivingObjectAssociate;
                        if(!_loc1_)
                        {
                           §§goto(addr219);
                        }
                        §§goto(addr47);
                     }
                  }
               }
               addr100:
               while(true)
               {
                  AlignmentHookList.AlignmentAreaUpdate;
                  if(_loc2_)
                  {
                     §§goto(addr108);
                  }
                  §§goto(addr166);
               }
            }
         }
         while(true)
         {
            ChatHookList.ShowObjectLinked;
            if(_loc2_)
            {
               §§goto(addr82);
            }
            else
            {
               §§goto(addr20);
            }
            §§goto(addr100);
         }
      }
      
      private function initModulesBindings() : void
      {
         if(_loc2_)
         {
            ApiBinder.addApi("Ui",UiApi);
            if(_loc1_)
            {
               loop0:
               while(true)
               {
                  MenusFactory.registerAssoc(GameRolePlayPortalInformations,"portal");
                  if(_loc1_)
                  {
                     loop1:
                     while(true)
                     {
                        HyperlinkFactory.registerProtocol("map",HyperlinkMapPosition.showPosition,HyperlinkMapPosition.getText,null,true,HyperlinkMapPosition.rollOver);
                        if(_loc1_)
                        {
                           loop2:
                           while(true)
                           {
                              ApiBinder.addApi("Util",UtilApi);
                              if(!_loc2_)
                              {
                                 loop3:
                                 while(true)
                                 {
                                    TooltipsFactory.registerAssoc(EffectsWrapper,"effects");
                                    if(_loc2_)
                                    {
                                       if(_loc1_)
                                       {
                                          loop4:
                                          while(true)
                                          {
                                             ApiBinder.addApi("Tooltip",TooltipApi);
                                             if(_loc1_)
                                             {
                                                addr84:
                                                while(true)
                                                {
                                                   MenusFactory.registerAssoc(GameRolePlayMountInformations,"mount");
                                                   if(_loc2_)
                                                   {
                                                      if(!_loc2_)
                                                      {
                                                         loop6:
                                                         while(true)
                                                         {
                                                            HyperlinkFactory.registerProtocol("chatmonster",HyperlinkShowMonsterChatManager.showMonster,HyperlinkShowMonsterChatManager.getMonsterName,null,true,HyperlinkShowMonsterChatManager.rollOver);
                                                            if(_loc1_)
                                                            {
                                                               loop7:
                                                               while(true)
                                                               {
                                                                  TooltipsFactory.registerAssoc(SpellTooltipInfo,"spellBanner");
                                                                  if(!_loc2_)
                                                                  {
                                                                     loop8:
                                                                     while(true)
                                                                     {
                                                                        ApiBinder.addApi("Party",PartyApi);
                                                                        if(!_loc1_)
                                                                        {
                                                                        }
                                                                        loop9:
                                                                        while(true)
                                                                        {
                                                                           ApiBinder.addApi("Highlight",HighlightApi);
                                                                           if(!_loc2_)
                                                                           {
                                                                              loop10:
                                                                              while(true)
                                                                              {
                                                                                 MenusFactory.registerAssoc(MountWrapper,"mount");
                                                                                 if(_loc2_)
                                                                                 {
                                                                                    if(!_loc2_)
                                                                                    {
                                                                                       loop11:
                                                                                       while(true)
                                                                                       {
                                                                                          MenusFactory.registerAssoc(ItemWrapper,"item");
                                                                                          if(_loc1_)
                                                                                          {
                                                                                             addr828:
                                                                                             while(true)
                                                                                             {
                                                                                                HyperlinkFactory.registerProtocol("monster",HyperlinkShowMonsterManager.showMonster,HyperlinkShowMonsterManager.getMonsterName);
                                                                                                loop13:
                                                                                                while(true)
                                                                                                {
                                                                                                   if(!_loc1_)
                                                                                                   {
                                                                                                   }
                                                                                                   loop14:
                                                                                                   while(true)
                                                                                                   {
                                                                                                      HyperlinkFactory.registerProtocol("monsterFight",HyperlinkShowMonsterFightManager.showEntity,null,null,true,HyperlinkShowMonsterFightManager.rollOver);
                                                                                                      if(!_loc2_)
                                                                                                      {
                                                                                                         loop15:
                                                                                                         while(true)
                                                                                                         {
                                                                                                            ApiBinder.addApi("Connection",ConnectionApi);
                                                                                                            if(!_loc2_)
                                                                                                            {
                                                                                                               loop16:
                                                                                                               while(true)
                                                                                                               {
                                                                                                                  TooltipsFactory.registerAssoc(GameRolePlayCharacterInformations,"player");
                                                                                                                  if(_loc1_)
                                                                                                                  {
                                                                                                                     loop17:
                                                                                                                     while(true)
                                                                                                                     {
                                                                                                                        ApiBinder.addApi("Time",TimeApi);
                                                                                                                        if(!_loc1_)
                                                                                                                        {
                                                                                                                           if(_loc1_)
                                                                                                                           {
                                                                                                                              loop18:
                                                                                                                              while(true)
                                                                                                                              {
                                                                                                                                 MenusFactory.registerAssoc(GameRolePlayPrismInformations,"prism");
                                                                                                                                 if(_loc2_)
                                                                                                                                 {
                                                                                                                                    loop19:
                                                                                                                                    while(_loc1_)
                                                                                                                                    {
                                                                                                                                       loop20:
                                                                                                                                       while(true)
                                                                                                                                       {
                                                                                                                                          TooltipsFactory.registerAssoc(PrismTooltipInformation,"prism");
                                                                                                                                          if(!_loc1_)
                                                                                                                                          {
                                                                                                                                          }
                                                                                                                                          addr373:
                                                                                                                                          while(true)
                                                                                                                                          {
                                                                                                                                             TooltipsFactory.registerAssoc(PortalTooltipInformation,"portal");
                                                                                                                                             if(_loc2_)
                                                                                                                                             {
                                                                                                                                                if(!_loc2_)
                                                                                                                                                {
                                                                                                                                                   addr385:
                                                                                                                                                   while(true)
                                                                                                                                                   {
                                                                                                                                                      HyperlinkFactory.registerProtocol("chatdare",HyperlinkShowDareChatManager.showDare,HyperlinkShowDareChatManager.getDareName,null,true,HyperlinkShowDareChatManager.rollOver);
                                                                                                                                                      if(!_loc2_)
                                                                                                                                                      {
                                                                                                                                                         loop23:
                                                                                                                                                         while(true)
                                                                                                                                                         {
                                                                                                                                                            HyperlinkFactory.registerProtocol("spell",HyperlinkSpellManager.showSpell,HyperlinkSpellManager.getSpellLevelName);
                                                                                                                                                            if(!_loc2_)
                                                                                                                                                            {
                                                                                                                                                               break;
                                                                                                                                                            }
                                                                                                                                                            loop24:
                                                                                                                                                            while(true)
                                                                                                                                                            {
                                                                                                                                                               HyperlinkFactory.registerProtocol("spellNoLvl",HyperlinkSpellManager.showSpellNoLevel,HyperlinkSpellManager.getSpellName);
                                                                                                                                                               if(_loc1_)
                                                                                                                                                               {
                                                                                                                                                                  loop25:
                                                                                                                                                                  while(true)
                                                                                                                                                                  {
                                                                                                                                                                     TooltipsFactory.registerAssoc(GameRolePlayNpcInformations,"npc");
                                                                                                                                                                     if(!_loc2_)
                                                                                                                                                                     {
                                                                                                                                                                        addr332:
                                                                                                                                                                        while(true)
                                                                                                                                                                        {
                                                                                                                                                                           ApiBinder.addApi("Security",SecurityApi);
                                                                                                                                                                           if(_loc1_)
                                                                                                                                                                           {
                                                                                                                                                                              addr342:
                                                                                                                                                                              while(true)
                                                                                                                                                                              {
                                                                                                                                                                                 MenusFactory.registerAssoc(GameRolePlayNpcInformations,"npc");
                                                                                                                                                                                 if(!_loc1_)
                                                                                                                                                                                 {
                                                                                                                                                                                 }
                                                                                                                                                                                 loop54:
                                                                                                                                                                                 while(true)
                                                                                                                                                                                 {
                                                                                                                                                                                    MenusFactory.registerAssoc(GameRolePlayNpcWithQuestInformations,"npc");
                                                                                                                                                                                    if(_loc1_)
                                                                                                                                                                                    {
                                                                                                                                                                                       loop108:
                                                                                                                                                                                       while(true)
                                                                                                                                                                                       {
                                                                                                                                                                                          HyperlinkFactory.registerProtocol("swapPositionRequest",HyperlinkSwapPositionRequest.showMenu,null,null,false);
                                                                                                                                                                                          loop56:
                                                                                                                                                                                          while(true)
                                                                                                                                                                                          {
                                                                                                                                                                                             if(_loc1_)
                                                                                                                                                                                             {
                                                                                                                                                                                                addr977:
                                                                                                                                                                                                while(true)
                                                                                                                                                                                                {
                                                                                                                                                                                                   TooltipsFactory.registerAssoc(CharacterTooltipInformation,"player");
                                                                                                                                                                                                   if(!_loc2_)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      addr987:
                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                      {
                                                                                                                                                                                                         ApiBinder.addApi("Data",DataApi);
                                                                                                                                                                                                         if(_loc2_)
                                                                                                                                                                                                         {
                                                                                                                                                                                                            break;
                                                                                                                                                                                                         }
                                                                                                                                                                                                      }
                                                                                                                                                                                                      continue loop17;
                                                                                                                                                                                                   }
                                                                                                                                                                                                   addr1101:
                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      TooltipsFactory.registerAssoc(MutantTooltipInformation,"mutant");
                                                                                                                                                                                                      if(_loc1_)
                                                                                                                                                                                                      {
                                                                                                                                                                                                         addr1110:
                                                                                                                                                                                                         while(true)
                                                                                                                                                                                                         {
                                                                                                                                                                                                            HyperlinkFactory.registerProtocol("cell",HyperlinkShowCellManager.showCell);
                                                                                                                                                                                                            if(_loc1_)
                                                                                                                                                                                                            {
                                                                                                                                                                                                               addr1121:
                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                               {
                                                                                                                                                                                                                  ApiBinder.addApi("ExternalNotification",ExternalNotificationApi);
                                                                                                                                                                                                                  if(_loc1_)
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                     loop62:
                                                                                                                                                                                                                     while(true)
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                        ApiBinder.addApi("Config",ConfigApi);
                                                                                                                                                                                                                        if(_loc1_)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           loop63:
                                                                                                                                                                                                                           while(true)
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              TooltipsFactory.registerAssoc(PaddockWrapper,"paddock");
                                                                                                                                                                                                                              if(_loc1_)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 addr1150:
                                                                                                                                                                                                                                 while(true)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    TooltipsFactory.registerAssoc(ChatBubble,"chatBubble");
                                                                                                                                                                                                                                    if(!_loc1_)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    addr215:
                                                                                                                                                                                                                                    while(true)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       TooltipsFactory.registerAssoc(ThinkBubble,"thinkBubble");
                                                                                                                                                                                                                                       if(_loc2_)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          if(_loc1_)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             loop66:
                                                                                                                                                                                                                                             while(true)
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                HyperlinkFactory.registerProtocol("subst",HyperlinkSubstitutionManager.openAnkabox,HyperlinkSubstitutionManager.substitute,null,true,HyperlinkItemManager.rollOver);
                                                                                                                                                                                                                                                if(!_loc2_)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   addr244:
                                                                                                                                                                                                                                                   loop67:
                                                                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      ApiBinder.addApi("Color",ColorApi);
                                                                                                                                                                                                                                                      if(_loc1_)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         addr254:
                                                                                                                                                                                                                                                         while(true)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            MenusFactory.registerAssoc(WeaponWrapper,"item");
                                                                                                                                                                                                                                                            if(_loc1_)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               addr263:
                                                                                                                                                                                                                                                               loop68:
                                                                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  TooltipsFactory.registerAssoc(TaxCollectorTooltipInformation,"taxCollector");
                                                                                                                                                                                                                                                                  if(_loc1_)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     addr273:
                                                                                                                                                                                                                                                                     while(true)
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        HyperlinkFactory.registerProtocol("chatornament",HyperlinkShowOrnamentManager.showOrnament,null,null,true,HyperlinkShowOrnamentManager.rollOver);
                                                                                                                                                                                                                                                                        if(!_loc1_)
                                                                                                                                                                                                                                                                        {
                                                                                                                                                                                                                                                                           break;
                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                     continue loop6;
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  addr1426:
                                                                                                                                                                                                                                                                  while(true)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     TooltipsFactory.registerAssoc(GameFightTaxCollectorInformations,"fightTaxCollector");
                                                                                                                                                                                                                                                                     if(_loc1_)
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        addr1435:
                                                                                                                                                                                                                                                                        while(true)
                                                                                                                                                                                                                                                                        {
                                                                                                                                                                                                                                                                           HyperlinkFactory.registerProtocol("chatLinkRelease",HyperlinkURLManager.chatLinkRelease,null,null,true,HyperlinkURLManager.rollOver);
                                                                                                                                                                                                                                                                           if(_loc2_)
                                                                                                                                                                                                                                                                           {
                                                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                                                           break;
                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                        while(true)
                                                                                                                                                                                                                                                                        {
                                                                                                                                                                                                                                                                           HyperlinkFactory.registerProtocol("chatWarning",HyperlinkURLManager.chatWarning);
                                                                                                                                                                                                                                                                           addr685:
                                                                                                                                                                                                                                                                           while(true)
                                                                                                                                                                                                                                                                           {
                                                                                                                                                                                                                                                                              if(!_loc2_)
                                                                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                                                                 addr690:
                                                                                                                                                                                                                                                                                 while(true)
                                                                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                                                                    HyperlinkFactory.registerProtocol("taxcollectorCollected",HyperlinkTaxCollectorCollected.showCollectedTaxCollector,null,null,false,HyperlinkTaxCollectorCollected.rollOver);
                                                                                                                                                                                                                                                                                    if(!_loc2_)
                                                                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                                                                       addr705:
                                                                                                                                                                                                                                                                                       while(true)
                                                                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                                                                          MenusFactory.registerAssoc(PartyCompanionWrapper,"companion");
                                                                                                                                                                                                                                                                                          addr710:
                                                                                                                                                                                                                                                                                          while(true)
                                                                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                                                                             if(!_loc2_)
                                                                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                                                                addr715:
                                                                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                                                                   TooltipsFactory.registerAssoc(DelayedActionItem,"delayedAction");
                                                                                                                                                                                                                                                                                                   if(!_loc2_)
                                                                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                                                                      addr725:
                                                                                                                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                                                                         HyperlinkFactory.registerProtocol("player",HyperlinkShowPlayerMenuManager.showPlayerMenu,HyperlinkShowPlayerMenuManager.getPlayerName,null,true,HyperlinkShowPlayerMenuManager.rollOverPlayer);
                                                                                                                                                                                                                                                                                                         if(_loc1_)
                                                                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                                                                            addr742:
                                                                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                                                                               TooltipsFactory.registerAssoc(HouseWrapper,"house");
                                                                                                                                                                                                                                                                                                               if(_loc1_)
                                                                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                                                                  break loop54;
                                                                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                         addr1267:
                                                                                                                                                                                                                                                                                                         while(true)
                                                                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                                                                            HyperlinkFactory.registerProtocol("account",HyperlinkShowAccountMenuManager.showAccountMenu,null,null,true);
                                                                                                                                                                                                                                                                                                            if(!_loc1_)
                                                                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                                            addr587:
                                                                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                                                                               HyperlinkFactory.registerProtocol("item",HyperlinkItemManager.showItem,HyperlinkItemManager.getItemName);
                                                                                                                                                                                                                                                                                                               if(_loc2_)
                                                                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                                                                  break;
                                                                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                                            continue loop1;
                                                                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                                                                   else
                                                                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                                                                      break;
                                                                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                continue loop20;
                                                                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                                                                             addr1049:
                                                                                                                                                                                                                                                                                             while(true)
                                                                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                                                                MenusFactory.registerAssoc(GameFightFighterInformations,"fightAlly");
                                                                                                                                                                                                                                                                                                if(_loc2_)
                                                                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                addr1397:
                                                                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                                                                   MenusFactory.registerAssoc(InteractiveElement,"interactiveElement");
                                                                                                                                                                                                                                                                                                   if(_loc2_)
                                                                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                                                                   addr944:
                                                                                                                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                                                                      HyperlinkFactory.registerProtocol("ui",HyperlinkDisplayArrowManager.showArrow);
                                                                                                                                                                                                                                                                                                      addr950:
                                                                                                                                                                                                                                                                                                      while(_loc1_)
                                                                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                                                                         continue loop54;
                                                                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                                                                      continue loop23;
                                                                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                    else
                                                                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                                                                       continue loop108;
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                              else
                                                                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                                                                 continue loop66;
                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                     else
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        break;
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  continue loop3;
                                                                                                                                                                                                                                                                  while(true)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     MenusFactory.registerAssoc(GameRolePlayMerchantInformations,"humanVendor");
                                                                                                                                                                                                                                                                     if(!_loc2_)
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        break loop68;
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                     break;
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  continue loop11;
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  TooltipsFactory.registerAssoc(ChallengeWrapper,"challenge");
                                                                                                                                                                                                                                                                  if(!_loc2_)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     break;
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  continue loop63;
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               continue loop24;
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            break loop67;
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         TooltipsFactory.registerAssoc(String,"text");
                                                                                                                                                                                                                                                         if(!_loc2_)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            addr609:
                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               ApiBinder.addApi("Fight",FightApi);
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                         addr1040:
                                                                                                                                                                                                                                                         while(true)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            TooltipsFactory.registerAssoc(TextTooltipInfo,"textInfo");
                                                                                                                                                                                                                                                            if(_loc1_)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               §§goto(addr1049);
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            addr567:
                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               TooltipsFactory.registerAssoc(SpellWrapper,"spell");
                                                                                                                                                                                                                                                               if(_loc1_)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  break;
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               addr1495:
                                                                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  TooltipsFactory.registerAssoc(SpellPair,"spell");
                                                                                                                                                                                                                                                                  if(_loc2_)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     break;
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               continue loop7;
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               ApiBinder.addApi("PlayedCharacter",PlayedCharacterApi);
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   continue loop10;
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                addr1326:
                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   HyperlinkFactory.registerProtocol("npc",HyperlinkShowNpcManager.showNpc);
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                          else
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             break;
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       while(!_loc2_)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          §§goto(addr587);
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       continue loop15;
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    continue loop16;
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                              while(true)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 TooltipsFactory.registerAssoc(GameFightCharacterInformations,"playerFighter");
                                                                                                                                                                                                                                 if(!_loc1_)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    if(_loc1_)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       addr1171:
                                                                                                                                                                                                                                       while(true)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          HyperlinkFactory.registerProtocol("chattitle",HyperlinkShowTitleManager.showTitle,null,null,true,HyperlinkShowTitleManager.rollOver);
                                                                                                                                                                                                                                          if(!_loc1_)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                          §§goto(addr273);
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    addr619:
                                                                                                                                                                                                                                    loop79:
                                                                                                                                                                                                                                    while(true)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       TooltipsFactory.registerAssoc(GameFightMonsterInformations,"monsterFighter");
                                                                                                                                                                                                                                       if(_loc1_)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          loop32:
                                                                                                                                                                                                                                          while(true)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             HyperlinkFactory.registerProtocol("taxcollectorPosition",HyperlinkTaxCollectorPosition.showPosition,null,null,false,HyperlinkTaxCollectorPosition.rollOver);
                                                                                                                                                                                                                                             if(!_loc1_)
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                addr642:
                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   if(_loc1_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      addr647:
                                                                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         ApiBinder.addApi("Mount",MountApi);
                                                                                                                                                                                                                                                         if(_loc1_)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            addr656:
                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               HyperlinkFactory.registerProtocol("offlineSales",HyperlinkShowOfflineSales.showOfflineSales,null,null,false);
                                                                                                                                                                                                                                                               addr665:
                                                                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  if(_loc2_)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     continue loop32;
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                         else
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      continue loop8;
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   §§goto(addr690);
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       addr205:
                                                                                                                                                                                                                                       while(true)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          TooltipsFactory.registerAssoc(GameFightCompanionInformations,"companionFighter");
                                                                                                                                                                                                                                          if(_loc1_)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             §§goto(addr215);
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                          break loop79;
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    §§goto(addr742);
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 addr1508:
                                                                                                                                                                                                                                 while(_loc1_)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    while(true)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       TooltipsFactory.registerAssoc(SmileyWrapper,"smiley");
                                                                                                                                                                                                                                       if(!_loc1_)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          §§goto(addr1150);
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       §§goto(addr215);
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 continue loop62;
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        addr1468:
                                                                                                                                                                                                                        while(true)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           ApiBinder.addApi("Binds",BindsApi);
                                                                                                                                                                                                                           addr1472:
                                                                                                                                                                                                                           while(true)
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              if(!_loc2_)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 addr1477:
                                                                                                                                                                                                                                 while(true)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    TooltipsFactory.registerAssoc(GroundObject,"groundObject");
                                                                                                                                                                                                                                    if(!_loc1_)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    §§goto(addr263);
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                              loop85:
                                                                                                                                                                                                                              while(true)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 ApiBinder.addApi("Chat",ChatApi);
                                                                                                                                                                                                                                 if(!_loc2_)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    §§goto(addr1267);
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 loop86:
                                                                                                                                                                                                                                 while(true)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    ApiBinder.addApi("Sound",SoundApi);
                                                                                                                                                                                                                                    if(_loc1_)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       addr1235:
                                                                                                                                                                                                                                       while(true)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          ApiBinder.addApi("Quest",QuestApi);
                                                                                                                                                                                                                                          if(_loc1_)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             addr1244:
                                                                                                                                                                                                                                             while(true)
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                TooltipsFactory.registerAssoc(MountWrapper,"item");
                                                                                                                                                                                                                                                if(!_loc1_)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   if(!_loc2_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      break;
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   addr916:
                                                                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      TooltipsFactory.registerAssoc(GameContextPaddockItemInformations,"paddockItem");
                                                                                                                                                                                                                                                      if(_loc1_)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         break;
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      addr517:
                                                                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         TooltipsFactory.registerAssoc(GameRolePlayMountInformations,"paddockMount");
                                                                                                                                                                                                                                                         if(_loc1_)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            addr527:
                                                                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               TooltipsFactory.registerAssoc(GameRolePlayMerchantInformations,"merchant");
                                                                                                                                                                                                                                                               if(!_loc1_)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  §§goto(addr1477);
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               §§goto(addr263);
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                         §§goto(addr299);
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   addr926:
                                                                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      HyperlinkFactory.registerProtocol("estate",HyperlinkShowEstate.click,null,null,true);
                                                                                                                                                                                                                                                      if(!_loc1_)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         if(_loc2_)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            if(!_loc2_)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               §§goto(addr944);
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            else
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               addr1544:
                                                                                                                                                                                                                                                               return;
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                         else
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            continue loop56;
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      else
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         break;
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      if(_loc1_)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         §§goto(addr1397);
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      §§goto(addr926);
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                addr1296:
                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   if(_loc1_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      addr1301:
                                                                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         MenusFactory.registerAssoc(GameFightCompanionInformations,"companion");
                                                                                                                                                                                                                                                         addr1305:
                                                                                                                                                                                                                                                         loop46:
                                                                                                                                                                                                                                                         while(true)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            if(!_loc2_)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               addr1310:
                                                                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  HyperlinkFactory.registerProtocol("guild",HyperlinkShowGuildManager.showGuild,HyperlinkShowGuildManager.getGuildName,null,true,HyperlinkShowGuildManager.rollOver);
                                                                                                                                                                                                                                                                  if(_loc1_)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     §§goto(addr1326);
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  else
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     break loop46;
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            §§goto(addr705);
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                         while(true)
                                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                                            HyperlinkFactory.registerProtocol("alliance",HyperlinkShowAllianceManager.showAlliance,HyperlinkShowAllianceManager.getAllianceName,null,true,HyperlinkShowAllianceManager.rollOver);
                                                                                                                                                                                                                                                            if(_loc2_)
                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                               if(!_loc2_)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  addr172:
                                                                                                                                                                                                                                                                  while(true)
                                                                                                                                                                                                                                                                  {
                                                                                                                                                                                                                                                                     ApiBinder.addApi("Document",DocumentApi);
                                                                                                                                                                                                                                                                     if(!_loc1_)
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        if(!_loc1_)
                                                                                                                                                                                                                                                                        {
                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                        §§goto(addr647);
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                     else
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                        break;
                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                  continue loop19;
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                               addr1077:
                                                                                                                                                                                                                                                               while(true)
                                                                                                                                                                                                                                                               {
                                                                                                                                                                                                                                                                  HyperlinkFactory.registerProtocol("openSocial",HyperlinkSocialManager.openSocial,null,null,true,HyperlinkSocialManager.rollOver);
                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                            §§goto(addr642);
                                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   §§goto(addr656);
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                             continue loop85;
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                          break;
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       while(true)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                          ApiBinder.addApi("Alignment",AlignmentApi);
                                                                                                                                                                                                                                          if(!_loc2_)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             addr771:
                                                                                                                                                                                                                                             while(true)
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                HyperlinkFactory.registerProtocol("chatachievement",HyperlinkShowAchievementManager.showAchievement,HyperlinkShowAchievementManager.getAchievementName,null,true,HyperlinkShowAchievementManager.rollOver);
                                                                                                                                                                                                                                                if(_loc2_)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   if(!_loc1_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      if(!_loc2_)
                                                                                                                                                                                                                                                      {
                                                                                                                                                                                                                                                         break;
                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                      §§goto(addr1171);
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   §§goto(addr1305);
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                addr863:
                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   if(!_loc1_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   addr1384:
                                                                                                                                                                                                                                                   while(true)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      HyperlinkFactory.registerProtocol("screenshot",HyperlinkScreenshot.click,null,null,true);
                                                                                                                                                                                                                                                      §§goto(addr1392);
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                             continue loop9;
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                          addr1206:
                                                                                                                                                                                                                                          while(true)
                                                                                                                                                                                                                                          {
                                                                                                                                                                                                                                             ApiBinder.addApi("Inventory",InventoryApi);
                                                                                                                                                                                                                                             if(!_loc2_)
                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                addr1215:
                                                                                                                                                                                                                                                while(true)
                                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                                   TooltipsFactory.registerAssoc(QuantifiedItemWrapper,"item");
                                                                                                                                                                                                                                                   if(!_loc2_)
                                                                                                                                                                                                                                                   {
                                                                                                                                                                                                                                                      continue loop86;
                                                                                                                                                                                                                                                   }
                                                                                                                                                                                                                                                   §§goto(addr1513);
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                             §§goto(addr172);
                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                    §§goto(addr609);
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  while(true)
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                     ApiBinder.addApi("AveragePrices",AveragePricesApi);
                                                                                                                                                                                                                     if(_loc1_)
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                        addr1459:
                                                                                                                                                                                                                        while(true)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           ApiBinder.addApi("Storage",StorageApi);
                                                                                                                                                                                                                           if(_loc1_)
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              §§goto(addr1468);
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                           else
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              break;
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        continue loop2;
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                     §§goto(addr244);
                                                                                                                                                                                                                  }
                                                                                                                                                                                                               }
                                                                                                                                                                                                            }
                                                                                                                                                                                                            while(true)
                                                                                                                                                                                                            {
                                                                                                                                                                                                               HyperlinkFactory.registerProtocol("entity",HyperlinkShowEntityManager.showEntity,HyperlinkShowEntityManager.getEntityName,null,true,HyperlinkShowEntityManager.rollOver);
                                                                                                                                                                                                               if(_loc2_)
                                                                                                                                                                                                               {
                                                                                                                                                                                                                  if(_loc2_)
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  addr1010:
                                                                                                                                                                                                                  while(true)
                                                                                                                                                                                                                  {
                                                                                                                                                                                                                     HyperlinkFactory.registerProtocol("recipe",HyperlinkShowRecipeManager.showRecipe,HyperlinkShowRecipeManager.getRecipeName,null,true,HyperlinkShowRecipeManager.rollOver);
                                                                                                                                                                                                                     if(_loc2_)
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                        if(_loc1_)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                           addr1029:
                                                                                                                                                                                                                           while(true)
                                                                                                                                                                                                                           {
                                                                                                                                                                                                                              TooltipsFactory.registerAssoc(Vector.<String>,"texturesList");
                                                                                                                                                                                                                              if(!_loc2_)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 §§goto(addr1040);
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                              addr1345:
                                                                                                                                                                                                                              while(true)
                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                 TooltipsFactory.registerAssoc(CraftSmileyItem,"craftSmiley");
                                                                                                                                                                                                                                 if(_loc1_)
                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                    addr1354:
                                                                                                                                                                                                                                    while(true)
                                                                                                                                                                                                                                    {
                                                                                                                                                                                                                                       TooltipsFactory.registerAssoc(WeaponWrapper,"item");
                                                                                                                                                                                                                                       if(!_loc1_)
                                                                                                                                                                                                                                       {
                                                                                                                                                                                                                                       }
                                                                                                                                                                                                                                       §§goto(addr1215);
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 break;
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                              §§goto(addr715);
                                                                                                                                                                                                                           }
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        break;
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                     §§goto(addr1296);
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  §§goto(addr725);
                                                                                                                                                                                                               }
                                                                                                                                                                                                               else
                                                                                                                                                                                                               {
                                                                                                                                                                                                                  break;
                                                                                                                                                                                                               }
                                                                                                                                                                                                            }
                                                                                                                                                                                                            continue loop13;
                                                                                                                                                                                                         }
                                                                                                                                                                                                      }
                                                                                                                                                                                                      else
                                                                                                                                                                                                      {
                                                                                                                                                                                                         break;
                                                                                                                                                                                                      }
                                                                                                                                                                                                   }
                                                                                                                                                                                                   continue loop25;
                                                                                                                                                                                                }
                                                                                                                                                                                             }
                                                                                                                                                                                             loop102:
                                                                                                                                                                                             while(true)
                                                                                                                                                                                             {
                                                                                                                                                                                                HyperlinkFactory.registerProtocol("system",HyperlinkSystem.open,null,null,true);
                                                                                                                                                                                                if(_loc1_)
                                                                                                                                                                                                {
                                                                                                                                                                                                   §§goto(addr1010);
                                                                                                                                                                                                }
                                                                                                                                                                                                addr884:
                                                                                                                                                                                                while(true)
                                                                                                                                                                                                {
                                                                                                                                                                                                   HyperlinkFactory.registerProtocol("monsterGroup",HyperlinkShowMonsterGroup.showMonsterGroup,HyperlinkShowMonsterGroup.getText,null,true,HyperlinkShowMonsterGroup.rollOver);
                                                                                                                                                                                                   if(_loc1_)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      addr901:
                                                                                                                                                                                                      while(true)
                                                                                                                                                                                                      {
                                                                                                                                                                                                         HyperlinkFactory.registerProtocol("chatquest",HyperlinkShowQuestManager.showQuest,null,null,true,HyperlinkShowQuestManager.rollOver);
                                                                                                                                                                                                         if(_loc1_)
                                                                                                                                                                                                         {
                                                                                                                                                                                                            §§goto(addr916);
                                                                                                                                                                                                         }
                                                                                                                                                                                                         break;
                                                                                                                                                                                                      }
                                                                                                                                                                                                      §§goto(addr771);
                                                                                                                                                                                                   }
                                                                                                                                                                                                   else
                                                                                                                                                                                                   {
                                                                                                                                                                                                      break loop102;
                                                                                                                                                                                                   }
                                                                                                                                                                                                }
                                                                                                                                                                                             }
                                                                                                                                                                                             while(true)
                                                                                                                                                                                             {
                                                                                                                                                                                                HyperlinkFactory.registerProtocol("url",HyperlinkURLManager.openURL);
                                                                                                                                                                                                §§goto(addr863);
                                                                                                                                                                                             }
                                                                                                                                                                                          }
                                                                                                                                                                                       }
                                                                                                                                                                                    }
                                                                                                                                                                                    break;
                                                                                                                                                                                 }
                                                                                                                                                                                 while(true)
                                                                                                                                                                                 {
                                                                                                                                                                                    MenusFactory.registerAssoc(GameRolePlayTaxCollectorInformations,"taxCollector");
                                                                                                                                                                                    if(!_loc2_)
                                                                                                                                                                                    {
                                                                                                                                                                                       §§goto(addr761);
                                                                                                                                                                                    }
                                                                                                                                                                                    else
                                                                                                                                                                                    {
                                                                                                                                                                                       break;
                                                                                                                                                                                    }
                                                                                                                                                                                 }
                                                                                                                                                                                 continue loop18;
                                                                                                                                                                              }
                                                                                                                                                                           }
                                                                                                                                                                           else
                                                                                                                                                                           {
                                                                                                                                                                              addr143:
                                                                                                                                                                              while(true)
                                                                                                                                                                              {
                                                                                                                                                                                 ApiBinder.addApi("Capture",CaptureApi);
                                                                                                                                                                                 if(!_loc2_)
                                                                                                                                                                                 {
                                                                                                                                                                                    §§goto(addr153);
                                                                                                                                                                                 }
                                                                                                                                                                              }
                                                                                                                                                                           }
                                                                                                                                                                           while(true)
                                                                                                                                                                           {
                                                                                                                                                                              ApiBinder.addApi("Notification",NotificationApi);
                                                                                                                                                                              if(_loc2_)
                                                                                                                                                                              {
                                                                                                                                                                              }
                                                                                                                                                                              §§goto(addr1121);
                                                                                                                                                                           }
                                                                                                                                                                        }
                                                                                                                                                                     }
                                                                                                                                                                     addr1092:
                                                                                                                                                                     while(true)
                                                                                                                                                                     {
                                                                                                                                                                        TooltipsFactory.registerAssoc(GameRolePlayGroupMonsterInformations,"monsterGroup");
                                                                                                                                                                     }
                                                                                                                                                                  }
                                                                                                                                                               }
                                                                                                                                                               while(true)
                                                                                                                                                               {
                                                                                                                                                                  HyperlinkFactory.registerProtocol("spellPair",HyperlinkSpellManager.showSpellPair);
                                                                                                                                                                  if(_loc1_)
                                                                                                                                                                  {
                                                                                                                                                                     addr1416:
                                                                                                                                                                     while(true)
                                                                                                                                                                     {
                                                                                                                                                                        ApiBinder.addApi("Roleplay",RoleplayApi);
                                                                                                                                                                        if(_loc1_)
                                                                                                                                                                        {
                                                                                                                                                                           §§goto(addr1426);
                                                                                                                                                                        }
                                                                                                                                                                        addr1067:
                                                                                                                                                                        while(true)
                                                                                                                                                                        {
                                                                                                                                                                           ApiBinder.addApi("Map",MapApi);
                                                                                                                                                                           if(!_loc2_)
                                                                                                                                                                           {
                                                                                                                                                                              §§goto(addr1077);
                                                                                                                                                                           }
                                                                                                                                                                           §§goto(addr1235);
                                                                                                                                                                        }
                                                                                                                                                                     }
                                                                                                                                                                  }
                                                                                                                                                                  §§goto(addr1110);
                                                                                                                                                               }
                                                                                                                                                            }
                                                                                                                                                         }
                                                                                                                                                         continue loop14;
                                                                                                                                                      }
                                                                                                                                                      while(true)
                                                                                                                                                      {
                                                                                                                                                         HyperlinkFactory.registerProtocol("subArea",HyperlinkShowSubArea.showSubArea,HyperlinkShowSubArea.getSubAreaName);
                                                                                                                                                         §§goto(addr1296);
                                                                                                                                                      }
                                                                                                                                                   }
                                                                                                                                                }
                                                                                                                                                addr1372:
                                                                                                                                                while(true)
                                                                                                                                                {
                                                                                                                                                   TooltipsFactory.registerAssoc(Object,"mount");
                                                                                                                                                   if(!_loc1_)
                                                                                                                                                   {
                                                                                                                                                      if(_loc1_)
                                                                                                                                                      {
                                                                                                                                                         §§goto(addr1384);
                                                                                                                                                      }
                                                                                                                                                      §§goto(addr1244);
                                                                                                                                                   }
                                                                                                                                                   addr1530:
                                                                                                                                                   while(true)
                                                                                                                                                   {
                                                                                                                                                      if(!_loc1_)
                                                                                                                                                      {
                                                                                                                                                      }
                                                                                                                                                      §§goto(addr1416);
                                                                                                                                                   }
                                                                                                                                                }
                                                                                                                                             }
                                                                                                                                             while(true)
                                                                                                                                             {
                                                                                                                                                if(_loc1_)
                                                                                                                                                {
                                                                                                                                                   §§goto(addr619);
                                                                                                                                                }
                                                                                                                                                §§goto(addr577);
                                                                                                                                             }
                                                                                                                                          }
                                                                                                                                       }
                                                                                                                                    }
                                                                                                                                    continue loop0;
                                                                                                                                 }
                                                                                                                                 while(true)
                                                                                                                                 {
                                                                                                                                    if(_loc1_)
                                                                                                                                    {
                                                                                                                                       §§goto(addr1092);
                                                                                                                                    }
                                                                                                                                    §§goto(addr1435);
                                                                                                                                 }
                                                                                                                              }
                                                                                                                           }
                                                                                                                           else
                                                                                                                           {
                                                                                                                              break;
                                                                                                                           }
                                                                                                                        }
                                                                                                                        addr1490:
                                                                                                                        while(true)
                                                                                                                        {
                                                                                                                           if(!_loc2_)
                                                                                                                           {
                                                                                                                              §§goto(addr1495);
                                                                                                                           }
                                                                                                                           §§goto(addr332);
                                                                                                                        }
                                                                                                                     }
                                                                                                                     continue loop4;
                                                                                                                  }
                                                                                                                  while(true)
                                                                                                                  {
                                                                                                                     TooltipsFactory.registerAssoc(GameRolePlayMutantInformations,"mutant");
                                                                                                                     if(_loc2_)
                                                                                                                     {
                                                                                                                        if(_loc1_)
                                                                                                                        {
                                                                                                                           addr1197:
                                                                                                                           while(true)
                                                                                                                           {
                                                                                                                              MenusFactory.registerAssoc(GameRolePlayGroupMonsterInformations,"monsterGroup");
                                                                                                                              if(_loc1_)
                                                                                                                              {
                                                                                                                                 §§goto(addr1206);
                                                                                                                              }
                                                                                                                              §§goto(addr1301);
                                                                                                                           }
                                                                                                                        }
                                                                                                                        §§goto(addr977);
                                                                                                                     }
                                                                                                                     §§goto(addr1472);
                                                                                                                  }
                                                                                                               }
                                                                                                            }
                                                                                                            while(true)
                                                                                                            {
                                                                                                               ApiBinder.addApi("Social",SocialApi);
                                                                                                               §§goto(addr1530);
                                                                                                            }
                                                                                                         }
                                                                                                      }
                                                                                                      while(true)
                                                                                                      {
                                                                                                         HyperlinkFactory.registerProtocol("spellEffectArea",HyperlinkSpellManager.showSpellArea,null,null,true,HyperlinkSpellManager.rollOver);
                                                                                                         if(!_loc1_)
                                                                                                         {
                                                                                                            if(!_loc1_)
                                                                                                            {
                                                                                                               if(_loc1_)
                                                                                                               {
                                                                                                                  §§goto(addr373);
                                                                                                               }
                                                                                                               §§goto(addr901);
                                                                                                            }
                                                                                                            §§goto(addr950);
                                                                                                         }
                                                                                                         §§goto(addr685);
                                                                                                      }
                                                                                                   }
                                                                                                }
                                                                                             }
                                                                                          }
                                                                                          while(true)
                                                                                          {
                                                                                             MenusFactory.registerAssoc(QuantifiedItemWrapper,"item");
                                                                                             if(!_loc2_)
                                                                                             {
                                                                                                addr195:
                                                                                                while(true)
                                                                                                {
                                                                                                   ApiBinder.addApi("Test",TestApi);
                                                                                                   if(_loc1_)
                                                                                                   {
                                                                                                      §§goto(addr205);
                                                                                                   }
                                                                                                   addr1336:
                                                                                                   while(true)
                                                                                                   {
                                                                                                      ApiBinder.addApi("Jobs",JobsApi);
                                                                                                      if(!_loc2_)
                                                                                                      {
                                                                                                         §§goto(addr1345);
                                                                                                      }
                                                                                                      §§goto(addr1459);
                                                                                                   }
                                                                                                }
                                                                                             }
                                                                                             §§goto(addr254);
                                                                                          }
                                                                                       }
                                                                                    }
                                                                                    while(true)
                                                                                    {
                                                                                       MenusFactory.registerAssoc(GameRolePlayCharacterInformations,"player");
                                                                                       if(_loc2_)
                                                                                       {
                                                                                          addr507:
                                                                                          while(true)
                                                                                          {
                                                                                             MenusFactory.registerAssoc(GameRolePlayMutantInformations,"mutant");
                                                                                          }
                                                                                       }
                                                                                       §§goto(addr1544);
                                                                                    }
                                                                                 }
                                                                                 while(true)
                                                                                 {
                                                                                    if(!_loc2_)
                                                                                    {
                                                                                       §§goto(addr1336);
                                                                                    }
                                                                                    §§goto(addr828);
                                                                                 }
                                                                              }
                                                                           }
                                                                           while(true)
                                                                           {
                                                                              ApiBinder.addApi("File",FileApi);
                                                                              §§goto(addr1490);
                                                                           }
                                                                        }
                                                                     }
                                                                  }
                                                                  while(true)
                                                                  {
                                                                     TooltipsFactory.registerAssoc(ItemWrapper,"item");
                                                                     if(_loc1_)
                                                                     {
                                                                        §§goto(addr1067);
                                                                     }
                                                                     §§goto(addr1354);
                                                                  }
                                                               }
                                                            }
                                                            while(true)
                                                            {
                                                               HyperlinkFactory.registerProtocol("bestiary",HyperlinkShowMonsterChatManager.showMonster,HyperlinkShowMonsterChatManager.getMonsterName,null,false,HyperlinkShowMonsterChatManager.rollOver);
                                                               if(!_loc2_)
                                                               {
                                                                  §§goto(addr884);
                                                               }
                                                               §§goto(addr385);
                                                            }
                                                         }
                                                      }
                                                      while(true)
                                                      {
                                                         MenusFactory.registerAssoc(String,"player");
                                                         if(!_loc2_)
                                                         {
                                                            §§goto(addr143);
                                                         }
                                                         §§goto(addr1197);
                                                      }
                                                   }
                                                   addr852:
                                                   while(true)
                                                   {
                                                      if(!_loc2_)
                                                      {
                                                         §§goto(addr857);
                                                      }
                                                      §§goto(addr1310);
                                                   }
                                                }
                                             }
                                             while(true)
                                             {
                                                ApiBinder.addApi("ContextMenu",ContextMenuApi);
                                                if(_loc1_)
                                                {
                                                   addr494:
                                                   while(true)
                                                   {
                                                      TooltipsFactory.registerAssoc(GameRolePlayGroupMonsterWaveInformations,"monsterGroup");
                                                      if(_loc2_)
                                                      {
                                                         if(_loc1_)
                                                         {
                                                            §§goto(addr507);
                                                         }
                                                         §§goto(addr527);
                                                      }
                                                      §§goto(addr665);
                                                   }
                                                }
                                                §§goto(addr195);
                                             }
                                          }
                                       }
                                       while(true)
                                       {
                                          TooltipsFactory.registerAssoc(EffectsListWrapper,"effectsList");
                                          if(!_loc1_)
                                          {
                                             if(!_loc2_)
                                             {
                                                §§goto(addr567);
                                             }
                                             §§goto(addr1029);
                                          }
                                          §§goto(addr710);
                                       }
                                    }
                                    while(true)
                                    {
                                       if(_loc1_)
                                       {
                                          §§goto(addr517);
                                       }
                                       §§goto(addr342);
                                    }
                                 }
                              }
                              while(true)
                              {
                                 ApiBinder.addApi("Exchange",ExchangeApi);
                                 §§goto(addr1508);
                              }
                           }
                        }
                        while(true)
                        {
                           HyperlinkFactory.registerProtocol("chatitem",HyperlinkItemManager.showChatItem,null,HyperlinkItemManager.duplicateChatHyperlink,true,HyperlinkItemManager.rollOver);
                           §§goto(addr852);
                        }
                     }
                  }
                  while(true)
                  {
                     MenusFactory.registerAssoc(GameContextPaddockItemInformations,"paddockItem");
                     if(_loc1_)
                     {
                        §§goto(addr679);
                     }
                     §§goto(addr84);
                  }
               }
            }
            while(true)
            {
               ApiBinder.addApi("System",SystemApi);
               if(!_loc2_)
               {
                  §§goto(addr1372);
               }
               §§goto(addr987);
            }
         }
         while(true)
         {
            if(_loc1_)
            {
               §§goto(addr1101);
            }
            §§goto(addr494);
         }
      }
      
      private function displayLoadingScreen() : void
      {
         var _loc2_:Boolean = true;
         if(!_loc1_)
         {
            §§push(this);
            §§push();
            §§push(false);
            §§push(true);
            if(_loc2_)
            {
               §§push(Dofus.getInstance().initialized);
               if(!_loc1_)
               {
                  §§push(!§§pop());
                  if(!_loc1_)
                  {
                     if(§§pop())
                     {
                        if(!_loc1_)
                        {
                           §§pop();
                        }
                     }
                  }
                  addr47:
                  §§pop()._loadingScreen = new §§pop().LoadingScreen(§§pop(),§§pop(),§§pop());
                  loop0:
                  for(; _loc1_; §§goto(addr47))
                  {
                     while(true)
                     {
                        this._loadingScreen.logCallbackHandler = this.onLog;
                        addr87:
                        loop1:
                        while(!_loc1_)
                        {
                           while(true)
                           {
                              Dofus.getInstance().addChild(this._loadingScreen);
                              if(_loc2_)
                              {
                                 continue loop0;
                              }
                              continue loop1;
                           }
                        }
                        break loop0;
                     }
                  }
                  if(_loc1_)
                  {
                  }
                  return;
               }
               addr46:
               §§goto(addr47);
               §§push(Boolean(§§pop()));
            }
            §§push(Dofus.USE_MINI_LOADER);
            if(_loc2_)
            {
               §§goto(addr46);
            }
            §§goto(addr47);
         }
         this._loadingScreen.closeMiniUiRequestHandler = this.closeMiniLoadingUi;
         if(!_loc1_)
         {
            if(!_loc2_)
            {
               §§goto(addr64);
            }
            §§goto(addr82);
         }
         §§goto(addr87);
      }
      
      private function closeMiniLoadingUi() : void
      {
         var _loc1_:Boolean = true;
         var _loc2_:Boolean = false;
         if(!_loc2_)
         {
            if(this._loadingScreen)
            {
               if(!_loc2_)
               {
                  this._loadingScreen.hideMiniUi();
                  if(_loc2_)
                  {
                  }
               }
               if(AirScanner.hasAir())
               {
                  if(!_loc2_)
                  {
                     StageShareManager.stage.nativeWindow.activate();
                  }
               }
            }
         }
      }
      
      private function onLog(param1:String, param2:uint) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = true;
         if(!_loc3_)
         {
            if(param2 == LoadingScreen.ERROR)
            {
               if(!_loc3_)
               {
                  this.closeMiniLoadingUi();
               }
            }
         }
      }
      
      private function initTubul() : void
      {
         var _loc1_:Boolean = true;
         var _loc2_:Boolean = false;
         if(_loc1_)
         {
            SoundManager.getInstance().checkSoundDirectory();
         }
      }
      
      private function checkInit() : void
      {
         var _loc17_:Boolean = true;
         §§push(0);
         if(_loc16_)
         {
            §§push(--((-(§§pop() - 53) * 30 + 113) * 33));
         }
         var _loc2_:* = uint(§§pop());
         var _loc4_:XML = null;
         var _loc5_:* = null;
         §§push(0);
         if(_loc16_)
         {
            §§push(-(§§pop() - 1 + 32));
         }
         var _loc7_:uint = §§pop();
         var _loc8_:* = null;
         var _loc9_:SkinMapping = null;
         var _loc1_:Boolean = true;
         §§push(0);
         if(!_loc17_)
         {
            §§push((-(§§pop() * 52 + 54) - 1) * 87);
         }
         if(_loc17_)
         {
            if(!_loc16_)
            {
               for(var _loc3_ in this._aModuleInit)
               {
                  if(!_loc16_)
                  {
                     §§push(_loc1_);
                     if(_loc17_)
                     {
                        §§push(Boolean(§§pop()));
                        if(_loc16_)
                        {
                        }
                        addr122:
                        _loc1_ = §§pop();
                        if(!_loc16_)
                        {
                           addr128:
                           if(!this._aModuleInit[_loc3_])
                           {
                              if(_loc16_)
                              {
                                 continue;
                              }
                           }
                           else
                           {
                              continue;
                           }
                        }
                        addr133:
                        §§push(_loc2_);
                        if(!_loc16_)
                        {
                           §§push(uint(§§pop() + 1));
                        }
                        _loc2_ = §§pop();
                        continue;
                     }
                     if(§§pop())
                     {
                        if(_loc17_)
                        {
                           §§pop();
                           if(_loc16_)
                           {
                           }
                           §§goto(addr133);
                        }
                        §§goto(addr122);
                     }
                     §§goto(addr122);
                  }
                  §§push(this._aModuleInit);
                  if(_loc17_)
                  {
                     §§push(_loc3_);
                     if(!_loc16_)
                     {
                        §§push(Boolean(§§pop()[§§pop()]));
                        if(_loc17_)
                        {
                           §§goto(addr122);
                        }
                        §§goto(addr122);
                     }
                     §§goto(addr128);
                  }
                  §§goto(addr128);
               }
            }
         }
         if(_loc17_)
         {
            §§push(_loc2_);
            if(_loc17_)
            {
               §§push(3);
               if(_loc16_)
               {
                  §§push(§§pop() * 83 + 41 - 64);
               }
               if(§§pop() == §§pop())
               {
                  if(!_loc16_)
                  {
                     UiModuleManager.getInstance().init(Constants.COMMON_GAME_MODULE.concat(Constants.PRE_GAME_MODULE),true);
                  }
                  addr207:
                  return;
               }
               §§push(BuildInfos.BUILD_TYPE);
            }
            if(§§pop() != BuildTypeEnum.DEBUG)
            {
               §§push(_loc1_);
               if(!_loc16_)
               {
                  §§push(Boolean(§§pop()));
                  §§push(Boolean(§§pop()));
                  if(_loc17_)
                  {
                     if(§§pop())
                     {
                        §§pop();
                        §§push(!Benchmark.hasCachedResults);
                        if(_loc16_)
                        {
                        }
                        addr194:
                        §§pop();
                     }
                     §§push(§§pop());
                  }
                  if(§§pop())
                  {
                     §§goto(addr194);
                  }
                  addr200:
                  if(§§pop())
                  {
                     Benchmark.run(StageShareManager.stage,this.checkInit);
                     §§goto(addr207);
                  }
               }
               addr209:
               if(§§pop())
               {
                  _loc4_ = describeType(GameDataList);
                  if(_loc17_)
                  {
                     §§push([]);
                     if(!_loc16_)
                     {
                        §§push(§§pop());
                     }
                     _loc5_ = §§pop();
                     if(_loc17_)
                     {
                        §§push(0);
                        if(_loc16_)
                        {
                           §§push(§§pop() - 1 - 1 + 74 + 1 + 63);
                        }
                        if(!_loc16_)
                        {
                           if(!_loc16_)
                           {
                              if(_loc17_)
                              {
                                 for each(var _loc6_ in _loc4_..constant)
                                 {
                                    if(_loc17_)
                                    {
                                       §§push(0);
                                       if(!_loc17_)
                                       {
                                          §§push(-(§§pop() * 29 + 1 - 8));
                                       }
                                       if(_loc17_)
                                       {
                                          if(!_loc16_)
                                          {
                                             for each(var _loc11_ in _loc10_..method)
                                             {
                                                §§push(_loc11_.@returnType.toString() == _loc6_.@type.toString());
                                                if(!_loc16_)
                                                {
                                                   §§push(§§pop());
                                                   if(_loc17_)
                                                   {
                                                      if(§§pop())
                                                      {
                                                         if(!_loc16_)
                                                         {
                                                            §§pop();
                                                            if(_loc17_)
                                                            {
                                                               §§push(_loc11_.@name.toString().indexOf("get"));
                                                               §§push(0);
                                                               if(!_loc17_)
                                                               {
                                                                  §§push((§§pop() - 1 - 1 + 1 - 73) * 75 * 87);
                                                               }
                                                               §§push(§§pop() == §§pop());
                                                               if(!_loc17_)
                                                               {
                                                               }
                                                            }
                                                            else
                                                            {
                                                               continue;
                                                            }
                                                         }
                                                         addr361:
                                                         if(!§§pop())
                                                         {
                                                            if(!_loc16_)
                                                            {
                                                               addr364:
                                                               §§push(_loc5_);
                                                               §§push("fct");
                                                               §§push(getDefinitionByName(_loc6_.@type)[_loc11_.@name.toString()]);
                                                               §§push("returnClass");
                                                               §§push(getDefinitionByName(_loc6_.@type));
                                                               §§push("testIndex");
                                                               §§push(0);
                                                               if(_loc16_)
                                                               {
                                                                  §§push((-(§§pop() - 69) - 84) * 81 + 1 - 1 + 1);
                                                               }
                                                               §§push(1);
                                                               §§push(2);
                                                               if(!_loc17_)
                                                               {
                                                                  §§push(§§pop() - 52 + 1 - 1);
                                                               }
                                                               §§push(3);
                                                               §§push(4);
                                                               if(_loc16_)
                                                               {
                                                                  §§push((-(§§pop() - 79) - 93 + 113 - 1) * 34);
                                                               }
                                                               §§push(100);
                                                               §§push(1000);
                                                               if(_loc16_)
                                                               {
                                                                  §§push(-(-§§pop() - 1));
                                                               }
                                                               §§push(2000);
                                                               §§push(10000);
                                                               if(_loc16_)
                                                               {
                                                                  §§push(-(-§§pop() - 1 - 1 - 1) - 1);
                                                               }
                                                               §§pop().push(null);
                                                            }
                                                         }
                                                         continue;
                                                      }
                                                      §§push(§§pop());
                                                   }
                                                   if(§§pop())
                                                   {
                                                      if(_loc16_)
                                                      {
                                                      }
                                                   }
                                                   §§goto(addr361);
                                                }
                                                §§pop();
                                                if(_loc17_)
                                                {
                                                   §§push(_loc11_.@name.toString().indexOf("ById"));
                                                   §§push(-1);
                                                   if(_loc16_)
                                                   {
                                                      §§push(§§pop() - 1 + 1 - 63 + 54 + 1 - 1);
                                                   }
                                                   §§push(§§pop() == §§pop());
                                                   if(_loc17_)
                                                   {
                                                      §§goto(addr361);
                                                   }
                                                   §§goto(addr361);
                                                }
                                                §§goto(addr364);
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                              if(!_loc16_)
                              {
                                 if(!_loc16_)
                                 {
                                    DofusApiAction.updateInfo();
                                    CensoredContentManager.getInstance().init(CensoredContent.getCensoredContents(),XmlConfig.getInstance().getEntry("config.lang.current"));
                                    §§push(SkinMapping.getSkinMappings());
                                    if(!_loc16_)
                                    {
                                       §§push(§§pop());
                                    }
                                    _loc8_ = §§pop();
                                    §§push(0);
                                    if(_loc16_)
                                    {
                                       §§push((§§pop() + 1 + 41 - 1 + 1 + 103) * 14 - 104);
                                    }
                                 }
                                 addr567:
                                 if(_loc17_)
                                 {
                                 }
                                 §§push(Boolean(Constants.FORCE_MAXIMIZED_WINDOW));
                                 §§push(Boolean(Constants.FORCE_MAXIMIZED_WINDOW));
                                 if(_loc17_)
                                 {
                                    if(§§pop())
                                    {
                                       §§pop();
                                       §§push(Boolean(AirScanner.hasAir()));
                                    }
                                    if(§§pop())
                                    {
                                       StageShareManager.stage["nativeWindow"].maximize();
                                       if(!_loc16_)
                                       {
                                          if(_loc16_)
                                          {
                                             addr594:
                                             while(true)
                                             {
                                                Kernel.getWorker().addFrame(new GameStartingFrame());
                                                if(_loc17_)
                                                {
                                                }
                                                break;
                                             }
                                             §§push(!AirScanner.isStreamingVersion());
                                             §§push(!AirScanner.isStreamingVersion());
                                             if(!_loc17_)
                                             {
                                             }
                                             if(§§pop())
                                             {
                                                §§pop();
                                                §§push(Boolean(SteamManager.getInstance().isSteamEmbed()));
                                             }
                                             if(§§pop() || BuildInfos.BUILD_TYPE != BuildTypeEnum.DEBUG)
                                             {
                                                KernelEventsManager.getInstance().processCallback(HookList.UpdaterConnectionFailed);
                                             }
                                          }
                                       }
                                    }
                                    while(true)
                                    {
                                       Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
                                       if(_loc16_)
                                       {
                                          addr617:
                                          while(true)
                                          {
                                             Kernel.getWorker().addFrame(new QueueFrame());
                                             if(_loc17_)
                                             {
                                                §§goto(addr594);
                                             }
                                             §§goto(addr638);
                                          }
                                       }
                                       while(true)
                                       {
                                          Kernel.getWorker().addFrame(new AuthentificationFrame());
                                          if(_loc17_)
                                          {
                                             §§goto(addr617);
                                          }
                                          §§goto(addr638);
                                       }
                                    }
                                 }
                                 addr651:
                                 if(§§pop())
                                 {
                                    §§pop();
                                 }
                                 §§push(§§pop());
                                 if(_loc17_)
                                 {
                                    if(§§pop())
                                    {
                                       §§pop();
                                       if(!_loc16_)
                                       {
                                          addr659:
                                          §§push(Boolean(SteamManager.hasSteamApi()));
                                          §§push(Boolean(SteamManager.hasSteamApi()));
                                          if(_loc17_)
                                          {
                                             §§goto(addr666);
                                          }
                                       }
                                       §§goto(addr679);
                                    }
                                    §§goto(addr685);
                                 }
                                 §§goto(addr685);
                              }
                           }
                           addr511:
                           _log.info("Initialization frame end");
                           if(_loc17_)
                           {
                           }
                           Constants.EVENT_MODE = LangManager.getInstance().getEntry("config.eventMode") == "true";
                        }
                        if(!_loc16_)
                        {
                           if(!_loc16_)
                           {
                              for each(_loc9_ in _loc8_)
                              {
                                 if(_loc17_)
                                 {
                                    Skin.addAlternativeSkin(_loc9_.id,_loc9_.lowDefId);
                                 }
                              }
                           }
                        }
                        §§goto(addr511);
                     }
                     if(_loc17_)
                     {
                     }
                     Constants.EVENT_MODE_PARAM = LangManager.getInstance().getEntry("config.eventModeParams");
                     if(_loc17_)
                     {
                        if(!_loc16_)
                        {
                        }
                        Constants.CHARACTER_CREATION_ALLOWED = LangManager.getInstance().getEntry("config.characterCreationAllowed") == "true";
                        if(_loc17_)
                        {
                        }
                        Constants.FORCE_MAXIMIZED_WINDOW = LangManager.getInstance().getEntry("config.autoMaximize") == "true";
                        §§goto(addr567);
                     }
                     §§goto(addr659);
                  }
                  if(_loc17_)
                  {
                  }
                  §§goto(addr651);
                  §§push(!this._updaterConnectionSuccess);
               }
               return;
            }
            §§goto(addr209);
            §§push(_loc1_);
         }
         §§push(!Benchmark.isDone);
         if(_loc17_)
         {
            §§goto(addr200);
         }
         §§goto(addr209);
      }
      
      private function onUiLoaded(param1:UiRenderEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            if(param1.uiTarget.uiData.name == "login")
            {
               if(_loc3_)
               {
               }
            }
            addr41:
            return;
         }
         Berilia.getInstance().removeEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
         if(_loc2_)
         {
            Kernel.getWorker().removeFrame(this);
         }
         §§goto(addr41);
      }
      
      private function initFonts() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = true;
         if(!_loc2_)
         {
            EmbedFontManager.getInstance().addEventListener(Event.COMPLETE,this.onFontsManagerInit);
         }
         §§push(FontManager.getInstance().getFontUrlList());
         if(_loc3_)
         {
            §§push(§§pop());
         }
         var _loc1_:* = §§pop();
         if(_loc3_)
         {
            EmbedFontManager.getInstance().initialize(_loc1_);
         }
      }
      
      private function setModulePercent(param1:String, param2:Number, param3:Boolean = false) : void
      {
         var _loc9_:Boolean = true;
         var _loc10_:Boolean = false;
         var _loc5_:* = NaN;
         §§push(0);
         if(_loc10_)
         {
            §§push((§§pop() * 100 + 96 + 22) * 89 * 39 - 1 + 100);
         }
         var _loc6_:* = uint(§§pop());
         if(_loc9_)
         {
            §§push(this._modPercents);
            if(_loc9_)
            {
               §§push(param1);
               if(_loc9_)
               {
                  if(!§§pop()[§§pop()])
                  {
                     if(!_loc10_)
                     {
                        §§push(this._modPercents);
                        if(!_loc10_)
                        {
                           §§push(param1);
                           if(!_loc9_)
                           {
                           }
                           addr84:
                           §§pop()[§§pop()] = this._modPercents[param1] + param2;
                           if(_loc10_)
                           {
                           }
                        }
                     }
                     addr93:
                  }
                  addr72:
                  if(param3)
                  {
                     if(!_loc10_)
                     {
                        addr76:
                        §§push(this._modPercents);
                        addr97:
                        if(_loc9_)
                        {
                           §§push(param1);
                           if(_loc9_)
                           {
                              §§goto(addr84);
                           }
                        }
                        §§pop()[§§pop()] = param2;
                     }
                     §§goto(addr93);
                  }
                  else
                  {
                     §§push(this._modPercents);
                  }
               }
               §§push(0);
               if(!_loc9_)
               {
                  §§push((§§pop() + 1 - 1 - 64) * 91 + 75);
               }
               §§pop()[§§pop()] = §§pop();
               if(!_loc10_)
               {
                  §§goto(addr72);
               }
               §§goto(addr76);
            }
            §§goto(addr97);
            §§push(param1);
         }
         §§push(0);
         if(_loc10_)
         {
            §§push(-(§§pop() - 1 - 1 - 1 + 7 + 1 - 16));
         }
         var _loc4_:* = Number(§§pop());
         if(!_loc10_)
         {
            §§push(0);
            if(!_loc9_)
            {
               §§push(-(-((§§pop() + 1 + 69) * 117) - 1) + 73);
            }
            if(!_loc10_)
            {
               if(!_loc10_)
               {
                  while(§§hasnext(this._modPercents,_loc7_))
                  {
                     §§push(Number(§§nextvalue(_loc7_,_loc8_)));
                     if(_loc9_)
                     {
                        _loc5_ = §§pop();
                        if(!_loc10_)
                        {
                           §§push(_loc4_);
                           if(_loc9_)
                           {
                              §§push(_loc5_);
                              if(!_loc10_)
                              {
                                 §§push(100);
                                 if(!_loc9_)
                                 {
                                    §§push(-((§§pop() + 1) * 104));
                                 }
                                 §§push(§§pop() / §§pop());
                                 if(_loc10_)
                                 {
                                 }
                                 addr176:
                                 §§push(§§pop() + §§pop());
                                 addr181:
                                 if(_loc10_)
                                 {
                                 }
                                 _loc4_ = §§pop();
                                 continue;
                              }
                              §§goto(addr176);
                              §§push(§§pop() * this._percentPerModule);
                           }
                        }
                        else
                        {
                           continue;
                        }
                     }
                     §§goto(addr181);
                     §§push(Number(§§pop()));
                  }
               }
            }
            if(!_loc10_)
            {
               §§push(Dofus.getInstance().instanceId);
               if(_loc9_)
               {
                  §§push(uint(§§pop()));
               }
               _loc6_ = §§pop();
               if(!_loc9_)
               {
               }
               addr222:
               this._loadingScreen.log(param1 + " initialized",LoadingScreen.IMPORTANT);
               if(!_loc9_)
               {
               }
               addr236:
               return;
            }
            addr232:
            this._loadingScreen.value = _loc4_;
            §§goto(addr236);
         }
         §§push(this._modPercents[param1]);
         §§push(100);
         if(!_loc9_)
         {
            §§push(-(§§pop() - 47 - 1) + 1 + 107 - 93);
         }
         if(§§pop() == §§pop())
         {
            if(_loc9_)
            {
               §§goto(addr222);
            }
         }
         §§goto(addr232);
      }
      
      private function onFontsManagerInit(param1:Event) : void
      {
         var _loc2_:Boolean = true;
         if(!_loc3_)
         {
            §§push(FontManager.getInstance());
            if(_loc2_)
            {
               if(OptionManager.getOptionManager("dofus")["smallScreenFont"] != true)
               {
                  §§push(FontManager.DEFAULT_FONT_TYPE);
                  if(!_loc3_)
                  {
                     §§push(§§pop());
                  }
               }
               addr34:
               §§pop().activeType = §§pop();
               if(_loc2_)
               {
                  this._aModuleInit["font"] = true;
                  if(!_loc3_)
                  {
                     if(_loc3_)
                     {
                        addr53:
                        while(true)
                        {
                           this.checkInit();
                           if(!_loc3_)
                           {
                              if(!_loc3_)
                              {
                              }
                              break;
                           }
                        }
                        return;
                     }
                     while(true)
                     {
                        §§push(this);
                        §§push("font");
                        §§push(100);
                        if(!_loc2_)
                        {
                           §§push(-(-(§§pop() + 107) - 116));
                        }
                        §§pop().setModulePercent(§§pop(),§§pop());
                     }
                  }
               }
            }
            §§goto(addr34);
            §§push("smallScreen");
         }
         while(true)
         {
            if(!_loc3_)
            {
               §§goto(addr53);
            }
            §§goto(addr85);
         }
      }
      
      private function onI18nReady(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(_loc3_)
         {
            this._aModuleInit["i18n"] = true;
            if(!_loc2_)
            {
               if(!_loc3_)
               {
                  addr27:
                  while(true)
                  {
                     this.checkInit();
                     if(_loc3_)
                     {
                        if(!_loc2_)
                        {
                           if(!_loc2_)
                           {
                           }
                           addr83:
                           Input.numberStrSeparator = I18n.getUiText("ui.common.numberSeparator");
                           break;
                        }
                     }
                     break;
                  }
               }
               while(true)
               {
                  §§push(this);
                  §§push("i18n");
                  §§push(100);
                  if(!_loc3_)
                  {
                     §§push((-(§§pop() - 1 - 1) + 1) * 67);
                  }
                  §§pop().setModulePercent(§§pop(),§§pop());
                  if(!_loc2_)
                  {
                     if(!_loc2_)
                     {
                     }
                     StoreDataManager.getInstance().setData(Constants.DATASTORE_LANG_VERSION,"lastLang",LangManager.getInstance().getEntry("config.lang.current"));
                  }
               }
            }
            while(true)
            {
               if(_loc2_)
               {
                  break;
               }
               §§goto(addr27);
            }
            §§goto(addr83);
         }
         if(_loc3_)
         {
         }
      }
      
      private function onGameDataReady(param1:Event) : void
      {
         var _loc2_:Boolean = true;
         if(!_loc3_)
         {
            this._aModuleInit["gameData"] = true;
            if(!_loc3_)
            {
               if(_loc3_)
               {
                  addr26:
                  while(true)
                  {
                     this.checkInit();
                     if(!_loc2_)
                     {
                     }
                  }
               }
               addr40:
               while(true)
               {
                  §§push(this);
                  §§push("gameData");
                  §§push(100);
                  if(_loc3_)
                  {
                     §§push((-(§§pop() + 84) - 1) * 50 * 87 - 1);
                  }
                  §§pop().setModulePercent(§§pop(),§§pop());
               }
            }
            while(true)
            {
               if(!_loc2_)
               {
                  break;
               }
               §§goto(addr26);
            }
            return;
         }
         while(true)
         {
            if(_loc3_)
            {
               §§goto(addr40);
            }
            §§goto(addr64);
         }
      }
      
      private function onGameDataPartialDataReady(param1:LangFileEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!_loc2_)
         {
            if(!this._loadingScreen)
            {
               if(_loc3_)
               {
                  this._loadingScreen = new LoadingScreen();
                  if(!_loc2_)
                  {
                     if(_loc2_)
                     {
                        addr32:
                        while(true)
                        {
                           §§push(this);
                           §§push("gameData");
                           §§push(this._percentPerModule);
                           if(_loc3_)
                           {
                              §§push(1);
                              if(_loc2_)
                              {
                                 §§push(§§pop() - 58 - 1 - 57 - 1);
                              }
                              §§push(§§pop() * §§pop());
                              if(_loc2_)
                              {
                              }
                              addr61:
                              §§pop().setModulePercent(§§pop(),§§pop(),true);
                              if(_loc3_)
                              {
                                 if(!_loc3_)
                                 {
                                 }
                                 addr107:
                                 while(_loc3_)
                                 {
                                    while(true)
                                    {
                                    }
                                 }
                                 return;
                              }
                           }
                           §§goto(addr61);
                        }
                     }
                     addr102:
                     while(true)
                     {
                        Dofus.getInstance().addChild(this._loadingScreen);
                        §§goto(addr107);
                     }
                  }
               }
               while(_loc2_)
               {
                  §§goto(addr74);
               }
               §§goto(addr112);
            }
            while(true)
            {
               §§push(this._loadingScreen);
               §§push("[GameData] ");
               if(!_loc2_)
               {
                  §§push(§§pop() + FileUtils.getFileName(param1.url));
                  if(!_loc3_)
                  {
                  }
                  addr90:
                  §§pop().log(§§pop(),LoadingScreen.INFO);
               }
               §§goto(addr90);
            }
         }
         while(true)
         {
            if(_loc2_)
            {
               §§goto(addr102);
            }
            else
            {
               §§goto(addr32);
            }
            §§goto(addr107);
         }
      }
      
      private function onI18nPartialDataReady(param1:LangFileEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(_loc2_)
         {
            §§push(this._loadingScreen);
            §§push("[i18n] ");
            if(!_loc3_)
            {
               §§push(§§pop() + FileUtils.getFileName(param1.url));
               if(_loc2_)
               {
                  §§push(§§pop() + " parsed");
               }
            }
            §§pop().log(§§pop(),LoadingScreen.INFO);
            if(_loc3_)
            {
            }
            addr71:
            return;
         }
         §§push(this);
         §§push("i18n");
         §§push(this._percentPerModule);
         if(_loc2_)
         {
            §§push(1);
            if(_loc3_)
            {
               §§push(§§pop() * 54 * 28 - 1);
            }
            §§push(§§pop() * §§pop());
            if(!_loc2_)
            {
            }
            addr69:
            §§pop().setModulePercent(§§pop(),§§pop(),true);
            §§goto(addr71);
         }
         §§goto(addr69);
      }
      
      private function onDataFileError(param1:FileEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(_loc2_)
         {
            §§push(this._loadingScreen);
            §§push("Unabled to load  ");
            if(!_loc3_)
            {
               §§push(§§pop() + param1.file);
            }
            §§pop().log(§§pop(),LoadingScreen.ERROR);
         }
      }
   }
}
