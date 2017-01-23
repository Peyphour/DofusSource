package com.ankamagames.berilia.types.tooltip
{
   import com.ankamagames.berilia.enums.TooltipChunkTypesEnum;
   import com.ankamagames.berilia.types.data.ChunkData;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class Tooltip
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
       
      
      protected var _log:Logger;
      
      private var _mainblock:TooltipBlock;
      
      private var _blocks:Array;
      
      private var _loadedblock:uint = 0;
      
      private var _mainblockLoaded:Boolean = false;
      
      private var _callbacks:Array;
      
      private var _content:String = "";
      
      private var _useSeparator:Boolean = true;
      
      private var _canMakeTooltip:Boolean;
      
      public var uiModuleName:String;
      
      public var scriptClass:Class;
      
      public var makerName:String;
      
      public var display:UiRootContainer;
      
      public var mustBeHidden:Boolean = true;
      
      public var htmlText:String;
      
      public var chunkType:String = "chunks";
      
      public var strata:int = 4;
      
      public function Tooltip(param1:Uri, param2:Uri, param3:Uri = null)
      {
         this._log = Log.getLogger(getQualifiedClassName(Tooltip));
         this._callbacks = new Array();
         super();
         this._canMakeTooltip = false;
         if(param1 == null && param2 == null)
         {
            return;
         }
         this._blocks = new Array();
         this._mainblock = new TooltipBlock();
         this._mainblock.addEventListener(Event.COMPLETE,this.onMainChunkLoaded);
         if(!param3)
         {
            this._useSeparator = false;
            this._mainblock.initChunk([new ChunkData("main",param1),new ChunkData("container",param2)]);
         }
         else
         {
            this._mainblock.initChunk([new ChunkData("main",param1),new ChunkData("separator",param3),new ChunkData("container",param2)]);
         }
         this._mainblock.init();
         MEMORY_LOG[this] = 1;
      }
      
      public function get mainBlock() : TooltipBlock
      {
         return this._mainblock;
      }
      
      public function addBlock(param1:TooltipBlock) : void
      {
         this._blocks.push(param1);
         param1.addEventListener(Event.COMPLETE,this.onChunkReady);
         param1.init();
      }
      
      public function updateAndReturnHtmlText() : String
      {
         if(this._mainblockLoaded && this._loadedblock == this._blocks.length)
         {
            this._canMakeTooltip = true;
            this.makeHtmlTooltip();
            return this.htmlText;
         }
         this._log.error("Could not return HTML text, blocks were not loaded!");
         return "";
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function askTooltip(param1:Callback) : void
      {
         this._canMakeTooltip = true;
         this._callbacks.push(param1);
         this.processCallback();
      }
      
      public function update(param1:String) : void
      {
         this._canMakeTooltip = true;
         this.processCallback();
      }
      
      private function onMainChunkLoaded(param1:Event) : void
      {
         this._mainblockLoaded = true;
         this.processCallback();
      }
      
      private function processCallback() : void
      {
         if(this._canMakeTooltip && this._mainblockLoaded && this._loadedblock == this._blocks.length)
         {
            if(this.chunkType == TooltipChunkTypesEnum.CHUNK_HTML)
            {
               this.makeHtmlTooltip();
            }
            else
            {
               this.makeTooltip();
            }
            while(this._callbacks.length)
            {
               Callback(this._callbacks.pop()).exec();
            }
         }
      }
      
      private function makeTooltip() : void
      {
         var _loc3_:String = null;
         var _loc4_:TooltipBlock = null;
         var _loc1_:String = this._mainblock.getChunk("separator").processContent(null);
         var _loc2_:Array = new Array();
         for each(_loc4_ in this._blocks)
         {
            _loc3_ = _loc4_.content;
            if(_loc3_)
            {
               _loc2_.push(this._mainblock.getChunk("container").processContent({"content":_loc3_}));
            }
         }
         if(this._useSeparator)
         {
            this._content = this._mainblock.getChunk("main").processContent({"content":_loc2_.join(this._mainblock.getChunk("separator").processContent(null))});
         }
         else
         {
            this._content = this._mainblock.getChunk("main").processContent({"content":_loc2_.join("")});
         }
      }
      
      private function makeHtmlTooltip() : void
      {
         var _loc3_:String = null;
         var _loc4_:TooltipBlock = null;
         this.htmlText = "";
         var _loc1_:String = this._mainblock.getChunk("separator").processContent(null);
         var _loc2_:Array = new Array();
         for each(_loc4_ in this._blocks)
         {
            _loc3_ = _loc4_.content;
            if(_loc3_)
            {
               _loc2_.push(this._mainblock.getChunk("container").processContent({"content":_loc3_}));
               this.htmlText = this.htmlText + LangManager.getInstance().replaceKey(_loc3_,false);
            }
            if(this._useSeparator)
            {
               this.htmlText = this.htmlText + _loc1_;
            }
         }
         if(this._useSeparator)
         {
            this._content = this._mainblock.getChunk("main").processContent({"content":_loc2_.join(this._mainblock.getChunk("separator").processContent(null))});
            this.htmlText = this.htmlText.substr(0,this.htmlText.length - _loc1_.length);
         }
         else
         {
            this._content = this._mainblock.getChunk("main").processContent({"content":_loc2_.join("")});
         }
      }
      
      private function onChunkReady(param1:Event) : void
      {
         this._loadedblock++;
         this.processCallback();
      }
   }
}
