package com.ankamagames.dofus.logic.game.common.misc.stackedMessages
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.types.SpriteWrapper;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.messages.CharacterMovementStoppedMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseEndedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseErrorMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUsedMessage;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.managers.FiltersManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.InteractiveObject;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   
   public class InteractiveElementBehavior extends AbstractBehavior
   {
      
      private static var interactiveElements:Array = new Array();
      
      private static var currentElementId:int = -1;
      
      private static const ACTION_WAYPOINT:uint = 3;
      
      private static const ACTION_CLASS_STATUE:uint = 15;
      
      private static const FILTER_1:GlowFilter = new GlowFilter(16777215,0.8,6,6,4);
      
      private static const FILTER_2:GlowFilter = new GlowFilter(2845168,0.8,4,4,2);
       
      
      public var interactiveElement:InteractiveElement;
      
      public var currentSkillInstanceId:int;
      
      private var _tmpInteractiveElementId:int;
      
      private var _isMoving:Boolean;
      
      private var _time:int = 1000;
      
      private var _startTime:int = 0;
      
      private var _timeOutRecolte:int = 0;
      
      private var _duration:int;
      
      private var _lastCellExpected:int = -1;
      
      private var _isFreeMovement:Boolean = false;
      
      public function InteractiveElementBehavior()
      {
         super();
         this._startTime = 0;
         this._timeOutRecolte = 0;
         type = ALWAYS;
         isAvailableToStart = false;
         this._isMoving = false;
      }
      
      override public function processInputMessage(param1:Message, param2:String) : Boolean
      {
         var _loc4_:InteractiveElementActivationMessage = null;
         var _loc5_:Interactive = null;
         var _loc6_:Skill = null;
         var _loc7_:InteractiveElementSkill = null;
         var _loc8_:IEntity = null;
         var _loc9_:InteractiveElementUpdatedMessage = null;
         canBeStacked = true;
         var _loc3_:Boolean = false;
         if(param1 is MouseClickMessage)
         {
            this._isFreeMovement = !((param1 as MouseClickMessage).target is SpriteWrapper);
            return false;
         }
         if(param1 is InteractiveElementActivationMessage)
         {
            _loc4_ = param1 as InteractiveElementActivationMessage;
            type = ALWAYS;
            _loc5_ = Interactive.getInteractiveById(_loc4_.interactiveElement.elementTypeId);
            if(_loc5_)
            {
               for each(_loc7_ in _loc4_.interactiveElement.enabledSkills)
               {
                  _loc6_ = Skill.getSkillById(_loc7_.skillId);
                  if(_loc6_.elementActionId == ACTION_CLASS_STATUE || _loc6_.elementActionId == ACTION_WAYPOINT)
                  {
                     type = STOP;
                  }
               }
            }
            else
            {
               type = NORMAL;
               if(param2 == ALWAYS)
               {
                  canBeStacked = false;
                  return false;
               }
            }
            this.interactiveElement = _loc4_.interactiveElement;
            this.currentSkillInstanceId = _loc4_.skillInstanceId;
            position = _loc4_.position;
            interactiveElements[_loc4_.interactiveElement.elementId] = true;
            InteractiveElementBehavior.currentElementId = _loc4_.interactiveElement.elementId;
            pendingMessage = param1;
            _loc3_ = true;
         }
         else if(param1 is GameMapMovementMessage)
         {
            _loc8_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
            if((param1 as GameMapMovementMessage).actorId == PlayedCharacterManager.getInstance().id && (param1 as GameMapMovementMessage).keyMovements[0] == _loc8_.position.cellId)
            {
               this._isMoving = true;
               if(this._isFreeMovement)
               {
                  this._lastCellExpected = (param1 as GameMapMovementMessage).keyMovements[(param1 as GameMapMovementMessage).keyMovements.length - 1];
               }
               else
               {
                  this._lastCellExpected = -1;
               }
            }
         }
         else if(param1 is CharacterMovementStoppedMessage)
         {
            this._lastCellExpected = -1;
            this._isMoving = false;
         }
         else if(param2 == ALWAYS && param1 is CellClickMessage && this._isMoving)
         {
            isAvailableToStart = false;
            _loc3_ = true;
            canBeStacked = false;
         }
         else if(param1 is InteractiveElementUpdatedMessage)
         {
            _loc9_ = param1 as InteractiveElementUpdatedMessage;
            if(_loc9_.interactiveElement.enabledSkills.length)
            {
               interactiveElements[_loc9_.interactiveElement.elementId] = true;
            }
            else if(_loc9_.interactiveElement.disabledSkills.length && interactiveElements[_loc9_.interactiveElement.elementId])
            {
               interactiveElements[_loc9_.interactiveElement.elementId] = null;
            }
         }
         return _loc3_;
      }
      
      override public function checkAvailability(param1:Message) : void
      {
         if(this._startTime != 0 && getTimer() >= this._startTime + this._time)
         {
            isAvailableToStart = false;
            this._startTime = 0;
         }
         if(PlayedCharacterManager.getInstance().isFighting)
         {
            this._startTime = 0;
            isAvailableToStart = false;
         }
         else if(param1 is InteractiveUsedMessage && (param1 as InteractiveUsedMessage).entityId == PlayedCharacterManager.getInstance().id)
         {
            isAvailableToStart = true;
            this._tmpInteractiveElementId = (param1 as InteractiveUsedMessage).elemId;
            this._startTime = 0;
         }
         else if(param1 is InteractiveUseEndedMessage && this._tmpInteractiveElementId == (param1 as InteractiveUseEndedMessage).elemId)
         {
            this._startTime = getTimer();
         }
      }
      
      override public function processOutputMessage(param1:Message, param2:String) : Boolean
      {
         var _loc3_:* = false;
         if(param1 is InteractiveUseEndedMessage)
         {
            this.stopAction();
            _loc3_ = true;
         }
         else if(param1 is InteractiveUseErrorMessage)
         {
            this.stopAction();
            _loc3_ = true;
            actionStarted = true;
         }
         else if(param1 is InteractiveUsedMessage)
         {
            this.removeIcon();
            this._duration = (param1 as InteractiveUsedMessage).duration * 100;
            this._timeOutRecolte = getTimer();
            actionStarted = true;
            _loc3_ = this._duration == 0;
         }
         else if(this._timeOutRecolte > 0 && getTimer() > this._timeOutRecolte + this._duration + 1000)
         {
            this.stopAction();
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function stopAction() : void
      {
         actionStarted = false;
         InteractiveElementBehavior.currentElementId = -1;
         this.removeIcon();
      }
      
      override public function isAvailableToProcess(param1:Message) : Boolean
      {
         if(interactiveElements[this.interactiveElement.elementId])
         {
            return true;
         }
         return false;
      }
      
      override public function addIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:InteractiveElementSkill = null;
         var _loc3_:Skill = null;
         var _loc4_:InteractiveObject = null;
         if(this.interactiveElement == null)
         {
            return;
         }
         for each(_loc2_ in this.interactiveElement.enabledSkills)
         {
            if(_loc2_.skillInstanceUid == this.currentSkillInstanceId)
            {
               _loc1_ = _loc2_.skillId;
               break;
            }
         }
         _loc3_ = Skill.getSkillById(_loc1_);
         sprite = RoleplayInteractivesFrame.getCursor(_loc3_.cursor,true,false);
         sprite.y = sprite.y - sprite.height;
         sprite.x = sprite.x - sprite.width / 2;
         sprite.transform.colorTransform = new ColorTransform(0.33,0.33,0.33,0.5,0,0,0,0);
         _loc4_ = Atouin.getInstance().getIdentifiedElement(this.interactiveElement.elementId);
         FiltersManager.getInstance().addEffect(_loc4_,FILTER_1);
         FiltersManager.getInstance().addEffect(_loc4_,FILTER_2);
         super.addIcon();
      }
      
      override public function removeIcon() : void
      {
         if(this.interactiveElement == null)
         {
            return;
         }
         var _loc1_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(this.interactiveElement.elementId);
         if(_loc1_)
         {
            FiltersManager.getInstance().removeEffect(_loc1_,FILTER_1);
            FiltersManager.getInstance().removeEffect(_loc1_,FILTER_2);
         }
         super.removeIcon();
      }
      
      override public function remove() : void
      {
         InteractiveElementBehavior.currentElementId = -1;
         super.remove();
      }
      
      override public function copy() : AbstractBehavior
      {
         var _loc1_:InteractiveElementBehavior = new InteractiveElementBehavior();
         _loc1_.pendingMessage = this.pendingMessage;
         _loc1_.interactiveElement = this.interactiveElement;
         _loc1_.position = this.position;
         _loc1_.sprite = this.sprite;
         _loc1_.currentSkillInstanceId = this.currentSkillInstanceId;
         _loc1_.isAvailableToStart = this.isAvailableToStart;
         _loc1_.type = this.type;
         return _loc1_;
      }
      
      override public function isMessageCatchable(param1:Message) : Boolean
      {
         if(param1 is GameMapMovementMessage)
         {
            return !(this._isMoving || actionStarted);
         }
         return true;
      }
      
      override public function get canBeRemoved() : Boolean
      {
         return this.interactiveElement.elementId != InteractiveElementBehavior.currentElementId;
      }
      
      override public function get needToWait() : Boolean
      {
         return this._isMoving && this._lastCellExpected != -1;
      }
      
      override public function getFakePosition() : MapPoint
      {
         var _loc1_:MapPoint = new MapPoint();
         _loc1_.cellId = this._lastCellExpected;
         return _loc1_;
      }
   }
}
