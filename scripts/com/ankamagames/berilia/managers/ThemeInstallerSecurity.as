package com.ankamagames.berilia.managers
{
   import by.blooddy.crypto.MD5;
   import com.hurlant.crypto.symmetric.AESKey;
   import com.hurlant.crypto.symmetric.ECBMode;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   public class ThemeInstallerSecurity
   {
      
      private static const ONE_KILOBYTES:uint = 1024;
      
      private static const ONE_MEGABYTES:uint = 1024 * 1024;
       
      
      public function ThemeInstallerSecurity()
      {
         super();
      }
      
      public static function checkSecurity(param1:File) : Boolean
      {
         return new File(param1.url + File.separator + getKey(param1.url) + ".txt").exists;
      }
      
      public static function createSecurity(param1:File) : void
      {
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(new File(param1.url + File.separator + getKey(param1.url) + ".txt"),FileMode.WRITE);
         _loc2_.close();
      }
      
      private static function getKey(param1:String) : String
      {
         if(_loc7_)
         {
            _loc2_.writeUTF(param1);
            if(_loc6_)
            {
            }
            addr33:
            §§push(_loc3_);
            §§push(123);
            if(_loc6_)
            {
               §§push(-§§pop() - 23 - 1 + 27);
            }
            §§pop().writeByte(§§pop());
            if(!_loc7_)
            {
               loop0:
               while(true)
               {
                  §§push(_loc3_);
                  §§push(147);
                  if(_loc6_)
                  {
                     §§push(-((-§§pop() * 68 - 54) * 3));
                  }
                  §§pop().writeByte(§§pop());
                  if(!_loc6_)
                  {
                     if(!_loc7_)
                     {
                        addr74:
                        while(true)
                        {
                           §§push(_loc3_);
                           §§push(251);
                           if(!_loc7_)
                           {
                              §§push(§§pop() - 106 + 89 - 1);
                           }
                           §§pop().writeByte(§§pop());
                           if(!_loc7_)
                           {
                           }
                           break;
                        }
                        if(_loc7_)
                        {
                        }
                        new ECBMode(_loc4_).encrypt(_loc2_);
                        if(!_loc6_)
                        {
                           §§push(_loc2_);
                           §§push(0);
                           if(!_loc7_)
                           {
                              §§push(--((-§§pop() + 81) * 4 + 1) - 1);
                           }
                           §§pop().position = §§pop();
                        }
                        return MD5.hashBytes(_loc2_);
                     }
                     loop2:
                     while(true)
                     {
                        §§push(_loc3_);
                        §§push(12);
                        if(_loc6_)
                        {
                           §§push(((§§pop() + 44) * 28 * 66 - 1) * 19 + 59);
                        }
                        §§pop().writeByte(§§pop());
                        if(!_loc7_)
                        {
                           addr255:
                           while(true)
                           {
                              §§push(_loc3_);
                              §§push(87);
                              if(_loc6_)
                              {
                                 §§push(-((§§pop() - 41 + 73) * 87) - 81);
                              }
                              §§pop().writeByte(§§pop());
                              if(_loc7_)
                              {
                              }
                              §§push(_loc3_);
                              §§push(35);
                              if(!_loc7_)
                              {
                                 §§push(-(-(§§pop() + 1) + 2) + 1);
                              }
                              §§pop().writeByte(§§pop());
                              if(_loc6_)
                              {
                                 loop4:
                                 while(true)
                                 {
                                    §§push(_loc3_);
                                    §§push(94);
                                    if(!_loc7_)
                                    {
                                       §§push(-(--§§pop() - 21 - 69));
                                    }
                                    §§pop().writeByte(§§pop());
                                    if(!_loc6_)
                                    {
                                    }
                                    §§push(_loc3_);
                                    §§push(243);
                                    if(!_loc7_)
                                    {
                                       §§push((§§pop() - 1 + 86 - 119) * 49 - 11 - 93 + 1);
                                    }
                                    §§pop().writeByte(§§pop());
                                    if(!_loc7_)
                                    {
                                       addr329:
                                       §§push(_loc3_);
                                       §§push(87);
                                       if(!_loc7_)
                                       {
                                          §§push(-(§§pop() + 1 + 58));
                                       }
                                       §§pop().writeByte(§§pop());
                                    }
                                    else
                                    {
                                       addr212:
                                       while(true)
                                       {
                                          §§push(_loc3_);
                                          §§push(78);
                                          if(_loc6_)
                                          {
                                             §§push((§§pop() * 9 - 1) * 100 + 1 + 1 - 26 - 96);
                                          }
                                          §§pop().writeByte(§§pop());
                                          addr229:
                                          while(!_loc6_)
                                          {
                                             while(true)
                                             {
                                                §§push(_loc3_);
                                                §§push(222);
                                                if(_loc6_)
                                                {
                                                   §§push(((§§pop() + 88) * 85 * 39 - 96) * 108 - 1 - 1);
                                                }
                                                §§pop().writeByte(§§pop());
                                                if(_loc6_)
                                                {
                                                   addr173:
                                                   while(true)
                                                   {
                                                      §§push(_loc3_);
                                                      §§push(45);
                                                      if(!_loc7_)
                                                      {
                                                         §§push(-(§§pop() - 1) + 1 - 1 - 1 + 11);
                                                      }
                                                      §§pop().writeByte(§§pop());
                                                      if(!_loc6_)
                                                      {
                                                         break;
                                                      }
                                                   }
                                                   continue loop4;
                                                }
                                                break;
                                             }
                                             continue loop0;
                                          }
                                          continue loop2;
                                       }
                                    }
                                    §§goto(addr338);
                                 }
                              }
                              addr117:
                              while(true)
                              {
                                 §§push(_loc3_);
                                 §§push(78);
                                 if(_loc6_)
                                 {
                                    §§push(--(§§pop() - 107));
                                 }
                                 §§pop().writeByte(§§pop());
                                 addr127:
                                 while(true)
                                 {
                                    if(!_loc6_)
                                    {
                                    }
                                    §§goto(addr173);
                                 }
                              }
                           }
                        }
                        while(true)
                        {
                           §§push(_loc3_);
                           §§push(47);
                           if(!_loc7_)
                           {
                              §§push(-(-(§§pop() + 1) - 1));
                           }
                           §§pop().writeByte(§§pop());
                           loop12:
                           while(_loc7_)
                           {
                              if(_loc7_)
                              {
                                 addr93:
                                 while(true)
                                 {
                                    §§push(_loc3_);
                                    §§push(171);
                                    if(!_loc7_)
                                    {
                                       §§push(-(-§§pop() - 1 + 83 + 1 - 1 + 1));
                                    }
                                    §§pop().writeByte(§§pop());
                                    if(!_loc6_)
                                    {
                                       if(_loc7_)
                                       {
                                          if(_loc6_)
                                          {
                                             §§goto(addr117);
                                          }
                                          else
                                          {
                                             §§goto(addr74);
                                          }
                                       }
                                       break;
                                    }
                                    continue loop12;
                                 }
                                 §§goto(addr127);
                              }
                              §§goto(addr212);
                           }
                           §§goto(addr229);
                        }
                     }
                  }
                  while(_loc6_)
                  {
                     §§goto(addr93);
                  }
                  §§goto(addr329);
               }
            }
            while(true)
            {
               §§push(_loc3_);
               §§push(174);
               if(_loc6_)
               {
                  §§push((-(§§pop() - 81) - 99) * 32);
               }
               §§pop().writeByte(§§pop());
               if(_loc6_)
               {
                  §§goto(addr149);
               }
               §§goto(addr255);
            }
         }
         §§push(_loc2_);
         §§push(0);
         if(!_loc7_)
         {
            §§push(-(§§pop() - 1 + 1));
         }
         §§pop().position = §§pop();
         §§goto(addr33);
      }
      
      public static function isValidFile(param1:String, param2:ByteArray) : Boolean
      {
         var _loc3_:uint = param2.position;
         var _loc4_:* = false;
         switch(param1.toLowerCase())
         {
            case "png":
               if(param2.length < 3 * ONE_MEGABYTES)
               {
                  _loc4_ = Boolean(isValidPNG(param2));
                  if(!_loc4_)
                  {
                     param2.position = _loc3_;
                     _loc4_ = Boolean(isValidJPEG(param2));
                  }
               }
               break;
            case "jpg":
            case "jpeg":
               if(param2.length < 2 * ONE_MEGABYTES)
               {
                  _loc4_ = Boolean(isValidJPEG(param2));
                  if(!_loc4_)
                  {
                     param2.position = _loc3_;
                     _loc4_ = Boolean(isValidPNG(param2));
                  }
               }
               break;
            case "swf":
               _loc4_ = Boolean(isValidSWF(param2) && param2.length < 3 * ONE_MEGABYTES);
               break;
            case "txt":
            case "xml":
            case "xmls":
            case "dt":
               _loc4_ = param2.length < 100 * ONE_KILOBYTES;
               break;
            default:
               _loc4_ = param2.length < ONE_MEGABYTES;
         }
         param2.position = _loc3_;
         return _loc4_;
      }
      
      private static function isValidSWF(param1:ByteArray) : Boolean
      {
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = false;
         if(_loc4_)
         {
            var header:String = null;
            if(!_loc4_)
            {
            }
            try
            {
               addr29:
               §§push(_loc2_);
               §§push(data);
               §§push(3);
               if(!_loc4_)
               {
                  §§push(-(§§pop() * 106 - 8 + 1) + 108 - 1 + 101);
               }
               var /*UnknownSlot*/:* = §§pop().readUTFBytes(§§pop());
            }
            catch(e:Error)
            {
               return false;
            }
            §§push(header);
            if(_loc4_)
            {
               §§push("CWS");
               if(!_loc5_)
               {
                  §§push(§§pop() == §§pop());
                  if(!_loc5_)
                  {
                     §§push(§§pop());
                     if(!_loc5_)
                     {
                        if(!§§pop())
                        {
                           if(!_loc5_)
                           {
                              §§pop();
                              if(_loc4_)
                              {
                                 §§push(header);
                                 if(!_loc4_)
                                 {
                                 }
                                 addr117:
                                 §§push("ZWS");
                              }
                              addr115:
                              §§goto(addr117);
                              §§push(header);
                           }
                           addr114:
                           §§pop();
                           §§goto(addr115);
                        }
                     }
                     addr110:
                     addr119:
                     if(!§§pop())
                     {
                        if(_loc4_)
                        {
                           §§goto(addr114);
                        }
                     }
                     return §§pop();
                  }
                  addr109:
                  §§goto(addr110);
                  §§push(§§pop());
               }
               addr118:
               §§goto(addr119);
               §§push(§§pop() == §§pop());
            }
            §§push("FWS");
            if(_loc4_)
            {
               §§push(§§pop() == §§pop());
               if(_loc4_)
               {
                  §§goto(addr109);
               }
               §§goto(addr119);
            }
            §§goto(addr118);
         }
         var data:ByteArray = param1;
         §§goto(addr29);
      }
      
      public static function isValidPNG(param1:ByteArray) : Boolean
      {
         var b1:uint = 0;
         var b2:uint = 0;
         var data:ByteArray = param1;
         try
         {
            b1 = data.readInt();
            b2 = data.readInt();
            if(b1 == 2303741511 && b2 == 218765834)
            {
               return true;
            }
         }
         catch(e:Error)
         {
            return false;
         }
         return false;
      }
      
      public static function isValidJPEG(param1:ByteArray) : Boolean
      {
         var b1:uint = 0;
         var b2:uint = 0;
         var data:ByteArray = param1;
         try
         {
            b1 = data.readByte();
            b2 = data.readByte();
            if((b1 & 255) != 255 || (b2 & 255) != 216)
            {
               return false;
            }
            data.position = data.length - 2;
            b1 = data.readByte();
            b2 = data.readByte();
            if((b1 & 255) != 255 || (b2 & 255) != 217)
            {
               return false;
            }
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
   }
}
