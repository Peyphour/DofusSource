package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.uiDefinition.BasicElement;
   import com.ankamagames.berilia.types.uiDefinition.ButtonElement;
   import com.ankamagames.berilia.types.uiDefinition.ContainerElement;
   import com.ankamagames.berilia.types.uiDefinition.StateContainerElement;
   import com.ankamagames.berilia.uiRender.UiRenderer;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.messages.Message;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class MultiGridRenderer implements IGridRenderer
   {
       
      
      protected var _grid:Grid;
      
      protected var _cptNameReferences:Dictionary;
      
      protected var _componentReferences:Dictionary;
      
      protected var _componentReferencesByInstance:Dictionary;
      
      protected var _elemID:uint;
      
      protected var _containerCache:Dictionary;
      
      protected var _uiRenderer:UiRenderer;
      
      protected var _containerDefinition:Dictionary;
      
      protected var _bgColor1:ColorTransform;
      
      protected var _bgColor2:ColorTransform;
      
      protected var _updateFunctionName:String;
      
      protected var _getLineTypeFunctionName:String;
      
      protected var _defaultLineType:String;
      
      protected var _getDataLengthFunctionName:String;
      
      public function MultiGridRenderer(param1:String)
      {
         var _loc2_:Array = null;
         super();
         if(param1)
         {
            _loc2_ = param1.split(",");
            this._updateFunctionName = _loc2_[0];
            this._getLineTypeFunctionName = _loc2_[1];
            this._getDataLengthFunctionName = _loc2_[2];
            if(_loc2_[3])
            {
               this._bgColor1 = new ColorTransform();
               this._bgColor1.color = parseInt(_loc2_[3],16) & 16777215;
               if(_loc2_[3].length > 8)
               {
                  this._bgColor1.alphaMultiplier = ((parseInt(_loc2_[3],16) & 4278190080) >> 24) / 255;
               }
            }
            if(_loc2_[4])
            {
               this._bgColor2 = new ColorTransform();
               this._bgColor2.color = parseInt(_loc2_[4],16) & 16777215;
               if(_loc2_[4].length > 8)
               {
                  this._bgColor2.alphaMultiplier = ((parseInt(_loc2_[4],16) & 4278190080) >> 24) / 255;
               }
            }
            if(_loc2_[5])
            {
               this._bgColor1.alphaMultiplier = parseFloat(_loc2_[5]);
               this._bgColor2.alphaMultiplier = parseFloat(_loc2_[5]);
            }
         }
         this._cptNameReferences = new Dictionary();
         this._componentReferences = new Dictionary();
         this._containerDefinition = new Dictionary();
         this._componentReferencesByInstance = new Dictionary(true);
         this._uiRenderer = new UiRenderer();
         this._containerCache = new Dictionary();
      }
      
      public function set grid(param1:Grid) : void
      {
         if(!this._grid)
         {
            this._grid = param1;
         }
         param1.mouseEnabled = true;
         var _loc2_:UiRootContainer = this._grid.getUi();
         this._uiRenderer.postInit(_loc2_);
      }
      
      public function render(param1:*, param2:uint, param3:Boolean, param4:uint = 0) : DisplayObject
      {
         var _loc5_:GraphicContainer = new GraphicContainer();
         _loc5_.setUi(this._grid.getUi(),SecureCenter.ACCESS_KEY);
         this.update(param1,param2,_loc5_,param3,param4);
         return _loc5_;
      }
      
      public function update(param1:*, param2:uint, param3:DisplayObject, param4:Boolean, param5:uint = 0) : void
      {
         var _loc8_:Sprite = null;
         var _loc6_:UiRootContainer = this._grid.getUi();
         if(!_loc6_.uiClass.hasOwnProperty(this._getLineTypeFunctionName) && !this._defaultLineType || !_loc6_.uiClass.hasOwnProperty(this._updateFunctionName))
         {
            throw new BeriliaError("GetLineType function or update function is not define.");
         }
         var _loc7_:String = !!this._defaultLineType?this._defaultLineType:_loc6_.uiClass[this._getLineTypeFunctionName](param1,param5);
         if(param3.name != _loc7_)
         {
            this.buildLine(param3 as Sprite,_loc7_);
         }
         if(param3 is Sprite)
         {
            _loc8_ = param3 as Sprite;
            if(param2 % 2 == 0)
            {
               _loc8_.graphics.clear();
               if(this._bgColor1)
               {
                  _loc8_.graphics.beginFill(this._bgColor1.color,this._bgColor1.alphaMultiplier);
                  _loc8_.graphics.drawRect(0,0,this._grid.slotWidth,this._grid.slotHeight);
                  _loc8_.graphics.endFill();
               }
            }
            if(param2 % 2 == 1)
            {
               _loc8_.graphics.clear();
               if(this._bgColor2)
               {
                  _loc8_.graphics.beginFill(this._bgColor2.color,this._bgColor2.alphaMultiplier);
                  _loc8_.graphics.drawRect(0,0,this._grid.slotWidth,this._grid.slotHeight);
                  _loc8_.graphics.endFill();
               }
            }
         }
         this.uiUpdate(_loc6_,param3,param1,param4,param5);
      }
      
      protected function uiUpdate(param1:UiRootContainer, param2:DisplayObject, param3:*, param4:Boolean, param5:uint) : void
      {
         if(DisplayObjectContainer(param2).numChildren)
         {
            param1.uiClass[this._updateFunctionName](param3,this._cptNameReferences[DisplayObjectContainer(param2).getChildAt(0)],param4,param5);
         }
      }
      
      public function remove(param1:DisplayObject) : void
      {
         param1.visible = false;
      }
      
      public function destroy() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc1_ in this._componentReferences)
         {
            _loc2_ = _loc1_;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is GraphicContainer)
               {
                  _loc3_.remove();
               }
            }
         }
         this._componentReferences = null;
         this._componentReferencesByInstance = null;
         this._grid = null;
      }
      
      public function getDataLength(param1:*, param2:Boolean) : uint
      {
         var _loc3_:UiRootContainer = this._grid.getUi();
         if(_loc3_.uiClass.hasOwnProperty(this._getDataLengthFunctionName))
         {
            return _loc3_.uiClass[this._getDataLengthFunctionName](param1,param2);
         }
         return 1;
      }
      
      public function renderModificator(param1:Array) : Array
      {
         var _loc2_:ContainerElement = null;
         for each(_loc2_ in param1)
         {
            this._containerDefinition[_loc2_.name] = _loc2_;
         }
         return [];
      }
      
      public function eventModificator(param1:Message, param2:String, param3:Array, param4:UIComponent) : String
      {
         return param2;
      }
      
      protected function buildLine(param1:Sprite, param2:String) : void
      {
         var _loc7_:* = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         if(param1.name == param2)
         {
            return;
         }
         if(!this._containerCache[param2])
         {
            this._containerCache[param2] = [];
         }
         if(this._containerDefinition[param1.name])
         {
            if(!this._containerCache[param1.name])
            {
               this._containerCache[param1.name] = [];
            }
            if(param1.numChildren)
            {
               this._containerCache[param1.name].push(param1.getChildAt(0));
               param1.removeChildAt(0);
            }
         }
         param1.name = !!param2?param2:"#########EMPTY";
         if(!param2)
         {
            return;
         }
         if(this._containerCache[param2].length)
         {
            param1.addChild(this._containerCache[param2].pop());
            return;
         }
         var _loc3_:UiRootContainer = this._grid.getUi();
         var _loc4_:GraphicContainer = new GraphicContainer();
         _loc4_.setUi(_loc3_,SecureCenter.ACCESS_KEY);
         _loc4_.mouseEnabled = false;
         param1.addChild(_loc4_);
         var _loc5_:Array = [];
         this._uiRenderer.makeChilds([this.copyElement(this._containerDefinition[param2],_loc5_)],_loc4_,true);
         _loc3_.render();
         var _loc6_:Object = {};
         for(_loc7_ in _loc5_)
         {
            _loc8_ = _loc7_.indexOf("_m_");
            _loc9_ = _loc7_;
            if(_loc8_ != -1)
            {
               _loc9_ = _loc9_.substr(0,_loc8_);
            }
            _loc6_[_loc9_] = _loc3_.getElement(_loc5_[_loc7_]);
         }
         this._cptNameReferences[_loc4_] = _loc6_;
         this._elemID++;
      }
      
      protected function copyElement(param1:BasicElement, param2:Object) : BasicElement
      {
         var _loc4_:Array = null;
         var _loc5_:BasicElement = null;
         var _loc6_:StateContainerElement = null;
         var _loc7_:StateContainerElement = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc3_:BasicElement = new (getDefinitionByName(getQualifiedClassName(param1)) as Class)();
         param1.copy(_loc3_);
         if(_loc3_.name)
         {
            _loc3_.setName(_loc3_.name + "_m_" + this._grid.name + "_" + this._elemID);
            param2[param1.name] = _loc3_.name;
         }
         else
         {
            _loc3_.setName("elem_m_" + this._grid.name + "_" + BasicElement.ID++);
         }
         if(_loc3_ is ContainerElement)
         {
            _loc4_ = new Array();
            for each(_loc5_ in ContainerElement(param1).childs)
            {
               _loc4_.push(this.copyElement(_loc5_,param2));
            }
            ContainerElement(_loc3_).childs = _loc4_;
         }
         if(_loc3_ is StateContainerElement)
         {
            _loc6_ = _loc3_ as StateContainerElement;
            _loc7_ = param1 as StateContainerElement;
            _loc8_ = new Array();
            for(_loc10_ in _loc7_.stateChangingProperties)
            {
               _loc9_ = parseInt(_loc10_);
               for(_loc11_ in _loc7_.stateChangingProperties[_loc9_])
               {
                  if(!_loc8_[_loc9_])
                  {
                     _loc8_[_loc9_] = [];
                  }
                  _loc8_[_loc9_][_loc11_ + "_m_" + this._grid.name + "_" + this._elemID] = _loc7_.stateChangingProperties[_loc9_][_loc11_];
               }
            }
            _loc6_.stateChangingProperties = _loc8_;
         }
         if(_loc3_ is ButtonElement)
         {
            if(_loc3_.properties["linkedTo"])
            {
               _loc3_.properties["linkedTo"] = _loc3_.properties["linkedTo"] + "_m_" + this._grid.name + "_" + this._elemID;
            }
         }
         return _loc3_;
      }
   }
}
