package com.ankamagames.jerakine.utils.pattern
{
   public class PatternDecoder
   {
       
      
      public function PatternDecoder()
      {
         super();
      }
      
      public static function getDescription(param1:String, param2:Array) : String
      {
         var _loc3_:Array = param1.split("");
         var _loc4_:String = decodeDescription(_loc3_,param2).join("");
         return _loc4_;
      }
      
      public static function combine(param1:String, param2:String, param3:Boolean) : String
      {
         if(!param1)
         {
            return "";
         }
         var _loc4_:Array = param1.split("");
         var _loc5_:Object = new Object();
         _loc5_.m = param2 == "m";
         _loc5_.f = param2 == "f";
         _loc5_.n = param2 == "n";
         _loc5_.p = !param3;
         _loc5_.s = param3;
         var _loc6_:String = decodeCombine(_loc4_,_loc5_).join("");
         return _loc6_;
      }
      
      public static function decode(param1:String, param2:Array) : String
      {
         if(!param1)
         {
            return "";
         }
         return decodeCombine(param1.split(""),param2).join("");
      }
      
      public static function replace(param1:String, param2:String) : String
      {
         var _loc5_:Array = null;
         var _loc3_:Array = param1.split("##");
         var _loc4_:uint = 1;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_].split(",");
            _loc3_[_loc4_] = getDescription(param2,_loc5_);
            _loc4_ = _loc4_ + 2;
         }
         return _loc3_.join("");
      }
      
      public static function replaceStr(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:Array = param1.split(param2);
         return _loc4_.join(param3);
      }
      
      private static function findOptionnalDices(param1:Array, param2:Array) : Array
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = param1;
         var _loc6_:Number = find(param1,"{");
         var _loc7_:Number = find(param1,"}");
         if(_loc6_ >= 0 && _loc7_ > _loc6_)
         {
            _loc8_ = 0;
            while(param1[_loc6_ - (_loc8_ + 1)] == " ")
            {
               _loc8_++;
            }
            _loc9_ = 0;
            while(param1[_loc7_ + (_loc9_ + 1)] == " ")
            {
               _loc9_++;
            }
            _loc3_ = param1.slice(0,_loc6_ - (2 + _loc8_));
            _loc4_ = param1.slice(_loc7_ - _loc6_ + 5 + _loc9_ + _loc8_,param1.length - (_loc7_ - _loc6_));
            if(param1[0] == "#" && param1[param1.length - 2] == "#")
            {
               if(param2[1] == null && param2[2] == null && param2[3] == null)
               {
                  _loc3_.push(param2[0]);
               }
               else if(param2[0] == 0 && param2[1] == 0)
               {
                  _loc3_.push(param2[2]);
               }
               else if(!param2[2])
               {
                  param1.splice(param1.indexOf("#"),2,param2[0]);
                  param1.splice(param1.indexOf("{"),1);
                  param1.splice(param1.indexOf("~"),4);
                  param1.splice(param1.indexOf("#"),2,param2[1]);
                  param1.splice(param1.indexOf("}"),1);
                  _loc3_ = _loc3_.concat(param1);
               }
               else
               {
                  param1.splice(param1.indexOf("#"),2,param2[0] + param2[2]);
                  param1.splice(param1.indexOf("{"),1);
                  param1.splice(param1.indexOf("~"),4);
                  param1.splice(param1.indexOf("#"),2,param2[0] * param2[1] + param2[2]);
                  param1.splice(param1.indexOf("}"),1);
                  _loc3_ = _loc3_.concat(param1);
               }
               _loc5_ = _loc3_.concat(_loc4_);
            }
         }
         return _loc5_;
      }
      
      private static function decodeDescription(param1:Array, param2:Array) : Array
      {
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         _loc3_ = 0;
         var _loc4_:String = new String();
         var _loc5_:Number = param1.length;
         param1 = findOptionnalDices(param1,param2);
         while(_loc3_ < _loc5_)
         {
            _loc4_ = param1[_loc3_];
            switch(_loc4_)
            {
               case "#":
                  _loc6_ = param1[_loc3_ + 1];
                  if(!isNaN(_loc6_))
                  {
                     if(param2[_loc6_ - 1] != undefined)
                     {
                        param1.splice(_loc3_,2,param2[_loc6_ - 1]);
                        _loc3_--;
                     }
                     else
                     {
                        param1.splice(_loc3_,2);
                        _loc3_ = _loc3_ - 2;
                     }
                  }
                  break;
               case "~":
                  _loc7_ = param1[_loc3_ + 1];
                  if(!isNaN(_loc7_))
                  {
                     if(param2[_loc7_ - 1] != null)
                     {
                        param1.splice(_loc3_,2);
                        _loc3_ = _loc3_ - 2;
                     }
                     else
                     {
                        return param1.slice(0,_loc3_);
                     }
                  }
                  break;
               case "{":
                  _loc8_ = find(param1.slice(_loc3_),"}");
                  _loc9_ = decodeDescription(param1.slice(_loc3_ + 1,_loc3_ + _loc8_),param2).join("");
                  param1.splice(_loc3_,_loc8_ + 1,_loc9_);
                  break;
               case "[":
                  _loc10_ = find(param1.slice(_loc3_),"]");
                  _loc11_ = Number(param1.slice(_loc3_ + 1,_loc3_ + _loc10_).join(""));
                  if(!isNaN(_loc11_))
                  {
                     param1.splice(_loc3_,_loc10_ + 1,param2[_loc11_] + " ");
                     _loc3_ = _loc3_ - _loc10_;
                  }
            }
            _loc3_++;
         }
         return param1;
      }
      
      private static function decodeCombine(param1:Array, param2:Object) : Array
      {
         var _loc3_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         _loc3_ = 0;
         var _loc4_:String = new String();
         var _loc5_:Number = param1.length;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = param1[_loc3_];
            switch(_loc4_)
            {
               case "~":
                  _loc6_ = param1[_loc3_ + 1];
                  if(param2[_loc6_])
                  {
                     param1.splice(_loc3_,2);
                     _loc3_ = _loc3_ - 2;
                     break;
                  }
                  return param1.slice(0,_loc3_);
               case "{":
                  _loc7_ = find(param1.slice(_loc3_),"}");
                  _loc8_ = -1;
                  if(_loc7_ > -1)
                  {
                     _loc8_ = find(param1.slice(_loc3_,_loc3_ + _loc7_),":");
                  }
                  if(_loc8_ == -1 || !param1[_loc3_ + _loc8_ + 1] || param1[_loc3_ + _loc8_ + 1] != ":")
                  {
                     _loc9_ = decodeCombine(param1.slice(_loc3_ + 1,_loc3_ + _loc7_),param2).join("");
                     param1.splice(_loc3_,_loc7_ + 1,_loc9_);
                  }
            }
            _loc3_++;
         }
         return param1;
      }
      
      private static function find(param1:Array, param2:Object) : Number
      {
         var _loc4_:Number = NaN;
         var _loc3_:Number = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_] == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
   }
}
