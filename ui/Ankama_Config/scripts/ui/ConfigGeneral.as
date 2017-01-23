package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import d2actions.ChangeScreenshotsDirectory;
   import d2actions.FriendGuildSetWarnOnAchievementComplete;
   import d2actions.FriendOrGuildMemberLevelUpWarningSet;
   import d2actions.FriendWarningSet;
   import d2actions.WarnOnHardcoreDeath;
   import d2hooks.ConfigPropertyChange;
   import d2hooks.FriendGuildWarnOnAchievementCompleteState;
   import d2hooks.FriendOrGuildMemberLevelUpWarningState;
   import d2hooks.FriendWarningState;
   import d2hooks.HideDeadFighters;
   import d2hooks.HideSummonedFighters;
   import d2hooks.OrderFightersSwitched;
   import d2hooks.WarnOnHardcoreDeathState;
   import types.ConfigProperty;
   
   public class ConfigGeneral extends ConfigUi
   {
       
      
      public var bindsApi:BindsApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var btn_alwaysShowGrid:ButtonContainer;
      
      public var btn_transparentOverlayMode:ButtonContainer;
      
      public var btn_showMapCoordinates:ButtonContainer;
      
      public var btn_remindTurn:ButtonContainer;
      
      public var btn_warnWhenFriendOrGuildMemberLvlUp:ButtonContainer;
      
      public var btn_warnWhenFriendIsOnline:ButtonContainer;
      
      public var btn_warnWhenFriendOrGuildAchieves:ButtonContainer;
      
      public var btn_disableGuildMotd:ButtonContainer;
      
      public var btn_disableAllianceMotd:ButtonContainer;
      
      public var btn_warnOnGuildItemAgression:ButtonContainer;
      
      public var btn_warnOnHardcoreDeath:ButtonContainer;
      
      public var btn_showUSedPaPm:ButtonContainer;
      
      public var btn_cellSelectionOnly:ButtonContainer;
      
      public var btn_orderFighters:ButtonContainer;
      
      public var btn_showAlignmentWings:ButtonContainer;
      
      public var btn_showInsideAutoZoom:ButtonContainer;
      
      public var btn_showMovementDistance:ButtonContainer;
      
      public var btn_hideDeadFighters:ButtonContainer;
      
      public var btn_hideSummonedFighters:ButtonContainer;
      
      public var btn_showLogPvDetails:ButtonContainer;
      
      public var btn_showPermanentTargetsTooltips:ButtonContainer;
      
      public var btn_showDamagesPreview:ButtonContainer;
      
      public var btn_spectatorAutoShowCurrentFighterInfo:ButtonContainer;
      
      public var btn_enableForceWalk:ButtonContainer;
      
      public var btn_showMountsInFight:ButtonContainer;
      
      public var lbl_screenshotPath:Label;
      
      public var btn_changeDirectory:ButtonContainer;
      
      private var btn_zoomOnMouseWheel:ButtonContainer;
      
      private var btn_skipTurnWhenDone:ButtonContainer;
      
      public function ConfigGeneral()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("btn_alwaysShowGrid","alwaysShowGrid","atouin"));
         _loc2_.push(new ConfigProperty("btn_transparentOverlayMode","transparentOverlayMode","atouin"));
         _loc2_.push(new ConfigProperty("btn_showMapCoordinates","mapCoordinates","dofus"));
         _loc2_.push(new ConfigProperty("btn_zoomOnMouseWheel","zoomOnMouseWheel","dofus"));
         _loc2_.push(new ConfigProperty("btn_blackBorder","hideBlackBorder","atouin"));
         _loc2_.push(new ConfigProperty("btn_remindTurn","remindTurn","dofus"));
         _loc2_.push(new ConfigProperty("btn_showUSedPaPm","showUsedPaPm","dofus"));
         _loc2_.push(new ConfigProperty("btn_cellSelectionOnly","cellSelectionOnly","dofus"));
         _loc2_.push(new ConfigProperty("btn_orderFighters","orderFighters","dofus"));
         _loc2_.push(new ConfigProperty("btn_showAlignmentWings","showAlignmentWings","dofus"));
         _loc2_.push(new ConfigProperty("btn_showMovementDistance","showMovementDistance","dofus"));
         _loc2_.push(new ConfigProperty("btn_hideDeadFighters","hideDeadFighters","dofus"));
         _loc2_.push(new ConfigProperty("btn_hideSummonedFighters","hideSummonedFighters","dofus"));
         _loc2_.push(new ConfigProperty("btn_showLogPvDetails","showLogPvDetails","dofus"));
         _loc2_.push(new ConfigProperty("btn_showPermanentTargetsTooltips","showPermanentTargetsTooltips","dofus"));
         _loc2_.push(new ConfigProperty("btn_showDamagesPreview","showDamagesPreview","dofus"));
         _loc2_.push(new ConfigProperty("btn_spectatorAutoShowCurrentFighterInfo","spectatorAutoShowCurrentFighterInfo","dofus"));
         _loc2_.push(new ConfigProperty("btn_showMountsInFight","showMountsInFight","dofus"));
         _loc2_.push(new ConfigProperty("btn_warnOnGuildItemAgression","warnOnGuildItemAgression","dofus"));
         _loc2_.push(new ConfigProperty("btn_disableGuildMotd","disableGuildMotd","dofus"));
         _loc2_.push(new ConfigProperty("btn_disableAllianceMotd","disableAllianceMotd","dofus"));
         _loc2_.push(new ConfigProperty("btn_enableForceWalk","enableForceWalk","dofus"));
         sysApi.addHook(ConfigPropertyChange,this.onConfigPropertyChange);
         sysApi.addHook(FriendWarningState,this.onFriendWarningState);
         sysApi.addHook(FriendOrGuildMemberLevelUpWarningState,this.onFriendOrGuildMemberLevelUpWarningState);
         sysApi.addHook(FriendGuildWarnOnAchievementCompleteState,this.onFriendGuildWarnOnAchievementCompleteState);
         sysApi.addHook(WarnOnHardcoreDeathState,this.onWarnOnHardcoreDeathState);
         this.btn_warnWhenFriendIsOnline.selected = this.socialApi.getWarnOnFriendConnec();
         this.btn_warnWhenFriendOrGuildAchieves.selected = this.socialApi.getWarnWhenFriendOrGuildMemberAchieve();
         this.btn_warnWhenFriendOrGuildMemberLvlUp.selected = this.socialApi.getWarnWhenFriendOrGuildMemberLvlUp();
         this.btn_warnOnHardcoreDeath.selected = this.socialApi.getWarnOnHardcoreDeath();
         this.lbl_screenshotPath.text = sysApi.getOption("screenshotsDirectory","dofus");
         uiApi.addComponentHook(this.btn_cellSelectionOnly,"onRollOver");
         uiApi.addComponentHook(this.btn_cellSelectionOnly,"onRollOut");
         uiApi.addComponentHook(this.btn_showMovementDistance,"onRollOver");
         uiApi.addComponentHook(this.btn_showMovementDistance,"onRollOut");
         uiApi.addComponentHook(this.btn_orderFighters,"onRollOver");
         uiApi.addComponentHook(this.btn_orderFighters,"onRollOut");
         uiApi.addComponentHook(this.btn_showLogPvDetails,"onRollOver");
         uiApi.addComponentHook(this.btn_showLogPvDetails,"onRollOut");
         uiApi.addComponentHook(this.btn_warnOnHardcoreDeath,"onRollOver");
         uiApi.addComponentHook(this.btn_warnOnHardcoreDeath,"onRollOut");
         uiApi.addComponentHook(this.btn_disableGuildMotd,"onRollOver");
         uiApi.addComponentHook(this.btn_disableGuildMotd,"onRollOut");
         uiApi.addComponentHook(this.btn_disableGuildMotd,"onRelease");
         uiApi.addComponentHook(this.btn_disableAllianceMotd,"onRollOver");
         uiApi.addComponentHook(this.btn_disableAllianceMotd,"onRollOut");
         uiApi.addComponentHook(this.btn_enableForceWalk,"onRollOver");
         uiApi.addComponentHook(this.btn_enableForceWalk,"onRollOut");
         uiApi.addComponentHook(this.btn_changeDirectory,"onRelease");
         uiApi.addComponentHook(this.btn_warnWhenFriendIsOnline,"onRelease");
         uiApi.addComponentHook(this.btn_warnWhenFriendOrGuildMemberLvlUp,"onRelease");
         uiApi.addComponentHook(this.btn_warnWhenFriendOrGuildAchieves,"onRelease");
         uiApi.addComponentHook(this.btn_warnOnHardcoreDeath,"onRelease");
         init(_loc2_);
      }
      
      override public function reset() : void
      {
         super.reset();
         init(_properties);
         this.btn_warnWhenFriendIsOnline.selected = true;
         this.btn_warnWhenFriendOrGuildMemberLvlUp.selected = true;
         this.btn_warnWhenFriendOrGuildAchieves.selected = true;
         this.btn_warnOnHardcoreDeath.selected = true;
         sysApi.sendAction(new FriendOrGuildMemberLevelUpWarningSet(true));
         sysApi.sendAction(new FriendGuildSetWarnOnAchievementComplete(true));
         sysApi.sendAction(new WarnOnHardcoreDeath(true));
         sysApi.sendAction(new FriendWarningSet(true));
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
      }
      
      override public function onRelease(param1:Object) : void
      {
         super.onRelease(param1);
         switch(param1)
         {
            case this.btn_warnWhenFriendOrGuildMemberLvlUp:
               sysApi.sendAction(new FriendOrGuildMemberLevelUpWarningSet(this.btn_warnWhenFriendOrGuildMemberLvlUp.selected));
               break;
            case this.btn_warnWhenFriendIsOnline:
               sysApi.sendAction(new FriendWarningSet(this.btn_warnWhenFriendIsOnline.selected));
               break;
            case this.btn_warnWhenFriendOrGuildAchieves:
               sysApi.sendAction(new FriendGuildSetWarnOnAchievementComplete(this.btn_warnWhenFriendOrGuildAchieves.selected));
               break;
            case this.btn_warnOnHardcoreDeath:
               sysApi.sendAction(new WarnOnHardcoreDeath(this.btn_warnOnHardcoreDeath.selected));
               break;
            case this.btn_orderFighters:
               sysApi.dispatchHook(OrderFightersSwitched,this.btn_orderFighters.selected);
               break;
            case this.btn_hideDeadFighters:
               sysApi.dispatchHook(HideDeadFighters,this.btn_hideDeadFighters.selected);
               break;
            case this.btn_hideSummonedFighters:
               sysApi.dispatchHook(HideSummonedFighters,this.btn_hideSummonedFighters.selected);
               break;
            case this.btn_changeDirectory:
               sysApi.sendAction(new ChangeScreenshotsDirectory());
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_cellSelectionOnly:
               _loc2_ = uiApi.getText("ui.option.fightTargetModeTooltip");
               break;
            case this.btn_orderFighters:
               _loc2_ = uiApi.getText("ui.option.orderFightersTooltip");
               break;
            case this.btn_showMovementDistance:
               _loc2_ = uiApi.getText("ui.option.showMovementDistanceTooltip");
               break;
            case this.btn_showLogPvDetails:
               _loc2_ = uiApi.getText("ui.option.showLogPvDetailsTooltip");
               break;
            case this.btn_disableGuildMotd:
               _loc2_ = uiApi.getText("ui.option.disableGuildMotdTooltip");
               break;
            case this.btn_disableAllianceMotd:
               _loc2_ = uiApi.getText("ui.option.disableAllianceMotdTooltip");
               break;
            case this.btn_warnOnHardcoreDeath:
               _loc2_ = uiApi.getText("ui.option.showHardcoreDeathTooltip");
               break;
            case this.btn_enableForceWalk:
               _loc2_ = uiApi.getText("ui.option.enableForceWalkTooltip");
         }
         uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      private function onConfigPropertyChange(param1:String, param2:String, param3:*, param4:*) : void
      {
         if(param1 == "dofus" && param2 == "screenshotsDirectory")
         {
            this.lbl_screenshotPath.text = param3;
         }
      }
      
      private function onFriendWarningState(param1:Boolean) : void
      {
         this.btn_warnWhenFriendIsOnline.selected = param1;
      }
      
      private function onFriendOrGuildMemberLevelUpWarningState(param1:Boolean) : void
      {
         this.btn_warnWhenFriendOrGuildMemberLvlUp.selected = param1;
      }
      
      private function onFriendGuildWarnOnAchievementCompleteState(param1:Boolean) : void
      {
         this.btn_warnWhenFriendOrGuildAchieves.selected = param1;
      }
      
      private function onWarnOnHardcoreDeathState(param1:Boolean) : void
      {
         this.btn_warnOnHardcoreDeath.selected = param1;
      }
   }
}
