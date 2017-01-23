package com.ankamagames.dofus.types
{
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.externalnotification.enums.ExternalNotificationPositionEnum;
   import com.ankamagames.dofus.logic.game.common.frames.ScreenCaptureFrame;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.geom.Point;
   
   public dynamic class DofusOptions extends OptionManager
   {
       
      
      public function DofusOptions()
      {
         super("dofus");
         add("optimize",false);
         add("cacheMapEnabled",true);
         add("optimizeMultiAccount",true);
         add("fullScreen",false);
         add("autoConnectType",1);
         add("showEveryMonsters",false);
         add("allowAnimsFun",true);
         add("turnPicture",true);
         add("mapCoordinates",true);
         add("remindTurn",true);
         add("confirmItemDrop",true);
         add("currentUiSkin",ThemeManager.OFFICIAL_THEME_NAME);
         add("allowBannerShortcuts",true);
         add("dofusQuality",!!AirScanner.isStreamingVersion()?2:1);
         add("askForQualitySelection",!AirScanner.isStreamingVersion());
         add("showNotifications",true);
         add("showUsedPaPm",false);
         add("largeTooltipDelay",500);
         add("spellTooltipDelay",0);
         add("itemTooltipDelay",0);
         add("pinTooltipOnClick",false);
         add("alwaysDisplayTheoreticalEffectsInTooltip",false);
         add("displayTooltips",true);
         add("smallScreenFont",false);
         add("bigMenuButton",false);
         add("allowSpellEffects",true);
         add("allowHitAnim",true);
         add("legalAgreementTou","fr#0");
         add("legalAgreementModsTou","fr#0");
         add("allowLog",BuildInfos.BUILD_TYPE != BuildTypeEnum.RELEASE && !AirScanner.isStreamingVersion());
         add("allowDebug",false);
         add("flashQuality",2);
         add("cellSelectionOnly",true);
         add("orderFighters",false);
         add("showAlignmentWings",false);
         add("showTacticMode",false);
         add("showMovementDistance",false);
         add("hideDeadFighters",true);
         add("hideSummonedFighters",false);
         add("mapFilters",990);
         add("mapFiltersConquest",288);
         add("mapFiltersSearch",256);
         add("showLogPvDetails",true);
         add("notificationsAlphaWindows",false);
         add("notificationsMode",1);
         add("notificationsDisplayDuration",5);
         add("notificationsMaxNumber",5);
         add("notificationsPosition",ExternalNotificationPositionEnum.BOTTOM_RIGHT);
         add("creaturesFightMode",false);
         add("warnOnGuildItemAgression",true);
         add("disableGuildMotd",false);
         add("disableAllianceMotd",false);
         add("zoomOnMouseWheel",true);
         add("showPermanentTargetsTooltips",false);
         add("showDamagesPreview",false);
         add("spectatorAutoShowCurrentFighterInfo",false);
         add("enableForceWalk",true);
         add("showMountsInFight",true);
         add("lastFightIdolUiHidden",false);
         add("havenbagEditPosition",new Point(390,212));
         if(AirScanner.hasAir())
         {
            add("screenshotsDirectory",ScreenCaptureFrame.getDefaultDirectory());
         }
      }
   }
}
