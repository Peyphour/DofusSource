package makers
{
   import d2actions.ShowTacticMode;
   import d2actions.ToggleDematerialization;
   import d2hooks.HideDeadFighters;
   import d2hooks.HideSummonedFighters;
   import d2hooks.OrderFightersSwitched;
   
   public class FightWorldMenuMaker extends WorldMenuMaker
   {
       
      
      public function FightWorldMenuMaker()
      {
         super();
      }
      
      private function onInvisibleModeChange(param1:Boolean) : void
      {
         Api.system.sendAction(new ToggleDematerialization());
      }
      
      private function onCellSelectionOnly(param1:Boolean) : void
      {
         switchOption("dofus","cellSelectionOnly");
      }
      
      private function onShowMovementDistance(param1:Boolean) : void
      {
         switchOption("dofus","showMovementDistance");
      }
      
      private function onShowUsedPaPmChange(param1:Boolean) : void
      {
         switchOption("dofus","showUsedPaPm");
      }
      
      private function onRemindTurnChange(param1:Boolean) : void
      {
         switchOption("dofus","remindTurn");
      }
      
      private function onOrderFightersChange(param1:Boolean) : void
      {
         switchOption("dofus","orderFighters");
         Api.system.dispatchHook(OrderFightersSwitched,param1);
      }
      
      private function onShowTacticMode(param1:Boolean) : void
      {
         switchOption("dofus","showTacticMode");
         Api.system.sendAction(new ShowTacticMode());
      }
      
      private function onHideDeadFighters(param1:Boolean) : void
      {
         switchOption("dofus","hideDeadFighters");
         Api.system.dispatchHook(HideDeadFighters,Api.system.getOption("hideDeadFighters","dofus"));
      }
      
      private function onShowLogPvDetails(param1:Boolean) : void
      {
         switchOption("dofus","showLogPvDetails");
      }
      
      private function onHideSummonedFighters(param1:Boolean) : void
      {
         switchOption("dofus","hideSummonedFighters");
         Api.system.dispatchHook(HideSummonedFighters,Api.system.getOption("hideSummonedFighters","dofus"));
      }
      
      private function onShowPermanentTargetsTooltips(param1:Boolean) : void
      {
         switchOption("dofus","showPermanentTargetsTooltips");
      }
      
      private function onShowDamagesPreview(param1:Boolean) : void
      {
         switchOption("dofus","showDamagesPreview");
      }
      
      private function onShowAlignmentWings(param1:Boolean) : void
      {
         switchOption("dofus","showAlignmentWings");
      }
      
      private function onSpectatorAutoShowCurrentFighterInfo(param1:Boolean) : void
      {
         switchOption("dofus","spectatorAutoShowCurrentFighterInfo");
      }
      
      private function onShowMountsInFight(param1:Boolean) : void
      {
         switchOption("dofus","showMountsInFight");
      }
      
      override public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = super.createMenu(param1,param2);
         var _loc4_:Array = new Array();
         _loc4_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.option.general")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showUsedPaPm"),this.onShowUsedPaPmChange,Api.system.getOption("showUsedPaPm","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.orderFighters"),this.onOrderFightersChange,Api.system.getOption("orderFighters","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showMountsInFight"),this.onShowMountsInFight,Api.system.getOption("showMountsInFight","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.fightTargetMode"),this.onCellSelectionOnly,Api.system.getOption("cellSelectionOnly","dofus"),"cellSelectionOnly"));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showMovementDistance"),this.onShowMovementDistance,Api.system.getOption("showMovementDistance","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.spectatorAutoShowCurrentFighterInfo"),this.onSpectatorAutoShowCurrentFighterInfo,Api.system.getOption("spectatorAutoShowCurrentFighterInfo","dofus")));
         _loc4_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.option.title.rollover")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showDamagesPreview"),this.onShowDamagesPreview,Api.system.getOption("showDamagesPreview","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showAlignmentWings"),this.onShowAlignmentWings,Api.system.getOption("showAlignmentWings","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showPermanentTargetsTooltips"),this.onShowPermanentTargetsTooltips,Api.system.getOption("showPermanentTargetsTooltips","dofus")));
         _loc4_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.option.title.chatAndTimeline")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.showLogPvDetails"),this.onShowLogPvDetails,Api.system.getOption("showLogPvDetails","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.hideDeadFighters"),this.onHideDeadFighters,Api.system.getOption("hideDeadFighters","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.hideSummonedFighters"),this.onHideSummonedFighters,Api.system.getOption("hideSummonedFighters","dofus")));
         _loc4_.push(createItemOption(Api.ui.getText("ui.option.remindTurn"),this.onRemindTurnChange,Api.system.getOption("remindTurn","dofus")));
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.option.fightOptions"),null,null,false,_loc4_));
         return _loc3_;
      }
   }
}
