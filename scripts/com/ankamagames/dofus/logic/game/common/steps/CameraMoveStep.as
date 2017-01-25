package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.dofus.misc.utils.Camera;
   import com.ankamagames.dofus.scripts.ScriptsUtil;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import gs.TweenLite;
   
   public class CameraMoveStep extends AbstractSequencable
   {
       
      
      private var _camera:Camera;
      
      private var _args:Array;
      
      private var _instant:Boolean;
      
      private var _targetPos:Point;
      
      private var _container:DisplayObjectContainer;
      
      public function CameraMoveStep(param1:Camera, param2:Array, param3:Boolean)
      {
         super();
         this._camera = param1;
         this._args = param2;
         this._instant = param3;
         this._container = Atouin.getInstance().worldContainer;
      }
      
      override public function start() : void
      {
         var _loc1_:MapPoint = null;
         var _loc2_:GraphicCell = null;
         var _loc3_:Point = null;
         var _loc4_:Object = null;
         var _loc5_:TweenLite = null;
         if(this._camera.currentZoom > Atouin.getInstance().options.frustum.scale && !isNaN(this._camera.x) && !isNaN(this._camera.y))
         {
            _loc1_ = ScriptsUtil.getMapPoint(this._args);
            _loc2_ = InteractiveCellManager.getInstance().getCell(_loc1_.cellId);
            _loc3_ = _loc2_.parent.localToGlobal(new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2));
            this._targetPos = this._container.globalToLocal(_loc3_);
            if(this._instant)
            {
               this._camera.zoomOnPos(this._camera.currentZoom,this._targetPos.x,this._targetPos.y);
               executeCallbacks();
            }
            else
            {
               _loc4_ = {
                  "x":this._camera.x,
                  "y":this._camera.y
               };
               _loc5_ = new TweenLite(_loc4_,2,{
                  "x":this._targetPos.x,
                  "y":this._targetPos.y,
                  "onUpdate":this.updatePos,
                  "onUpdateParams":[_loc4_],
                  "onComplete":this.moveComplete
               });
            }
         }
      }
      
      private function updatePos(param1:Object) : void
      {
         this._camera.zoomOnPos(this._camera.currentZoom,param1.x,param1.y);
      }
      
      private function moveComplete() : void
      {
         executeCallbacks();
      }
   }
}
