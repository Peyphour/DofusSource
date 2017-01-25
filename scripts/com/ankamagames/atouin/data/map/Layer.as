package com.ankamagames.atouin.data.map
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.IDataInput;
   import flash.utils.getQualifiedClassName;
   
   public class Layer
   {
      
      public static const LAYER_GROUND:uint = 0;
      
      public static const LAYER_ADDITIONAL_GROUND:uint = 1;
      
      public static const LAYER_DECOR:uint = 2;
      
      public static const LAYER_ADDITIONAL_DECOR:uint = 3;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Layer));
       
      
      public var layerId:int;
      
      public var refCell:int = 0;
      
      public var cellsCount:int;
      
      public var cells:Array;
      
      private var _map:Map;
      
      public function Layer(param1:Map)
      {
         super();
         this._map = param1;
      }
      
      public function get map() : Map
      {
         return this._map;
      }
      
      public function fromRaw(param1:IDataInput, param2:int) : void
      {
         var i:int = 0;
         var c:Cell = null;
         var raw:IDataInput = param1;
         var mapVersion:int = param2;
         try
         {
            if(mapVersion >= 9)
            {
               this.layerId = raw.readByte();
            }
            else
            {
               this.layerId = raw.readInt();
            }
            this.cellsCount = raw.readShort();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("  (Layer) Cells count : " + this.cellsCount);
            }
            this.cells = new Array();
            i = 0;
            while(i < this.cellsCount)
            {
               c = new Cell(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("  (Layer) Cell at index " + i + " :");
               }
               c.fromRaw(raw,mapVersion);
               this.cells.push(c);
               i++;
            }
            return;
         }
         catch(e:*)
         {
            throw e;
         }
      }
   }
}
