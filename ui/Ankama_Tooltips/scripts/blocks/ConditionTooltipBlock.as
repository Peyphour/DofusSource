package blocks
{
   import flash.xml.XMLNode;
   import flash.xml.XMLNodeType;
   
   public class ConditionTooltipBlock
   {
       
      
      private var _conditions:Object;
      
      private var _criteria:String;
      
      private var _content:String;
      
      private var _titleText:String;
      
      private var _onTarget:Boolean;
      
      private var _block:Object;
      
      public function ConditionTooltipBlock(param1:Object, param2:String, param3:String = null, param4:Boolean = false, param5:String = "chunks")
      {
         super();
         this._conditions = param1;
         this._criteria = param2;
         this._onTarget = param4;
         if(param3)
         {
            this._titleText = param3;
         }
         else
         {
            this._titleText = Api.ui.getText("ui.common.conditions");
         }
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("subTitle",param5 + "/base/subTitle.txt"),Api.tooltip.createChunkData("effect",param5 + "/effect/effect.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:* = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:Object = null;
         if(this._conditions == null || this._conditions.criteria == null || this._conditions.criteria.length == 0)
         {
            return;
         }
         this._content = this._block.getChunk("subTitle").processContent({"text":this._titleText});
         var _loc1_:String = "";
         for each(_loc2_ in this._conditions.criteria)
         {
            _loc3_ = 0;
            _loc4_ = "";
            _loc5_ = _loc2_.isRespected;
            _loc6_ = "requirement";
            _loc7_ = _loc2_.text.indexOf("|");
            _loc9_ = 0;
            _loc10_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _loc2_.inlineCriteria.length)
            {
               _loc12_ = _loc2_.inlineCriteria[_loc8_];
               if(_loc12_.text != "")
               {
                  _loc4_ = "";
                  if(_loc3_ > 0)
                  {
                     if(_loc7_ > 0)
                     {
                        _loc4_ = Api.ui.getText("ui.common.or") + " ";
                     }
                  }
                  if(this._onTarget)
                  {
                     _loc4_ = "(" + Api.ui.getText("ui.item.target") + ") ";
                  }
                  if(!_loc5_ && !_loc12_.isRespected)
                  {
                     _loc6_ = "malus";
                     _loc4_ = _loc4_ + _loc12_.text;
                  }
                  else
                  {
                     _loc4_ = _loc4_ + _loc12_.text;
                  }
                  if(_loc2_.inlineCriteria.length > 1 && _loc8_ == _loc9_ && this._conditions.operators && this._conditions.operators.indexOf("|") != -1)
                  {
                     _loc4_ = "(" + _loc4_;
                  }
                  if(_loc11_ == "|")
                  {
                     _loc4_ = Api.ui.getText("ui.common.or") + " " + _loc4_;
                     _loc11_ = "null";
                  }
                  else if(_loc11_ == "&")
                  {
                     _loc4_ = Api.ui.getText("ui.common.and") + " " + _loc4_;
                     _loc11_ = "null";
                  }
                  if(_loc2_.inlineCriteria.length > 1)
                  {
                     if(_loc8_ != _loc9_ && _loc8_ == _loc2_.inlineCriteria.length - 1 && this._conditions.operators)
                     {
                        _loc4_ = _loc4_ + ")";
                        if(this._conditions.operators && this._conditions.operators.length > _loc10_)
                        {
                           _loc11_ = this._conditions.operators[_loc10_];
                        }
                        _loc10_++;
                     }
                  }
                  else if(this._conditions.criteria.length > 1 && this._conditions.operators)
                  {
                     if(this._conditions.operators[_loc10_] == "|")
                     {
                        _loc11_ = this._conditions.operators[_loc10_];
                        _loc10_++;
                     }
                  }
                  _loc3_++;
               }
               else if(_loc8_ == 0)
               {
                  _loc9_++;
               }
               if(_loc4_)
               {
                  _loc4_ = XML(new XMLNode(XMLNodeType.TEXT_NODE,_loc4_)).toXMLString();
                  _loc1_ = _loc1_ + this._block.getChunk("effect").processContent({
                     "text":_loc4_,
                     "cssClass":_loc6_,
                     "li":""
                  },{"valueCssClass":"value"});
               }
               _loc8_++;
            }
         }
         if(_loc1_ == "")
         {
            this._content = "";
         }
         else
         {
            this._content = this._content + _loc1_;
         }
      }
      
      public function getContent() : String
      {
         return this._content;
      }
      
      public function get block() : Object
      {
         return this._block;
      }
   }
}
