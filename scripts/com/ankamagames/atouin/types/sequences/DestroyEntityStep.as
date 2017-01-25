package com.ankamagames.atouin.types.sequences
{
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   
   public class DestroyEntityStep extends AbstractSequencable
   {
       
      
      private var _entity:IEntity;
      
      private var _waitAnim:Boolean;
      
      private var _waitAnimForCallback:Boolean;
      
      public function DestroyEntityStep(param1:IEntity, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this._entity = param1;
         this._waitAnim = param2;
         this._waitAnimForCallback = param3;
      }
      
      override public function start() : void
      {
         var _loc1_:TiphonSprite = this._entity as TiphonSprite;
         if(this._waitAnim && _loc1_)
         {
            if(_loc1_.isPlayingAnimation())
            {
               this.addAnimEndListeners();
            }
            else if(!_loc1_.libraryIsAvailable)
            {
               this.addAnimEndListeners();
               _loc1_.addEventListener(TiphonEvent.SPRITE_INIT_FAILED,this.destroyEntity);
            }
            else
            {
               this.destroyEntity();
            }
         }
         else
         {
            this.destroyEntity();
         }
         if(!this._waitAnimForCallback)
         {
            executeCallbacks();
         }
      }
      
      private function addAnimEndListeners() : void
      {
         (this._entity as TiphonSprite).addEventListener(TiphonEvent.ANIMATION_END,this.destroyEntity);
         (this._entity as TiphonSprite).addEventListener(TiphonEvent.ANIMATION_TRANSITION_END,this.destroyEntity);
      }
      
      private function destroyEntity(param1:TiphonEvent = null) : void
      {
         if(param1)
         {
            param1.currentTarget.removeEventListener(TiphonEvent.ANIMATION_END,this.destroyEntity);
            param1.currentTarget.removeEventListener(TiphonEvent.ANIMATION_TRANSITION_END,this.destroyEntity);
            param1.currentTarget.removeEventListener(TiphonEvent.SPRITE_INIT_FAILED,this.destroyEntity);
         }
         if(this._entity is IDisplayable)
         {
            (this._entity as IDisplayable).remove();
         }
         if(this._entity is TiphonSprite)
         {
            (this._entity as TiphonSprite).destroy();
         }
         if(param1 && this._waitAnimForCallback)
         {
            executeCallbacks();
         }
      }
   }
}
