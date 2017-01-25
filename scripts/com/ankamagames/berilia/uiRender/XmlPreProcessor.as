package com.ankamagames.berilia.uiRender
{
   import com.ankamagames.berilia.enums.XmlAttributesEnum;
   import com.ankamagames.berilia.enums.XmlTagsEnum;
   import com.ankamagames.berilia.managers.TemplateManager;
   import com.ankamagames.berilia.types.event.PreProcessEndEvent;
   import com.ankamagames.berilia.types.event.TemplateLoadedEvent;
   import com.ankamagames.berilia.types.template.TemplateParam;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class XmlPreProcessor extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(XmlPreProcessor));
       
      
      private var _xDoc:XMLDocument;
      
      private var _bMustBeRendered:Boolean = true;
      
      private var _aImportFile:Array;
      
      public function XmlPreProcessor(param1:XMLDocument)
      {
         super();
         this._xDoc = param1;
      }
      
      public function get importedFiles() : int
      {
         return this._aImportFile.length;
      }
      
      public function processTemplate() : void
      {
         this._aImportFile = new Array();
         TemplateManager.getInstance().addEventListener(TemplateLoadedEvent.EVENT_TEMPLATE_LOADED,this.onTemplateLoaded);
         this.matchImport(this._xDoc.firstChild);
         if(!this._aImportFile.length)
         {
            dispatchEvent(new PreProcessEndEvent(this));
            TemplateManager.getInstance().removeEventListener(TemplateLoadedEvent.EVENT_TEMPLATE_LOADED,this.onTemplateLoaded);
            return;
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this._aImportFile.length)
         {
            TemplateManager.getInstance().register(this._aImportFile[_loc1_]);
            _loc1_++;
         }
      }
      
      private function matchImport(param1:XMLNode) : void
      {
         var _loc2_:XMLNode = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < param1.childNodes.length)
         {
            _loc2_ = param1.childNodes[_loc3_];
            if(_loc2_.nodeName == XmlTagsEnum.TAG_IMPORT)
            {
               if(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_URL] == null)
               {
                  _log.warn("Attribute \'" + XmlAttributesEnum.ATTRIBUTE_URL + "\' is missing in " + XmlTagsEnum.TAG_IMPORT + " tag.");
               }
               else
               {
                  this._aImportFile.push(LangManager.getInstance().replaceKey(_loc2_.attributes[XmlAttributesEnum.ATTRIBUTE_URL]));
               }
               _loc2_.removeNode();
               _loc3_--;
            }
            else if(_loc2_ != null)
            {
               this.matchImport(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function replaceTemplateCall(param1:XMLNode, param2:int = 0) : Boolean
      {
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:XMLNode = null;
         var _loc6_:XMLNode = null;
         var _loc8_:uint = 0;
         var _loc9_:* = null;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc15_:Boolean = false;
         var _loc16_:String = null;
         var _loc17_:XMLNode = null;
         var _loc7_:Boolean = false;
         if(param2 > 128)
         {
            _log.error("replaceTemplateCall : Recursion depth is too high :" + param2);
            return _loc7_;
         }
         var _loc14_:uint = 0;
         while(_loc14_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc14_];
            _loc15_ = false;
            _loc8_ = 0;
            while(_loc8_ < this._aImportFile.length)
            {
               _loc11_ = this._aImportFile[_loc8_].split("/");
               _loc12_ = _loc11_[_loc11_.length - 1];
               if(_loc12_.toUpperCase() == (_loc3_.nodeName + ".xml").toUpperCase())
               {
                  _loc13_ = new Array();
                  for(_loc9_ in _loc3_.attributes)
                  {
                     _loc13_[_loc9_] = new TemplateParam(_loc9_,_loc3_.attributes[_loc9_]);
                  }
                  _loc10_ = 0;
                  while(_loc10_ < _loc3_.childNodes.length)
                  {
                     _loc4_ = _loc3_.childNodes[_loc10_];
                     _loc16_ = "";
                     for each(_loc17_ in _loc4_.childNodes)
                     {
                        _loc16_ = _loc16_ + _loc17_;
                     }
                     _loc13_[_loc4_.nodeName] = new TemplateParam(_loc4_.nodeName,_loc16_);
                     _loc10_++;
                  }
                  _loc5_ = TemplateManager.getInstance().getTemplate(_loc12_).makeTemplate(_loc13_);
                  _loc10_ = 0;
                  while(_loc10_ < _loc5_.firstChild.childNodes.length)
                  {
                     _loc6_ = _loc5_.firstChild.childNodes[_loc10_].cloneNode(true);
                     _loc3_.parentNode.insertBefore(_loc6_,_loc3_);
                     _loc10_++;
                  }
                  _loc3_.removeNode();
                  _loc3_ = param1.childNodes[_loc14_];
                  _loc7_ = _loc15_ = true;
               }
               _loc8_++;
            }
            _loc7_ = this.replaceTemplateCall(_loc3_,param2 + 1) || _loc7_;
            _loc14_++;
         }
         return _loc7_;
      }
      
      private function onTemplateLoaded(param1:TemplateLoadedEvent) : void
      {
         if(TemplateManager.getInstance().areLoaded(this._aImportFile) && this._bMustBeRendered)
         {
            this._bMustBeRendered = this.replaceTemplateCall(this._xDoc.firstChild);
            if(this._bMustBeRendered)
            {
               this.processTemplate();
            }
            else
            {
               dispatchEvent(new PreProcessEndEvent(this));
               TemplateManager.getInstance().removeEventListener(TemplateLoadedEvent.EVENT_TEMPLATE_LOADED,this.onTemplateLoaded);
            }
         }
      }
   }
}
