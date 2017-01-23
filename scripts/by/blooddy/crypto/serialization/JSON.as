package by.blooddy.crypto.serialization
{
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import flash.errors.StackOverflowError;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   import flash.xml.XMLDocument;
   
   public class JSON
   {
       
      
      public function JSON()
      {
      }
      
      public static function encode(param1:*) : String
      {
         var _loc2_:Object = XML.settings();
         XML.setSettings({
            "ignoreComments":true,
            "ignoreProcessingInstructions":false,
            "ignoreWhitespace":true,
            "prettyIndent":false,
            "prettyPrinting":false
         });
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes("0123456789abcdef");
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.endian = Endian.LITTLE_ENDIAN;
         var cvint:Class = (new Vector.<int>() as Object).constructor;
         var cvuint:Class = (new Vector.<uint>() as Object).constructor;
         var cvdouble:Class = (new Vector.<Number>() as Object).constructor;
         var cvobject:Class = (new Vector.<Object>() as Object).constructor;
         var writeValue:Function = null;
         writeValue = function(param1:Dictionary, param2:ByteArray, param3:ByteArray, param4:*):*
         {
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:Number = NaN;
            var _loc10_:* = null as String;
            var _loc11_:Boolean = false;
            var _loc12_:* = null as Array;
            var _loc13_:* = null;
            var _loc14_:* = null as Array;
            var _loc15_:int = 0;
            var _loc17_:Boolean = false;
            var _loc18_:uint = 0;
            var _loc19_:uint = 0;
            var _loc20_:uint = 0;
            var _loc21_:uint = 0;
            var _loc22_:uint = 0;
            var _loc6_:String = typeof param4;
            if(_loc6_ == "number")
            {
               if(isFinite(param4))
               {
                  if(param4 >= 0 && (param4 <= 9 && param4 % 1 == 0))
                  {
                     param2.writeByte(int(uint(48) + param4));
                  }
                  else
                  {
                     param2.writeUTFBytes(param4.toString());
                  }
               }
               else
               {
                  param2.writeInt(1819047278);
               }
            }
            else if(_loc6_ == "boolean")
            {
               if(param4)
               {
                  param2.writeInt(1702195828);
               }
               else
               {
                  param2.writeInt(1936482662);
                  param2.writeByte(101);
               }
            }
            else
            {
               if(_loc6_ == "xml")
               {
                  param4 = param4.toXMLString();
                  _loc6_ = "string";
               }
               else if(!!param4 && _loc6_ == "object")
               {
                  if(param4 is XMLDocument)
                  {
                     if(param4.childNodes.length > 0)
                     {
                        param4 = new XML(param4).toXMLString();
                        _loc6_ = "string";
                     }
                     else
                     {
                        param2.writeShort(8738);
                     }
                  }
                  else
                  {
                     if(param4 in param1)
                     {
                        Error.throwError(StackOverflowError,2024);
                     }
                     param1[param4] = true;
                     _loc7_ = 0;
                     if(param4 is Array || param4 is cvobject)
                     {
                        param2.writeByte(uint(91));
                        _loc8_ = param4.length - 1;
                        while(_loc8_ >= 0 && param4[_loc8_] == null)
                        {
                           _loc8_--;
                        }
                        _loc8_++;
                        if(_loc8_ > 0)
                        {
                           writeValue(param1,param2,param3,param4[0]);
                           while(true)
                           {
                              _loc7_++;
                              if(_loc7_ >= _loc8_)
                              {
                                 break;
                              }
                              param2.writeByte(uint(44));
                              writeValue(param1,param2,param3,param4[_loc7_]);
                           }
                        }
                        param2.writeByte(uint(93));
                     }
                     else if(param4 is cvint || param4 is cvuint)
                     {
                        param2.writeByte(uint(91));
                        _loc8_ = param4.length;
                        if(_loc8_ > 0)
                        {
                           _loc9_ = Number(param4[0]);
                           if(_loc9_ >= 0 && (_loc9_ <= 9 && _loc9_ % 1 == 0))
                           {
                              param2.writeByte(uint(48) + _loc9_);
                           }
                           else
                           {
                              param2.writeUTFBytes(_loc9_.toString());
                           }
                           while(true)
                           {
                              _loc7_++;
                              if(_loc7_ >= _loc8_)
                              {
                                 break;
                              }
                              param2.writeByte(uint(44));
                              _loc9_ = Number(param4[_loc7_]);
                              if(_loc9_ >= 0 && (_loc9_ <= 9 && _loc9_ % 1 == 0))
                              {
                                 param2.writeByte(uint(48) + _loc9_);
                              }
                              else
                              {
                                 param2.writeUTFBytes(_loc9_.toString());
                              }
                           }
                        }
                        param2.writeByte(uint(93));
                     }
                     else if(param4 is cvdouble)
                     {
                        param2.writeByte(uint(91));
                        _loc8_ = param4.length - 1;
                        while(_loc8_ >= 0 && !isFinite(param4[_loc8_]))
                        {
                           _loc8_--;
                        }
                        _loc8_++;
                        if(_loc8_ > 0)
                        {
                           _loc9_ = Number(param4[0]);
                           if(isFinite(_loc9_))
                           {
                              if(_loc9_ >= 0 && (_loc9_ <= 9 && _loc9_ % 1 == 0))
                              {
                                 param2.writeByte(int(uint(48) + _loc9_));
                              }
                              else
                              {
                                 param2.writeUTFBytes(_loc9_.toString());
                              }
                           }
                           else
                           {
                              param2.writeInt(1819047278);
                           }
                           while(true)
                           {
                              _loc7_++;
                              if(_loc7_ >= _loc8_)
                              {
                                 break;
                              }
                              param2.writeByte(uint(44));
                              _loc9_ = Number(param4[_loc7_]);
                              if(isFinite(_loc9_))
                              {
                                 if(_loc9_ >= 0 && (_loc9_ <= 9 && _loc9_ % 1 == 0))
                                 {
                                    param2.writeByte(int(uint(48) + _loc9_));
                                 }
                                 else
                                 {
                                    param2.writeUTFBytes(_loc9_.toString());
                                 }
                              }
                              else
                              {
                                 param2.writeInt(1819047278);
                              }
                           }
                        }
                        param2.writeByte(uint(93));
                     }
                     else
                     {
                        param2.writeByte(uint(123));
                        _loc11_ = false;
                        _loc13_ = null;
                        if(param4.constructor != Object)
                        {
                           if(param4 is Dictionary)
                           {
                              _loc15_ = 0;
                              _loc14_ = [];
                              var _loc16_:* = param4;
                              addr524:
                              if(§§hasnext(param4,_loc15_))
                              {
                                 _loc14_.push(§§nextname(_loc15_,_loc16_));
                                 §§goto(addr524);
                              }
                              _loc12_ = _loc14_;
                              _loc8_ = _loc12_.length;
                              _loc7_ = 0;
                              addr559:
                              if(_loc7_ < _loc8_)
                              {
                                 _loc13_ = typeof _loc12_[_loc7_];
                                 if(_loc13_ != "string" && _loc13_ != "number")
                                 {
                                    Error.throwError(TypeError,0);
                                 }
                                 _loc7_++;
                                 §§goto(addr559);
                              }
                           }
                           _loc12_ = SerializationHelper.getPropertyNames(param4);
                           _loc8_ = _loc12_.length;
                           _loc7_ = 0;
                           if(_loc7_ < _loc8_)
                           {
                              _loc10_ = _loc12_[_loc7_];
                              try
                              {
                                 _loc13_ = param4[_loc10_];
                                 _loc17_ = true;
                              }
                              catch(_loc16_:*)
                              {
                                 _loc17_ = false;
                              }
                              if(_loc17_)
                              {
                                 if(_loc11_)
                                 {
                                    param2.writeByte(uint(44));
                                 }
                                 else
                                 {
                                    _loc11_ = true;
                                 }
                                 if(_loc10_.length <= 0)
                                 {
                                    param2.writeShort(8738);
                                    addr801:
                                    param2.writeByte(uint(58));
                                    writeValue(param1,param2,param3,_loc13_);
                                 }
                                 else
                                 {
                                    param2.writeByte(uint(34));
                                    param3.position = 16;
                                    param3.writeUTFBytes(_loc10_);
                                    _loc18_ = param3.position;
                                    _loc19_ = 16;
                                    _loc20_ = _loc19_;
                                 }
                                 addr637:
                                 _loc22_ = int(param3[_loc19_]);
                                 if(_loc22_ < uint(32) || (_loc22_ == uint(34) || (_loc22_ == uint(47) || _loc22_ == uint(92))))
                                 {
                                    _loc21_ = _loc19_ - _loc20_;
                                    if(_loc21_ > 0)
                                    {
                                       param2.writeBytes(param3,_loc20_,_loc21_);
                                    }
                                    _loc20_ = _loc19_ + 1;
                                    if(_loc22_ == uint(10))
                                    {
                                       param2.writeShort(28252);
                                    }
                                    if(_loc22_ == uint(13))
                                    {
                                       param2.writeShort(29276);
                                    }
                                    if(_loc22_ == uint(9))
                                    {
                                       param2.writeShort(29788);
                                    }
                                    if(_loc22_ == uint(34))
                                    {
                                       param2.writeShort(8796);
                                    }
                                    if(_loc22_ == uint(47))
                                    {
                                       param2.writeShort(12124);
                                    }
                                    if(_loc22_ == uint(92))
                                    {
                                       param2.writeShort(23644);
                                    }
                                    if(_loc22_ == uint(11))
                                    {
                                       param2.writeShort(30300);
                                    }
                                    if(_loc22_ == uint(8))
                                    {
                                       param2.writeShort(25180);
                                    }
                                    if(_loc22_ == uint(12))
                                    {
                                       param2.writeShort(26204);
                                    }
                                    param2.writeInt(808482140);
                                    param2.writeByte(int(param3[_loc22_ >>> 4]));
                                    param2.writeByte(int(param3[_loc22_ & 15]));
                                 }
                                 _loc19_++;
                                 if(_loc19_ < _loc18_)
                                 {
                                    §§goto(addr637);
                                 }
                                 _loc21_ = _loc19_ - _loc20_;
                                 if(_loc21_ > 0)
                                 {
                                    param2.writeBytes(param3,_loc20_,_loc21_);
                                 }
                                 param2.writeByte(uint(34));
                                 §§goto(addr801);
                              }
                              _loc7_++;
                              if(_loc7_ < _loc8_)
                              {
                                 _loc10_ = _loc12_[_loc7_];
                                 _loc13_ = param4[_loc10_];
                                 _loc17_ = true;
                              }
                           }
                        }
                        _loc15_ = 0;
                        _loc14_ = [];
                        while(§§hasnext(param4,_loc15_))
                        {
                           _loc14_.push(§§nextname(_loc15_,_loc16_));
                        }
                        _loc12_ = _loc14_;
                        _loc8_ = _loc12_.length;
                        _loc7_ = 0;
                        while(_loc7_ < _loc8_)
                        {
                           _loc10_ = _loc12_[_loc7_];
                           _loc13_ = param4[_loc10_];
                           if(!(_loc13_ is Function))
                           {
                              if(_loc11_)
                              {
                                 param2.writeByte(uint(44));
                              }
                              else
                              {
                                 _loc11_ = true;
                              }
                              if(_loc10_.length <= 0)
                              {
                                 param2.writeShort(8738);
                              }
                              else
                              {
                                 param2.writeByte(uint(34));
                                 param3.position = 16;
                                 param3.writeUTFBytes(_loc10_);
                                 _loc18_ = param3.position;
                                 _loc19_ = 16;
                                 _loc20_ = _loc19_;
                                 do
                                 {
                                    _loc22_ = int(param3[_loc19_]);
                                    if(_loc22_ < uint(32) || (_loc22_ == uint(34) || (_loc22_ == uint(47) || _loc22_ == uint(92))))
                                    {
                                       _loc21_ = _loc19_ - _loc20_;
                                       if(_loc21_ > 0)
                                       {
                                          param2.writeBytes(param3,_loc20_,_loc21_);
                                       }
                                       _loc20_ = _loc19_ + 1;
                                       if(_loc22_ == uint(10))
                                       {
                                          param2.writeShort(28252);
                                       }
                                       else if(_loc22_ == uint(13))
                                       {
                                          param2.writeShort(29276);
                                       }
                                       else if(_loc22_ == uint(9))
                                       {
                                          param2.writeShort(29788);
                                       }
                                       else if(_loc22_ == uint(34))
                                       {
                                          param2.writeShort(8796);
                                       }
                                       else if(_loc22_ == uint(47))
                                       {
                                          param2.writeShort(12124);
                                       }
                                       else if(_loc22_ == uint(92))
                                       {
                                          param2.writeShort(23644);
                                       }
                                       else if(_loc22_ == uint(11))
                                       {
                                          param2.writeShort(30300);
                                       }
                                       else if(_loc22_ == uint(8))
                                       {
                                          param2.writeShort(25180);
                                       }
                                       else if(_loc22_ == uint(12))
                                       {
                                          param2.writeShort(26204);
                                       }
                                       else
                                       {
                                          param2.writeInt(808482140);
                                          param2.writeByte(int(param3[_loc22_ >>> 4]));
                                          param2.writeByte(int(param3[_loc22_ & 15]));
                                       }
                                    }
                                    _loc19_++;
                                 }
                                 while(_loc19_ < _loc18_);
                                 
                                 _loc21_ = _loc19_ - _loc20_;
                                 if(_loc21_ > 0)
                                 {
                                    param2.writeBytes(param3,_loc20_,_loc21_);
                                 }
                                 param2.writeByte(uint(34));
                              }
                              param2.writeByte(uint(58));
                              writeValue(param1,param2,param3,_loc13_);
                           }
                           _loc7_++;
                        }
                        param2.writeByte(uint(125));
                     }
                     delete param1[param4];
                  }
               }
               if(_loc6_ == "string")
               {
                  if(int(param4.length) <= 0)
                  {
                     param2.writeShort(8738);
                  }
                  else
                  {
                     param2.writeByte(uint(34));
                     param3.position = 16;
                     param3.writeUTFBytes(param4);
                     _loc18_ = param3.position;
                     _loc19_ = 16;
                     _loc20_ = _loc19_;
                     do
                     {
                        _loc22_ = int(param3[_loc19_]);
                        if(_loc22_ < uint(32) || (_loc22_ == uint(34) || (_loc22_ == uint(47) || _loc22_ == uint(92))))
                        {
                           _loc21_ = _loc19_ - _loc20_;
                           if(_loc21_ > 0)
                           {
                              param2.writeBytes(param3,_loc20_,_loc21_);
                           }
                           _loc20_ = _loc19_ + 1;
                           if(_loc22_ == uint(10))
                           {
                              param2.writeShort(28252);
                           }
                           else if(_loc22_ == uint(13))
                           {
                              param2.writeShort(29276);
                           }
                           else if(_loc22_ == uint(9))
                           {
                              param2.writeShort(29788);
                           }
                           else if(_loc22_ == uint(34))
                           {
                              param2.writeShort(8796);
                           }
                           else if(_loc22_ == uint(47))
                           {
                              param2.writeShort(12124);
                           }
                           else if(_loc22_ == uint(92))
                           {
                              param2.writeShort(23644);
                           }
                           else if(_loc22_ == uint(11))
                           {
                              param2.writeShort(30300);
                           }
                           else if(_loc22_ == uint(8))
                           {
                              param2.writeShort(25180);
                           }
                           else if(_loc22_ == uint(12))
                           {
                              param2.writeShort(26204);
                           }
                           else
                           {
                              param2.writeInt(808482140);
                              param2.writeByte(int(param3[_loc22_ >>> 4]));
                              param2.writeByte(int(param3[_loc22_ & 15]));
                           }
                        }
                        _loc19_++;
                     }
                     while(_loc19_ < _loc18_);
                     
                     _loc21_ = _loc19_ - _loc20_;
                     if(_loc21_ > 0)
                     {
                        param2.writeBytes(param3,_loc20_,_loc21_);
                     }
                     param2.writeByte(uint(34));
                  }
               }
               else if(!param4)
               {
                  param2.writeInt(1819047278);
               }
            }
         };
         writeValue(new Dictionary(),_loc4_,_loc3_,param1);
         XML.setSettings(_loc2_);
         var _loc5_:uint = _loc4_.position;
         _loc4_.position = 0;
         return _loc4_.readUTFBytes(_loc5_);
      }
      
      public static function decode(param1:String) : *
      {
         /*
          * Decompilation error
          * Timeout (1 minute) was reached
          * Instruction count: 593
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to timeout");
      }
   }
}
