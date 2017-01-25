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
   
   public class CameraZoomStep extends AbstractSequencable
   {
       
      
      private var _camera:Camera;
      
      private var _args:Array;
      
      private var _instant:Boolean;
      
      private var _targetPos:Point;
      
      private var _container:DisplayObjectContainer;
      
      public function CameraZoomStep(param1:Camera, param2:Array, param3:Boolean)
      {
         super();
         this._camera = param1;
         this._args = param2;
         this._instant = param3;
         this._container = Atouin.getInstance().rootContainer;
      }
      
      override public function start() : void
      {
         var _loc4_:Object = null;
         var _loc5_:TweenLite = null;
         var _loc1_:MapPoint = ScriptsUtil.getMapPoint(this._args);
         var _loc2_:GraphicCell = InteractiveCellManager.getInstance().getCell(_loc1_.cellId);
         var _loc3_:Point = _loc2_.parent.localToGlobal(new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2));
         this._targetPos = this._container.globalToLocal(_loc3_);
         if(this._instant)
         {
            this._camera.zoomOnPos(this._camera.currentZoom,this._targetPos.x,this._targetPos.y);
            executeCallbacks();
         }
         else
         {
            _loc4_ = {"zoom":Atouin.getInstance().currentZoom};
            _loc5_ = new TweenLite(_loc4_,1,{
               "zoom":this._camera.currentZoom,
               "onUpdate":this.updateZoom,
               "onUpdateParams":[_loc4_],
               "onComplete":this.zoomComplete
            });
         }
      }
      
      private function updateZoom(param1:Object) : void
      {
         this._camera.zoomOnPos(param1.zoom,this._targetPos.x,this._targetPos.y);
      }
      
      private function zoomComplete() : void
      {
         executeCallbacks();
      }
   }
}
