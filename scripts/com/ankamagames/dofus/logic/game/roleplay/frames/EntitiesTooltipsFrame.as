package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.EntityMovementStartMessage;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class EntitiesTooltipsFrame implements Frame
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(EntitiesTooltipsFrame));
       
      
      private var _roleplayEntitiesFrame:RoleplayEntitiesFrame;
      
      private var _roleplayWorldFrame:RoleplayWorldFrame;
      
      private var _movingGroups:Vector.<int>;
      
      private var _checkMovingGroups:Boolean;
      
      public var triggeredByShortcut:Boolean;
      
      public function EntitiesTooltipsFrame()
      {
         this._movingGroups = new Vector.<int>();
         super();
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:ShortcutsFrame = Kernel.getWorker().getFrame(ShortcutsFrame) as ShortcutsFrame;
         this._roleplayWorldFrame = Kernel.getWorker().getFrame(RoleplayWorldFrame) as RoleplayWorldFrame;
         if(!this._roleplayWorldFrame || this.triggeredByShortcut && _loc1_.heldShortcuts.indexOf("showEntitiesTooltips") == -1)
         {
            return false;
         }
         this._roleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(this._roleplayEntitiesFrame && this.getNonPlayableEntitiesIds().length > 0)
         {
            this.update();
         }
         this._checkMovingGroups = true;
         EnterFrameDispatcher.addEventListener(this.updateTooltipPos,"EntitiesTooltips",StageShareManager.stage.frameRate);
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,this.onLoadUi);
         Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUnLoadUi);
         KernelEventsManager.getInstance().processCallback(HookList.ShowEntitiesTooltips,true);
         return true;
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc4_:Vector.<Number> = null;
         var _loc5_:Number = NaN;
         if(this._roleplayEntitiesFrame)
         {
            _loc4_ = this.getNonPlayableEntitiesIds();
            for each(_loc5_ in _loc4_)
            {
               this._roleplayWorldFrame.process(new EntityMouseOutMessage(DofusEntities.getEntity(_loc5_) as AnimatedCharacter));
            }
         }
         this._movingGroups.length = 0;
         EnterFrameDispatcher.removeEventListener(this.updateTooltipPos);
         Berilia.getInstance().removeEventListener(UiRenderEvent.UIRenderComplete,this.onLoadUi);
         Berilia.getInstance().removeEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUnLoadUi);
         var _loc2_:ShortcutsFrame = Kernel.getWorker().getFrame(ShortcutsFrame) as ShortcutsFrame;
         var _loc3_:int = _loc2_.heldShortcuts.indexOf("showEntitiesTooltips");
         if(_loc3_ != -1)
         {
            _loc2_.heldShortcuts.splice(_loc3_,1);
         }
         KernelEventsManager.getInstance().processCallback(HookList.ShowEntitiesTooltips,false);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:* = undefined;
         var _loc4_:EntityMouseOverMessage = null;
         var _loc5_:EntityMouseOutMessage = null;
         var _loc6_:GameContextRemoveElementMessage = null;
         var _loc7_:EntityMovementStartMessage = null;
         var _loc8_:EntityMovementCompleteMessage = null;
         var _loc9_:int = 0;
         if(!Kernel.getWorker().contains(RoleplayWorldFrame))
         {
            return false;
         }
         switch(true)
         {
            case param1 is EntityMouseOverMessage:
               _loc4_ = param1 as EntityMouseOverMessage;
               _loc2_ = _loc4_.entity as AnimatedCharacter;
               if(_loc2_ && this.getNonPlayableEntitiesIds().indexOf(_loc2_.getRootEntity().id) != -1)
               {
                  return true;
               }
               break;
            case param1 is EntityMouseOutMessage:
               _loc5_ = param1 as EntityMouseOutMessage;
               _loc2_ = _loc5_.entity as AnimatedCharacter;
               if(_loc2_ && this.getNonPlayableEntitiesIds().indexOf(_loc2_.getRootEntity().id) != -1)
               {
                  return true;
               }
               break;
            case param1 is GameContextRemoveElementMessage:
               _loc6_ = param1 as GameContextRemoveElementMessage;
               TooltipManager.hide("entity_" + _loc6_.id);
               break;
            case param1 is EntityMovementStartMessage:
               _loc7_ = param1 as EntityMovementStartMessage;
               _loc2_ = EntitiesManager.getInstance().getEntity(_loc7_.id) as AnimatedCharacter;
               if(_loc2_ == _loc2_.getRootEntity())
               {
                  if(this._movingGroups.indexOf(_loc2_.id) == -1)
                  {
                     this._movingGroups.push(_loc2_.id);
                  }
               }
               break;
            case param1 is EntityMovementCompleteMessage:
               _loc8_ = param1 as EntityMovementCompleteMessage;
               _loc2_ = EntitiesManager.getInstance().getEntity(_loc8_.id) as AnimatedCharacter;
               if(_loc2_ == _loc2_.getRootEntity())
               {
                  _loc9_ = this._movingGroups.indexOf(_loc2_.id);
                  if(_loc9_ != -1)
                  {
                     this._movingGroups.splice(_loc9_,1);
                  }
               }
               if(this.getNonPlayableEntitiesIds().indexOf(_loc8_.id) != -1)
               {
                  this.update(true);
               }
         }
         return false;
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc5_:Number = NaN;
         var _loc3_:Vector.<Number> = this.getNonPlayableEntitiesIds();
         var _loc4_:int = _loc3_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc5_ = _loc3_[_loc2_];
            if(param1 || !TooltipManager.isVisible("entity_" + _loc5_))
            {
               TooltipPlacer.waitBeforeOrder("tooltip_entity_" + _loc5_);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc5_ = _loc3_[_loc2_];
            if(param1 || !TooltipManager.isVisible("entity_" + _loc5_))
            {
               this.showToolTip(_loc5_);
            }
            _loc2_++;
         }
      }
      
      private function onLoadUi(param1:UiRenderEvent) : void
      {
         if(!Atouin.getInstance().worldIsVisible)
         {
            EnterFrameDispatcher.removeEventListener(this.updateTooltipPos);
            this._checkMovingGroups = false;
         }
      }
      
      private function onUnLoadUi(param1:UiUnloadEvent) : void
      {
         if(param1.name.indexOf("tooltip") == -1)
         {
            this.update();
            if(!this._checkMovingGroups)
            {
               this._checkMovingGroups = true;
               EnterFrameDispatcher.addEventListener(this.updateTooltipPos,"EntitiesTooltips",StageShareManager.stage.frameRate);
            }
         }
      }
      
      private function updateTooltipPos(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this._movingGroups.length > 0)
         {
            for each(_loc2_ in this._movingGroups)
            {
               this.showToolTip(_loc2_);
            }
         }
      }
      
      private function showToolTip(param1:Object) : void
      {
         var _loc2_:AnimatedCharacter = null;
         if(param1 is TiphonEvent)
         {
            _loc2_ = param1.currentTarget;
            _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.showToolTip);
         }
         else
         {
            _loc2_ = DofusEntities.getEntity(param1 as Number) as AnimatedCharacter;
         }
         if(_loc2_)
         {
            if(_loc2_.rendered)
            {
               TooltipManager.hide("entity_" + _loc2_.id);
               if(_loc2_.isMoving && this._movingGroups.indexOf(_loc2_.id) == -1)
               {
                  this._movingGroups.push(_loc2_.id);
               }
               this._roleplayWorldFrame.process(new EntityMouseOverMessage(_loc2_,true,true));
            }
            else
            {
               _loc2_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.showToolTip);
            }
         }
      }
      
      private function getNonPlayableEntitiesIds() : Vector.<Number>
      {
         var _loc2_:int = 0;
         var _loc4_:* = undefined;
         var _loc1_:Vector.<Number> = this._roleplayEntitiesFrame.getEntitiesIdsList();
         var _loc3_:uint = _loc1_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._roleplayEntitiesFrame.getEntityInfos(_loc1_[_loc2_]);
            if(!(_loc4_ is GameRolePlayGroupMonsterInformations || _loc4_ is GameRolePlayNpcInformations || _loc4_ is GameRolePlayTaxCollectorInformations || _loc4_ is GameRolePlayPrismInformations || _loc4_ is GameRolePlayPortalInformations))
            {
               _loc1_.splice(_loc2_,1);
               _loc3_--;
               _loc2_--;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
