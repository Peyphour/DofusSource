package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.types.data.RadioGroup;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import flash.display.DisplayObjectContainer;
   
   public class UiRootContainer extends GraphicContainer
   {
       
      
      public function UiRootContainer()
      {
         super();
      }
      
      public function get windowOwner() : Object
      {
         return new Object();
      }
      
      public function set windowOwner(param1:Object) : void
      {
      }
      
      public function get uiClass() : *
      {
         return null;
      }
      
      public function set uiClass(param1:*) : void
      {
      }
      
      public function get uiModule() : UiModule
      {
         return new UiModule();
      }
      
      public function set uiModule(param1:UiModule) : void
      {
      }
      
      public function get strata() : int
      {
         return new int();
      }
      
      public function set strata(param1:int) : void
      {
      }
      
      public function get depth() : int
      {
         return new int();
      }
      
      public function set depth(param1:int) : void
      {
      }
      
      public function get scalable() : Boolean
      {
         return new Boolean();
      }
      
      public function set scalable(param1:Boolean) : void
      {
      }
      
      public function get modal() : Boolean
      {
         return new Boolean();
      }
      
      public function set modal(param1:Boolean) : void
      {
      }
      
      public function get giveFocus() : Boolean
      {
         return new Boolean();
      }
      
      public function set giveFocus(param1:Boolean) : void
      {
      }
      
      public function get modalIndex() : uint
      {
         return new uint();
      }
      
      public function set modalIndex(param1:uint) : void
      {
      }
      
      public function get radioGroup() : Array
      {
         return new Array();
      }
      
      public function set radioGroup(param1:Array) : void
      {
      }
      
      public function get cached() : Boolean
      {
         return new Boolean();
      }
      
      public function set cached(param1:Boolean) : void
      {
      }
      
      public function get hideAfterLoading() : Boolean
      {
         return new Boolean();
      }
      
      public function set hideAfterLoading(param1:Boolean) : void
      {
      }
      
      public function get transmitFocus() : Boolean
      {
         return new Boolean();
      }
      
      public function set transmitFocus(param1:Boolean) : void
      {
      }
      
      public function get constants() : Array
      {
         return new Array();
      }
      
      public function set constants(param1:Array) : void
      {
      }
      
      public function get tempHolder() : DisplayObjectContainer
      {
         return new DisplayObjectContainer();
      }
      
      public function set tempHolder(param1:DisplayObjectContainer) : void
      {
      }
      
      public function get restoreSnapshotAfterLoading() : Boolean
      {
         return new Boolean();
      }
      
      public function set restoreSnapshotAfterLoading(param1:Boolean) : void
      {
      }
      
      public function get fullscreen() : Boolean
      {
         return false;
      }
      
      public function set fullscreen(param1:Boolean) : void
      {
      }
      
      public function get properties() : *
      {
         return null;
      }
      
      public function set properties(param1:*) : void
      {
      }
      
      public function set useCustomSize(param1:Boolean) : void
      {
      }
      
      public function get useCustomSize() : Boolean
      {
         return false;
      }
      
      public function set disableRender(param1:Boolean) : void
      {
      }
      
      public function get disableRender() : Boolean
      {
         return false;
      }
      
      public function get ready() : Boolean
      {
         return false;
      }
      
      public function set modalContainer(param1:GraphicContainer) : void
      {
      }
      
      public function set showModalContainer(param1:Boolean) : void
      {
      }
      
      public function get uiData() : UiData
      {
         return null;
      }
      
      public function get scriptTime() : Number
      {
         return 0;
      }
      
      public function get childIndex() : int
      {
         return 0;
      }
      
      public function set childIndex(param1:int) : void
      {
      }
      
      public function get magneticElements() : Array
      {
         return null;
      }
      
      public function addElement(param1:String, param2:Object) : void
      {
      }
      
      public function removeElement(param1:String) : void
      {
      }
      
      public function getElement(param1:String) : GraphicContainer
      {
         return null;
      }
      
      public function getElements() : Array
      {
         return null;
      }
      
      public function getConstant(param1:String) : *
      {
         return null;
      }
      
      public function iAmFinalized(param1:Object) : void
      {
      }
      
      public function render() : void
      {
      }
      
      public function registerMagneticElement(param1:GraphicContainer) : void
      {
      }
      
      public function removeMagneticElement(param1:GraphicContainer) : void
      {
      }
      
      public function registerId(param1:String, param2:GraphicElement) : void
      {
      }
      
      public function deleteId(param1:String) : void
      {
      }
      
      public function getElementById(param1:String) : GraphicElement
      {
         return null;
      }
      
      public function removeFromRenderList(param1:String) : void
      {
      }
      
      public function addDynamicSizeElement(param1:GraphicElement) : void
      {
      }
      
      public function addDynamicElement(param1:GraphicElement) : void
      {
      }
      
      public function addPostFinalizeComponent(param1:Object) : void
      {
      }
      
      public function addFinalizeElement(param1:Object) : void
      {
      }
      
      public function addRadioGroup(param1:String) : RadioGroup
      {
         return null;
      }
      
      public function getRadioGroup(param1:String) : RadioGroup
      {
         return null;
      }
      
      public function addLinkedUi(param1:String) : void
      {
      }
      
      public function removeLinkedUi(param1:String) : void
      {
      }
      
      public function updateLinkedUi() : void
      {
      }
      
      public function call(param1:Function, param2:Array, param3:Object) : void
      {
      }
      
      public function destroyUi(param1:Object) : void
      {
      }
      
      public function makeSnapshot() : void
      {
      }
      
      public function setOnTop() : void
      {
      }
      
      public function processLocation(param1:GraphicElement) : void
      {
      }
   }
}
