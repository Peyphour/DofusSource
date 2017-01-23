package com.ankamagames.berilia.api
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class UiApi
   {
       
      
      public function UiApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function loadUi(param1:String, param2:String = null, param3:* = null, param4:uint = 1, param5:String = null, param6:Boolean = false, param7:Boolean = false, param8:Boolean = true) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function loadUiInside(param1:String, param2:GraphicContainer, param3:String = null, param4:* = null) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function unloadUi(param1:String = null) : void
      {
      }
      
      [Untrusted]
      public function getUi(param1:String) : *
      {
         return null;
      }
      
      [Untrusted]
      public function getUiInstances() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getModuleList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getModule(param1:String, param2:Boolean = false) : UiModule
      {
         return null;
      }
      
      [Untrusted]
      public function handleComponentRestaureState(param1:GraphicContainer, param2:Array = null, param3:Boolean = true) : void
      {
      }
      
      [Trusted]
      public function setModuleEnable(param1:String, param2:Boolean) : void
      {
      }
      
      [Trusted]
      public function addChild(param1:Object, param2:Object) : void
      {
      }
      
      [Trusted]
      public function removeChild(param1:Object, param2:Object) : void
      {
      }
      
      [Trusted]
      public function addChildAt(param1:Object, param2:Object, param3:int) : void
      {
      }
      
      [Untrusted]
      public function me() : UiRootContainer
      {
         return null;
      }
      
      [Trusted]
      public function initDefaultBinds() : void
      {
      }
      
      [Untrusted]
      public function addShortcutHook(param1:String, param2:Function, param3:Boolean = false) : void
      {
      }
      
      [Untrusted]
      public function addComponentHook(param1:GraphicContainer, param2:String) : void
      {
      }
      
      [Untrusted]
      public function removeComponentHook(param1:GraphicContainer, param2:String) : void
      {
      }
      
      [Trusted]
      public function bindApi(param1:Texture, param2:String, param3:*) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function resetUiSavedUserModification(param1:String = null) : void
      {
      }
      
      [Untrusted]
      public function createComponent(param1:String, ... rest) : GraphicContainer
      {
         return null;
      }
      
      [Untrusted]
      public function createContainer(param1:String, ... rest) : *
      {
         return null;
      }
      
      [Untrusted]
      public function createInstanceEvent(param1:DisplayObject, param2:*) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getEventClassName(param1:String) : String
      {
         return null;
      }
      
      [Untrusted]
      public function addInstanceEvent(param1:Object) : void
      {
      }
      
      [Untrusted]
      public function clearPositionCache(param1:String = null) : void
      {
      }
      
      [Untrusted]
      public function createUri(param1:String, param2:Boolean = false) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function showTooltip(param1:*, param2:*, param3:Boolean = false, param4:String = "standard", param5:uint = 0, param6:uint = 2, param7:int = 3, param8:String = null, param9:Class = null, param10:Object = null, param11:String = null, param12:Boolean = false, param13:int = 4, param14:Number = 1, param15:String = "") : void
      {
      }
      
      [Untrusted]
      public function hideTooltip(param1:String = null) : void
      {
      }
      
      [Untrusted]
      public function textTooltipInfo(param1:String, param2:String = null, param3:String = null, param4:int = 400) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getRadioGroupSelectedItem(param1:String, param2:UiRootContainer) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function setRadioGroupSelectedItem(param1:String, param2:Object, param3:UiRootContainer) : void
      {
      }
      
      [Untrusted]
      public function keyIsDown(param1:uint) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function keyIsUp(param1:uint) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function convertToTreeData(param1:*) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function setFollowCursorUri(param1:*, param2:Boolean = false, param3:Boolean = false, param4:int = 0, param5:int = 0, param6:Number = 1) : void
      {
      }
      
      [Untrusted]
      public function getFollowCursorUri() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function endDrag() : void
      {
      }
      
      [Untrusted]
      public function preloadCss(param1:String) : void
      {
      }
      
      [Trusted]
      public function setLabelStyleSheet(param1:Label, param2:String) : void
      {
      }
      
      [Untrusted]
      public function getMouseX() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getMouseY() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getMouseDown() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getStartWidth() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getStartHeight() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getStageWidth() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getStageHeight() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getVisibleStageBounds() : Rectangle
      {
         return null;
      }
      
      [Untrusted]
      public function getWindowWidth() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getWindowHeight() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getWindowScale() : Number
      {
         return 0;
      }
      
      [Trusted]
      public function setFullScreen(param1:Boolean, param2:Boolean = false) : void
      {
      }
      
      [Untrusted]
      public function isFullScreen() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function setShortcutUsedToExitFullScreen(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function useIME() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function place(param1:*, param2:uint, param3:uint, param4:int, param5:GraphicContainer = null) : void
      {
      }
      
      [Trusted]
      public function buildOrnamentTooltipFrom(param1:Texture, param2:Rectangle) : void
      {
      }
      
      [Untrusted]
      public function getTextSize(param1:String, param2:Object, param3:String) : Rectangle
      {
         return null;
      }
      
      [Trusted]
      public function setComponentMinMaxSize(param1:GraphicContainer, param2:Point, param3:Point) : void
      {
      }
      
      [Untrusted]
      public function isUiLoading(param1:String) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getColor(param1:String) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function replaceParams(param1:String, param2:Array, param3:String = "%") : String
      {
         return null;
      }
      
      [Untrusted]
      public function replaceKey(param1:String) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getText(param1:String, ... rest) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getTextFromKey(param1:uint, param2:String = "%", ... rest) : String
      {
         return null;
      }
      
      [Untrusted]
      public function processText(param1:String, param2:String, param3:Boolean = true) : String
      {
         return null;
      }
      
      [Untrusted]
      public function decodeText(param1:String, param2:Array) : String
      {
         return null;
      }
   }
}
