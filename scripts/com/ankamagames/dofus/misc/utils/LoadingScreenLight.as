package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.berilia.types.graphic.ExternalUi;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import flash.display.Bitmap;
   import flash.display.Screen;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   
   public class LoadingScreenLight extends ExternalUi
   {
       
      
      private var _logoFr:Class;
      
      private var _progression:Number;
      
      private var _progressBar:Shape;
      
      public var closeRequestHandler:Function;
      
      public function LoadingScreenLight()
      {
         var _loc3_:Bitmap = null;
         this._logoFr = LoadingScreenLight__logoFr;
         super();
         var _loc1_:UiRootContainer = new UiRootContainer(null,null);
         uiRootContainer = _loc1_;
         var _loc2_:GraphicContainer = new GraphicContainer();
         _loc3_ = new this._logoFr();
         _loc3_.smoothing = true;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(9211020);
         _loc4_.graphics.drawRect(0,0,_loc3_.width,4);
         _loc4_.graphics.endFill();
         _loc4_.graphics.beginFill(9211020);
         _loc4_.graphics.drawRect(1,1,_loc3_.width - 2,2);
         _loc4_.graphics.endFill();
         _loc4_.y = _loc3_.y + _loc3_.height - 61;
         this._progressBar = new Shape();
         this._progressBar.graphics.beginFill(12254976);
         this._progressBar.graphics.drawRect(0,0,_loc3_.width - 2,2);
         this._progressBar.graphics.endFill();
         this._progressBar.scaleX = 0;
         this._progressBar.y = _loc3_.y + _loc3_.height - 60;
         this._progressBar.x = 1;
         _loc1_.addContent(_loc2_);
         _loc2_.addChild(_loc3_);
         _loc2_.addChild(_loc4_);
         _loc2_.addChild(this._progressBar);
         _loc1_.finalize();
         onUiRendered(null);
         stage.nativeWindow.x = (Screen.mainScreen.bounds.width - stage.width) / 2;
         stage.nativeWindow.y = (Screen.mainScreen.bounds.height - stage.height) / 2;
         stage.doubleClickEnabled = true;
         stage.addChild(_loc2_);
         stage.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDblClick);
         alwaysInFront = true;
      }
      
      protected function onDblClick(param1:MouseEvent) : void
      {
         if(this.closeRequestHandler != null)
         {
            this.closeRequestHandler();
         }
      }
      
      public function get progression() : Number
      {
         return this._progression;
      }
      
      public function set progression(param1:Number) : void
      {
         this._progression = Math.min(1,Math.max(0,param1));
         this._progressBar.scaleX = this._progression;
      }
   }
}
