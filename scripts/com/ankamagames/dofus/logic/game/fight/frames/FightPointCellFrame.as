package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellRequestMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.getQualifiedClassName;
   
   public class FightPointCellFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightPointCellFrame));
      
      private static const TARGET_COLOR:Color = new Color(16548386);
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
      
      private static var _instance:FightPointCellFrame;
       
      
      private var _targetSelection:Selection;
      
      public function FightPointCellFrame()
      {
         super();
      }
      
      public static function getInstance() : FightPointCellFrame
      {
         return _instance;
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function pushed() : Boolean
      {
         _instance = this;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:KeyboardKeyUpMessage = null;
         var _loc3_:CellOverMessage = null;
         var _loc4_:EntityMouseOverMessage = null;
         var _loc5_:CellClickMessage = null;
         var _loc6_:EntityClickMessage = null;
         switch(true)
         {
            case param1 is KeyboardKeyUpMessage:
               _loc2_ = param1 as KeyboardKeyUpMessage;
               if(_loc2_.keyboardEvent.keyCode == 27)
               {
                  this.cancelShow();
                  return true;
               }
               return false;
            case param1 is CellOverMessage:
               _loc3_ = param1 as CellOverMessage;
               this.refreshTarget(_loc3_.cellId);
               return true;
            case param1 is EntityMouseOverMessage:
               _loc4_ = param1 as EntityMouseOverMessage;
               this.refreshTarget(_loc4_.entity.position.cellId);
               return true;
            case param1 is MouseClickMessage:
               if(!(MouseClickMessage(param1).target is GraphicCell) && !(MouseClickMessage(param1).target is TiphonSprite))
               {
                  this.cancelShow();
               }
               return true;
            case param1 is CellClickMessage:
               _loc5_ = param1 as CellClickMessage;
               this.showCell(_loc5_.cellId);
               return true;
            case param1 is EntityClickMessage:
               _loc6_ = param1 as EntityClickMessage;
               this.showCell(_loc6_.entity.position.cellId);
               return true;
            case param1 is AdjacentMapClickMessage:
               this.cancelShow();
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         _instance = null;
         return true;
      }
      
      private function refreshTarget(param1:uint) : void
      {
         if(this.isValidCell(param1))
         {
            if(!this._targetSelection)
            {
               this._targetSelection = new Selection();
               this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
               this._targetSelection.color = TARGET_COLOR;
               this._targetSelection.zone = new Cross(0,0,DataMapProvider.getInstance());
               SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_TARGET);
            }
            SelectionManager.getInstance().update(SELECTION_TARGET,param1);
         }
         else
         {
            this.removeTarget();
         }
      }
      
      private function removeTarget() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_TARGET);
         if(_loc1_)
         {
            _loc1_.remove();
            this._targetSelection = null;
         }
      }
      
      public function showCell(param1:uint) : void
      {
         var _loc2_:ShowCellRequestMessage = null;
         var _loc3_:String = null;
         var _loc4_:ChatClientMultiMessage = null;
         if(this.isValidCell(param1))
         {
            _loc2_ = new ShowCellRequestMessage();
            _loc2_.initShowCellRequestMessage(param1);
            ConnectionsHandler.getConnection().send(_loc2_);
            _loc3_ = I18n.getUiText("ui.fightAutomsg.cell",["{cell," + param1 + "::" + param1 + "}"]);
            _loc4_ = new ChatClientMultiMessage();
            _loc4_.initChatClientMultiMessage(_loc3_,ChatActivableChannelsEnum.CHANNEL_TEAM);
            ConnectionsHandler.getConnection().send(_loc4_);
         }
         this.cancelShow();
      }
      
      public function cancelShow() : void
      {
         this.removeTarget();
         KernelEventsManager.getInstance().processCallback(HookList.ShowCell);
         Kernel.getWorker().removeFrame(this);
      }
      
      private function isValidCell(param1:uint) : Boolean
      {
         return DataMapProvider.getInstance().pointMov(MapPoint.fromCellId(param1).x,MapPoint.fromCellId(param1).y,true);
      }
   }
}
