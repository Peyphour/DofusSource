package ui
{
   public class PrivateHistory
   {
       
      
      private var _history:Array;
      
      private var _cursor:int;
      
      private var _maxLength:int;
      
      public function PrivateHistory(param1:int)
      {
         super();
         this._history = new Array();
         this._cursor = -1;
         this._maxLength = param1;
         this.load();
      }
      
      public function get length() : int
      {
         return this._history.length;
      }
      
      private function load() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         var _loc5_:String = null;
         this._history = Api.system.getData("aTchatHistoryPrivate");
         if(this._history)
         {
            if(this._history[0].indexOf("/w ") == 0)
            {
               _loc1_ = this._history;
               this._history = new Array();
               for(_loc4_ in _loc1_)
               {
                  _loc2_ = _loc1_[_loc4_];
                  _loc2_ = _loc2_.substr(3,_loc2_.length - 4);
                  _loc3_ = false;
                  for each(_loc5_ in this._history)
                  {
                     if(_loc5_.toLowerCase() == _loc2_.toLowerCase())
                     {
                        _loc3_ = true;
                        break;
                     }
                  }
                  if(!_loc3_)
                  {
                     this._history.push(_loc2_);
                  }
               }
            }
         }
         else
         {
            this._history = new Array();
         }
      }
      
      public function addName(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         for each(_loc4_ in this._history)
         {
            if(_loc4_.toLowerCase() == param1.toLowerCase())
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this._history.splice(_loc3_,1);
         }
         this._history.push(param1);
         if(this._history.length > this._maxLength)
         {
            this._history = this._history.slice(1,this._history.length);
         }
         Api.system.setData("aTchatHistoryPrivate",this._history);
      }
      
      public function previous() : String
      {
         if(this._history.length == 0)
         {
            return null;
         }
         if(this._cursor == -1 || this._cursor == 0)
         {
            this._cursor = this._history.length;
         }
         this._cursor--;
         return this._history[this._cursor];
      }
      
      public function next() : String
      {
         if(this._history.length == 0)
         {
            return null;
         }
         if(this._cursor == -1)
         {
            this._cursor = 0;
         }
         else
         {
            this._cursor++;
            if(this._cursor == this._history.length)
            {
               this._cursor = 0;
            }
         }
         return this._history[this._cursor];
      }
      
      public function resetCursor() : void
      {
         this._cursor = -1;
      }
   }
}
