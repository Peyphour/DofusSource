package com.ankamagames.dofus.internalDatacenter.house
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.atouin.data.elements.GraphicalElementTypes;
   import com.ankamagames.atouin.data.elements.subtypes.NormalGraphicalElementData;
   import com.ankamagames.atouin.enums.HavenbagLayersEnum;
   import com.ankamagames.berilia.interfaces.ICustomSlotData;
   import com.ankamagames.dofus.datacenter.houses.HavenbagFurniture;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.ColorMultiplicator;
   import com.ankamagames.jerakine.types.Uri;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class HavenbagFurnitureWrapper extends HavenbagFurniture implements IDataCenter, ICustomSlotData
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HavenbagFurnitureWrapper));
      
      private static var _unknownElement:NormalGraphicalElementData;
      
      private static var _cache:Array = new Array();
      
      private static var _errorIconUri:Uri;
       
      
      private var _iconUri:Uri;
      
      private var _fullSizeIconUri:Uri;
      
      private var _element:NormalGraphicalElementData;
      
      private var _colorTransform:ColorTransform;
      
      private var _backGroundIconUri:Uri;
      
      public function HavenbagFurnitureWrapper()
      {
         super();
      }
      
      public static function create(param1:int) : HavenbagFurnitureWrapper
      {
         var _loc2_:HavenbagFurnitureWrapper = null;
         var _loc3_:HavenbagFurniture = null;
         if(!_cache[param1])
         {
            _loc3_ = HavenbagFurniture.getFurniture(param1);
            if(!_loc3_)
            {
               _log.error("No furniture found with typeId " + param1 + ", using a debug default one");
               _loc3_ = new HavenbagFurniture();
               _loc3_.typeId = param1;
               _loc3_.themeId = 1;
               _loc3_.color = int.MAX_VALUE;
               _loc3_.layerId = HavenbagLayersEnum.FLOOR;
               _loc3_.blocksMovement = true;
               _loc3_.isStackable = false;
               _loc3_.elementId = 0;
               _loc3_.cellsWidth = 1;
               _loc3_.cellsHeight = 1;
               _loc3_.order = 0;
            }
            _loc2_ = new HavenbagFurnitureWrapper();
            _loc2_.typeId = _loc3_.typeId;
            _loc2_.themeId = _loc3_.themeId;
            _loc2_.color = _loc3_.color;
            _loc2_.skillId = _loc3_.skillId;
            _loc2_.layerId = _loc3_.layerId;
            _loc2_.blocksMovement = _loc3_.blocksMovement;
            _loc2_.isStackable = _loc3_.isStackable;
            _loc2_.elementId = _loc3_.elementId;
            _loc2_.cellsWidth = _loc3_.cellsWidth;
            _loc2_.cellsHeight = _loc3_.cellsHeight;
            _loc2_.order = _loc3_.order;
            _cache[param1] = _loc2_;
         }
         else
         {
            _loc2_ = _cache[param1];
         }
         return _loc2_;
      }
      
      public function get colorTransform() : ColorTransform
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(color != int.MAX_VALUE && !this._colorTransform)
         {
            _loc1_ = (color & 16711680) >> 16;
            _loc2_ = (color & 65280) >> 8;
            _loc3_ = color & 255;
            this._colorTransform = new ColorTransform(ColorMultiplicator.clamp(_loc1_ * 2,0,512) / 255,ColorMultiplicator.clamp(_loc2_ * 2,0,512) / 255,ColorMultiplicator.clamp(_loc3_ * 2,0,512) / 255);
         }
         return this._colorTransform;
      }
      
      public function get size() : Point
      {
         return this.element.size;
      }
      
      public function get iconUri() : Uri
      {
         if(!this._iconUri)
         {
            if(this.element)
            {
               this._iconUri = new Uri(Atouin.getInstance().options.elementsPath + "/" + Atouin.getInstance().options.pngSubPath + "/" + this.element.gfxId + "." + Atouin.getInstance().options.mapPictoExtension);
            }
            else
            {
               this._iconUri = this.errorIconUri;
            }
         }
         return this._iconUri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         return null;
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri((XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap") as String).concat("error.png"));
         }
         return _errorIconUri;
      }
      
      public function get backGroundIconUri() : Uri
      {
         if(!this._backGroundIconUri)
         {
            this._backGroundIconUri = new Uri((XmlConfig.getInstance().getEntry("config.ui.skin") as String).concat("texture/slot/emptySlot.png"));
         }
         return this._backGroundIconUri;
      }
      
      public function set backGroundIconUri(param1:Uri) : void
      {
         this._backGroundIconUri = param1;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function set endTime(param1:int) : void
      {
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function get element() : NormalGraphicalElementData
      {
         if(!this._element)
         {
            this._element = Elements.getInstance().getElementData(elementId) as NormalGraphicalElementData;
            if(!this._element)
            {
               _log.error("Couldn\'t find the element " + elementId + " for furniture typeId " + typeId + ", loading default one");
               if(!_unknownElement)
               {
                  _unknownElement = new NormalGraphicalElementData(elementId,GraphicalElementTypes.NORMAL);
                  _unknownElement.gfxId = 0;
                  _unknownElement.height = 0;
                  _unknownElement.horizontalSymmetry = false;
                  _unknownElement.origin = new Point(16,16);
                  _unknownElement.size = new Point(32,32);
               }
               this._element = _unknownElement;
            }
         }
         return this._element;
      }
   }
}
