package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.atouin.renderers.MapRenderer;
   import com.ankamagames.atouin.types.FrustumShape;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   
   public class Proto169Frame extends RegisteringFrame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Proto169Frame));
      
      private static const BOTTOM_LEFT:String = "Bottom-Left";
      
      private static const BOTTOM:String = "Bottom";
      
      private static const BOTTOM_RIGHT:String = "Bottom-Right";
      
      private static const LEFT:String = "Left";
      
      private static const RIGHT:String = "Right";
      
      private static const TOP_LEFT:String = "Top-Left";
      
      private static const TOP:String = "Top";
      
      private static const TOP_RIGHT:String = "Top-Right";
      
      private static const CENTER:String = "Center";
       
      
      private var _mouseTop:Texture;
      
      private var _mouseBottom:Texture;
      
      private var _mouseRight:Texture;
      
      private var _mouseLeft:Texture;
      
      private var _mouseTopBlue:Texture;
      
      private var _mouseBottomBlue:Texture;
      
      private var _mouseRightBlue:Texture;
      
      private var _mouseLeftBlue:Texture;
      
      private var _frustrumName:String;
      
      public function Proto169Frame()
      {
         super();
      }
      
      override protected function registerMessages() : void
      {
      }
      
      override public function pushed() : Boolean
      {
         MapRenderer.bitmapSize.x = AtouinConstants.WIDESCREEN_BITMAP_WIDTH;
         this.init();
         return true;
      }
      
      override public function pulled() : Boolean
      {
         MapRenderer.bitmapSize.x = StageShareManager.startWidth;
         MapRenderer.PROTO_169_BACKGROUND = false;
         return true;
      }
      
      private function init() : void
      {
         var _loc1_:Number = 30;
         var _loc2_:FrustumManager = FrustumManager.getInstance();
         var _loc3_:Sprite = _loc2_.getShape(DirectionsEnum.LEFT);
         while(_loc3_.numChildren)
         {
            _loc3_.removeChildAt(0);
         }
         _loc3_.graphics.beginFill(0,1);
         _loc3_.graphics.drawRect(_loc1_,0,-500,StageShareManager.startHeight);
         _loc3_.graphics.endFill();
         _loc3_.name = LEFT;
         _loc3_.cacheAsBitmap = true;
         var _loc4_:Sprite = _loc2_.getShape(DirectionsEnum.RIGHT);
         while(_loc4_.numChildren)
         {
            _loc4_.removeChildAt(0);
         }
         _loc4_.graphics.beginFill(0,1);
         _loc4_.graphics.drawRect(1250,0,500,StageShareManager.startHeight);
         _loc4_.graphics.endFill();
         _loc4_.name = RIGHT;
         _loc4_.cacheAsBitmap = true;
         var _loc5_:Sprite = _loc2_.getShape(DirectionsEnum.UP);
         while(_loc5_.numChildren)
         {
            _loc5_.removeChildAt(0);
         }
         _loc5_.graphics.beginFill(0,1);
         _loc5_.graphics.drawRect(_loc1_,_loc1_ - 13,1220,-500);
         _loc5_.graphics.endFill();
         _loc5_.name = TOP;
         _loc5_.cacheAsBitmap = true;
         var _loc6_:Sprite = _loc2_.getShape(DirectionsEnum.DOWN);
         while(_loc6_.numChildren)
         {
            _loc6_.removeChildAt(0);
         }
         _loc6_.graphics.beginFill(0,1);
         _loc6_.graphics.drawRect(_loc1_,_loc2_.frustum.bottom - _loc1_ / 2 - 5,1220,_loc2_.frustum.marginBottom + _loc1_ * 2);
         _loc6_.graphics.endFill();
         _loc6_.name = BOTTOM;
         _loc6_.cacheAsBitmap = true;
         _loc3_.alpha = 0;
         _loc4_.alpha = 0;
         _loc5_.alpha = 0;
         _loc6_.alpha = 0;
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         var _loc7_:String = XmlConfig.getInstance().getEntry("config.ui.skin");
         this._mouseBottom = new Texture();
         this._mouseBottom.uri = new Uri(_loc7_ + "assets.swf|cursorBottom");
         this._mouseBottom.finalize();
         this._mouseTop = new Texture();
         this._mouseTop.uri = new Uri(_loc7_ + "assets.swf|cursorTop");
         this._mouseTop.finalize();
         this._mouseRight = new Texture();
         this._mouseRight.uri = new Uri(_loc7_ + "assets.swf|cursorRight");
         this._mouseRight.finalize();
         this._mouseLeft = new Texture();
         this._mouseLeft.uri = new Uri(_loc7_ + "assets.swf|cursorLeft");
         this._mouseLeft.finalize();
         this._mouseBottomBlue = new Texture();
         this._mouseBottomBlue.uri = new Uri(_loc7_ + "assets.swf|cursorBottomBlue");
         this._mouseBottomBlue.finalize();
         this._mouseTopBlue = new Texture();
         this._mouseTopBlue.uri = new Uri(_loc7_ + "assets.swf|cursorTopBlue");
         this._mouseTopBlue.finalize();
         this._mouseRightBlue = new Texture();
         this._mouseRightBlue.uri = new Uri(_loc7_ + "assets.swf|cursorRightBlue");
         this._mouseRightBlue.finalize();
         this._mouseLeftBlue = new Texture();
         this._mouseLeftBlue.uri = new Uri(_loc7_ + "assets.swf|cursorLeftBlue");
         this._mouseLeftBlue.finalize();
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         Sprite(param1.target).alpha = 0;
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         Sprite(param1.target).alpha = 0.1;
         this._frustrumName = param1.target.name;
      }
      
      private function isMouseOverFrustrum(param1:FrustumShape) : Boolean
      {
         if(!param1 || !(param1 is FrustumShape))
         {
            return false;
         }
         return param1.hitTestPoint(StageShareManager.stage.mouseX,StageShareManager.stage.mouseY);
      }
   }
}
