package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   import org.flintparticles.common.renderers.Renderer;
   import org.flintparticles.twoD.renderers.BitmapRenderer;
   import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
   import org.flintparticles.twoD.renderers.PixelRenderer;
   
   public class ParticuleEmitterEntity extends Sprite implements IDisplayable, IEntity
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Projectile));
      
      public static const NORMAL_RENDERER_TYPE:uint = 0;
      
      public static const BITMAP_RENDERER_TYPE:uint = 1;
      
      public static const PIXEL_RENDERER_TYPE:uint = 2;
       
      
      private var _id:Number;
      
      private var _position:MapPoint;
      
      private var _renderer:Renderer;
      
      private var _displayed:Boolean;
      
      private var _displayBehavior:IDisplayBehavior;
      
      public function ParticuleEmitterEntity(param1:int, param2:uint)
      {
         super();
         this.id = param1;
         switch(param2)
         {
            case NORMAL_RENDERER_TYPE:
               this._renderer = new DisplayObjectRenderer();
               break;
            case BITMAP_RENDERER_TYPE:
               this._renderer = new BitmapRenderer(new Rectangle(0,0,StageShareManager.stage.stageWidth,StageShareManager.stage.stageHeight));
               break;
            case PIXEL_RENDERER_TYPE:
               this._renderer = new PixelRenderer(new Rectangle(0,0,StageShareManager.stage.stageWidth,StageShareManager.stage.stageHeight));
         }
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return this._displayBehavior;
      }
      
      public function set displayBehaviors(param1:IDisplayBehavior) : void
      {
         this._displayBehavior = param1;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function set id(param1:Number) : void
      {
         this._id = param1;
      }
      
      public function get position() : MapPoint
      {
         return this._position;
      }
      
      public function set position(param1:MapPoint) : void
      {
         this._position = param1;
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return this._displayBehavior.getAbsoluteBounds(this);
      }
      
      public function get displayed() : Boolean
      {
         return this._displayed;
      }
      
      public function display(param1:uint = 0) : void
      {
         this._displayBehavior.display(this,param1);
         this._displayed = true;
      }
      
      public function remove() : void
      {
         this._displayed = false;
      }
   }
}
