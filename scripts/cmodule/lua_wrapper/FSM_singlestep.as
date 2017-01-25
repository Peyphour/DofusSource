package cmodule.lua_wrapper
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM_singlestep extends Machine
   {
      
      public static const intRegCount:int = 13;
      
      public static const NumberRegCount:int = 0;
       
      
      public var i10:int;
      
      public var i11:int;
      
      public var i12:int;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public var i7:int;
      
      public var i8:int;
      
      public var i9:int;
      
      public function FSM_singlestep()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_singlestep = null;
         _loc1_ = new FSM_singlestep();
         FSM_singlestep.gworker = _loc1_;
      }
      
      override public final function work() : void
      {
         switch(state)
         {
            case 0:
               mstate.esp = mstate.esp - 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp = mstate.esp - 0;
               this.i0 = li32(mstate.ebp + 8);
               this.i1 = li32(this.i0 + 16);
               this.i2 = li8(this.i1 + 21);
               this.i3 = this.i1 + 21;
               this.i4 = this.i0 + 16;
               this.i5 = this.i1;
               if(this.i2 <= 1)
               {
                  if(this.i2 != 0)
                  {
                     if(this.i2 == 1)
                     {
                        this.i4 = li32(this.i5 + 36);
                        this.i2 = this.i5 + 36;
                        if(this.i4 != 0)
                        {
                           mstate.esp = mstate.esp - 4;
                           si32(this.i5,mstate.esp);
                           state = 1;
                           mstate.esp = mstate.esp - 4;
                           FSM_singlestep.start();
                           return;
                        }
                        this.i4 = li32(this.i5 + 124);
                        this.i6 = this.i5 + 108;
                        if(this.i6 != this.i4)
                        {
                           loop0:
                           while(true)
                           {
                              this.i7 = li8(this.i4 + 5);
                              this.i8 = this.i7 & 4;
                              if(this.i8 == 0)
                              {
                                 this.i7 = this.i7 & 3;
                                 if(this.i7 == 0)
                                 {
                                    this.i7 = li32(this.i4 + 8);
                                    this.i8 = li32(this.i7 + 8);
                                    if(this.i8 >= 4)
                                    {
                                       this.i7 = li32(this.i7);
                                       this.i8 = li8(this.i7 + 5);
                                       this.i8 = this.i8 & 3;
                                       if(this.i8 != 0)
                                       {
                                          mstate.esp = mstate.esp - 8;
                                          si32(this.i5,mstate.esp);
                                          si32(this.i7,mstate.esp + 4);
                                          mstate.esp = mstate.esp - 4;
                                          FSM_singlestep.start();
                                       }
                                    }
                                 }
                              }
                              addr341:
                              while(true)
                              {
                                 this.i4 = li32(this.i4 + 16);
                                 if(this.i6 != this.i4)
                                 {
                                    continue loop0;
                                 }
                                 break loop0;
                              }
                              this.i4 = 0;
                              this.i6 = li32(this.i5 + 44);
                              si32(this.i6,this.i2);
                              si32(this.i4,this.i5 + 44);
                              this.i4 = li8(this.i0 + 5);
                              this.i6 = this.i5 + 44;
                              this.i4 = this.i4 & 3;
                              if(this.i4 != 0)
                              {
                                 mstate.esp = mstate.esp - 8;
                                 si32(this.i5,mstate.esp);
                                 si32(this.i0,mstate.esp + 4);
                                 mstate.esp = mstate.esp - 4;
                                 FSM_singlestep.start();
                              }
                              this.i4 = 0;
                              this.i1 = this.i1 + 132;
                              loop1:
                              while(true)
                              {
                                 this.i7 = li32(this.i1);
                                 if(this.i7 != 0)
                                 {
                                    this.i8 = li8(this.i7 + 5);
                                    this.i8 = this.i8 & 3;
                                    if(this.i8 != 0)
                                    {
                                       mstate.esp = mstate.esp - 8;
                                       si32(this.i5,mstate.esp);
                                       si32(this.i7,mstate.esp + 4);
                                       mstate.esp = mstate.esp - 4;
                                       FSM_singlestep.start();
                                    }
                                 }
                                 addr563:
                                 while(true)
                                 {
                                    this.i1 = this.i1 + 4;
                                    this.i4 = this.i4 + 1;
                                    if(this.i4 != 9)
                                    {
                                       continue loop1;
                                    }
                                    break loop1;
                                 }
                                 this.i4 = 0;
                                 this.i1 = li32(this.i5 + 40);
                                 si32(this.i1,this.i2);
                                 si32(this.i4,this.i5 + 40);
                                 if(this.i1 != 0)
                                 {
                                    addr667:
                                    mstate.esp = mstate.esp - 4;
                                    si32(this.i5,mstate.esp);
                                    state = 8;
                                    mstate.esp = mstate.esp - 4;
                                    FSM_singlestep.start();
                                    return;
                                 }
                                 addr712:
                                 this.i4 = 0;
                                 mstate.esp = mstate.esp - 8;
                                 si32(this.i0,mstate.esp);
                                 si32(this.i4,mstate.esp + 4);
                                 mstate.esp = mstate.esp - 4;
                                 FSM_singlestep.start();
                              }
                              this.i4 = li32(this.i2);
                              if(this.i4 != 0)
                              {
                                 addr593:
                                 mstate.esp = mstate.esp - 4;
                                 si32(this.i5,mstate.esp);
                                 state = 7;
                                 mstate.esp = mstate.esp - 4;
                                 FSM_singlestep.start();
                                 return;
                              }
                              §§goto(addr638);
                           }
                        }
                        this.i4 = li32(this.i2);
                        if(this.i4 != 0)
                        {
                           addr367:
                           mstate.esp = mstate.esp - 4;
                           si32(this.i5,mstate.esp);
                           state = 4;
                           mstate.esp = mstate.esp - 4;
                           FSM_singlestep.start();
                           return;
                        }
                        §§goto(addr412);
                     }
                  }
                  else
                  {
                     this.i1 = 0;
                     mstate.esp = mstate.esp - 4;
                     si32(this.i0,mstate.esp);
                     mstate.esp = mstate.esp - 4;
                     FSM_singlestep.start();
                  }
                  addr183:
                  mstate.eax = this.i1;
                  break;
               }
               if(this.i2 != 2)
               {
                  if(this.i2 != 3)
                  {
                     if(this.i2 == 4)
                     {
                        this.i1 = li32(this.i5 + 48);
                        if(this.i1 != 0)
                        {
                           mstate.esp = mstate.esp - 4;
                           si32(this.i0,mstate.esp);
                           state = 20;
                           mstate.esp = mstate.esp - 4;
                           FSM_singlestep.start();
                           return;
                        }
                        this.i0 = 0;
                        si8(this.i0,this.i3);
                        si32(this.i0,this.i5 + 76);
                     }
                     addr2083:
                     addr188:
                     mstate.eax = this.i0;
                     break;
                  }
                  this.i1 = 40;
                  this.i2 = li32(this.i5 + 68);
                  this.i6 = li32(this.i5 + 32);
                  mstate.esp = mstate.esp - 12;
                  si32(this.i0,mstate.esp);
                  si32(this.i6,mstate.esp + 4);
                  si32(this.i1,mstate.esp + 8);
                  state = 15;
                  mstate.esp = mstate.esp - 4;
                  FSM_singlestep.start();
                  return;
               }
               this.i4 = -3;
               this.i1 = li32(this.i5 + 24);
               this.i2 = li32(this.i5 + 68);
               this.i6 = li32(this.i5);
               this.i7 = this.i1 + 1;
               si32(this.i7,this.i5 + 24);
               this.i1 = this.i1 << 2;
               mstate.esp = mstate.esp - 12;
               this.i1 = this.i6 + this.i1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               state = 14;
               mstate.esp = mstate.esp - 4;
               FSM_singlestep.start();
               return;
               this.i0 = 0;
               §§goto(addr2083);
            case 1:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               §§goto(addr2083);
            case 2:
               mstate.esp = mstate.esp + 4;
               §§goto(addr183);
            case 3:
               while(true)
               {
                  mstate.esp = mstate.esp + 8;
                  §§goto(addr341);
               }
            case 4:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i4 = li32(this.i2);
               if(this.i4 == 0)
               {
                  §§goto(addr412);
               }
               else
               {
                  §§goto(addr367);
               }
            case 5:
               mstate.esp = mstate.esp + 8;
               §§goto(addr491);
            case 6:
               while(true)
               {
                  mstate.esp = mstate.esp + 8;
                  §§goto(addr563);
               }
            case 7:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i4 = li32(this.i2);
               if(this.i4 == 0)
               {
                  §§goto(addr638);
               }
               else
               {
                  §§goto(addr593);
               }
            case 8:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i4 = li32(this.i2);
               if(this.i4 == 0)
               {
                  §§goto(addr712);
               }
               else
               {
                  §§goto(addr667);
               }
            case 9:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i4 = li32(this.i5 + 48);
               this.i1 = this.i5 + 48;
               if(this.i4 != 0)
               {
                  this.i7 = this.i5 + 20;
                  addr778:
                  while(true)
                  {
                     this.i4 = li32(this.i4);
                     this.i8 = li8(this.i4 + 5);
                     this.i9 = li8(this.i7);
                     this.i8 = this.i8 & -8;
                     this.i9 = this.i9 & 3;
                     this.i8 = this.i9 | this.i8;
                     si8(this.i8,this.i4 + 5);
                     mstate.esp = mstate.esp - 8;
                     si32(this.i5,mstate.esp);
                     si32(this.i4,mstate.esp + 4);
                     mstate.esp = mstate.esp - 4;
                     FSM_singlestep.start();
                  }
               }
               addr866:
               this.i4 = li32(this.i2);
               if(this.i4 != 0)
               {
                  this.i4 = 0;
                  addr882:
                  mstate.esp = mstate.esp - 4;
                  si32(this.i5,mstate.esp);
                  state = 11;
                  mstate.esp = mstate.esp - 4;
                  FSM_singlestep.start();
                  return;
               }
               this.i4 = 0;
               addr2092:
               this.i1 = li32(this.i6);
               if(this.i1 != 0)
               {
                  loop7:
                  while(true)
                  {
                     this.i2 = li8(this.i1 + 5);
                     this.i2 = this.i2 & 16;
                     if(this.i2 != 0)
                     {
                        this.i2 = li32(this.i1 + 28);
                        if(this.i2 != 0)
                        {
                           this.i6 = 0;
                           this.i7 = this.i2 * 12;
                           this.i8 = this.i1 + 12;
                           addr2153:
                           while(true)
                           {
                              this.i9 = 0;
                              this.i10 = li32(this.i8);
                              this.i11 = this.i7 + this.i10;
                              mstate.esp = mstate.esp - 8;
                              this.i11 = this.i11 + -12;
                              si32(this.i11,mstate.esp);
                              si32(this.i9,mstate.esp + 4);
                              mstate.esp = mstate.esp - 4;
                              FSM_singlestep.start();
                           }
                        }
                     }
                     addr934:
                     while(true)
                     {
                        this.i2 = 1;
                        this.i6 = li8(this.i1 + 7);
                        this.i2 = this.i2 << this.i6;
                        if(this.i2 != 0)
                        {
                           this.i6 = 0;
                           this.i7 = this.i2 * 28;
                           this.i8 = this.i1 + 16;
                           loop9:
                           while(true)
                           {
                              this.i9 = li32(this.i8);
                              this.i10 = this.i9 + this.i7;
                              this.i11 = li32(this.i10 + -20);
                              this.i10 = this.i10 + -20;
                              if(this.i11 != 0)
                              {
                                 this.i11 = 1;
                                 this.i12 = this.i7 + this.i9;
                                 mstate.esp = mstate.esp - 8;
                                 this.i12 = this.i12 + -16;
                                 si32(this.i12,mstate.esp);
                                 si32(this.i11,mstate.esp + 4);
                                 mstate.esp = mstate.esp - 4;
                                 FSM_singlestep.start();
                              }
                              addr1162:
                              while(true)
                              {
                                 this.i7 = this.i7 + -28;
                                 this.i6 = this.i6 + 1;
                                 if(this.i6 != this.i2)
                                 {
                                    continue loop9;
                                 }
                                 break loop9;
                              }
                           }
                        }
                        while(true)
                        {
                           this.i1 = li32(this.i1 + 24);
                           if(this.i1 != 0)
                           {
                              continue loop7;
                           }
                           break loop7;
                        }
                        §§goto(addr183);
                     }
                  }
               }
               this.i1 = 0;
               this.i2 = li8(this.i5 + 20);
               this.i2 = this.i2 ^ 3;
               si8(this.i2,this.i5 + 20);
               si32(this.i1,this.i5 + 24);
               this.i2 = this.i5 + 28;
               si32(this.i2,this.i5 + 32);
               this.i2 = 2;
               si8(this.i2,this.i3);
               this.i0 = 0 - this.i0;
               this.i3 = li32(this.i5 + 68);
               this.i0 = this.i0 - this.i4;
               this.i0 = this.i0 + this.i3;
               si32(this.i0,this.i5 + 72);
               §§goto(addr182);
            case 10:
               while(true)
               {
                  mstate.esp = mstate.esp + 8;
                  this.i8 = li32(this.i1);
                  if(this.i8 != this.i4)
                  {
                     §§goto(addr778);
                  }
                  else
                  {
                     break;
                  }
               }
               §§goto(addr866);
            case 11:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i7 = li32(this.i2);
               this.i4 = this.i1 + this.i4;
               if(this.i7 != 0)
               {
                  §§goto(addr882);
               }
               else
               {
                  §§goto(addr2092);
               }
            case 12:
               while(true)
               {
                  this.i11 = mstate.eax;
                  mstate.esp = mstate.esp + 8;
                  if(this.i11 == 0)
                  {
                     this.i11 = 0;
                     this.i12 = this.i7 + this.i9;
                     mstate.esp = mstate.esp - 8;
                     this.i12 = this.i12 + -28;
                     si32(this.i12,mstate.esp);
                     si32(this.i11,mstate.esp + 4);
                     mstate.esp = mstate.esp - 4;
                     FSM_singlestep.start();
                  }
                  addr1121:
                  while(true)
                  {
                     this.i11 = 0;
                     this.i9 = this.i9 + this.i7;
                     si32(this.i11,this.i10);
                     this.i10 = li32(this.i9 + -8);
                     this.i9 = this.i9 + -8;
                     if(this.i10 >= 4)
                     {
                        this.i10 = 11;
                        si32(this.i10,this.i9);
                     }
                     §§goto(addr1162);
                  }
               }
            case 13:
               while(true)
               {
                  this.i11 = mstate.eax;
                  mstate.esp = mstate.esp + 8;
                  if(this.i11 != 0)
                  {
                     §§goto(addr1121);
                  }
                  §§goto(addr1162);
               }
            case 14:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               this.i0 = li32(this.i5 + 24);
               this.i4 = li32(this.i5 + 8);
               this.i1 = this.i5 + 68;
               if(this.i0 >= this.i4)
               {
                  this.i0 = 3;
                  si8(this.i0,this.i3);
               }
               this.i0 = 10;
               this.i3 = li32(this.i5 + 72);
               this.i4 = li32(this.i1);
               this.i3 = this.i3 - this.i2;
               this.i3 = this.i3 + this.i4;
               addr1442:
               si32(this.i3,this.i5 + 72);
               §§goto(addr2083);
            case 15:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i1,this.i5 + 32);
               this.i1 = li32(this.i1);
               this.i6 = this.i5 + 68;
               if(this.i1 == 0)
               {
                  this.i1 = li32(this.i4);
                  this.i7 = li32(this.i1 + 8);
                  this.i8 = li32(this.i1 + 4);
                  this.i9 = this.i7 >> 31;
                  this.i9 = this.i9 >>> 30;
                  this.i9 = this.i7 + this.i9;
                  this.i9 = this.i9 >> 2;
                  if(uint(this.i8) < uint(this.i9))
                  {
                     if(this.i7 >= 65)
                     {
                        this.i8 = this.i7 >>> 31;
                        this.i7 = this.i7 + this.i8;
                        mstate.esp = mstate.esp - 8;
                        this.i7 = this.i7 >> 1;
                        si32(this.i0,mstate.esp);
                        si32(this.i7,mstate.esp + 4);
                        state = 16;
                        mstate.esp = mstate.esp - 4;
                        FSM_singlestep.start();
                        return;
                     }
                  }
                  addr1654:
                  this.i7 = li32(this.i1 + 60);
                  this.i8 = this.i1 + 60;
                  if(uint(this.i7) >= uint(65))
                  {
                     this.i9 = this.i7 >>> 1;
                     this.i1 = this.i1 + 52;
                     this.i10 = this.i9 + 1;
                     if(uint(this.i10) <= uint(-3))
                     {
                        this.i4 = li32(this.i4);
                        this.i10 = li32(this.i1);
                        this.i11 = li32(this.i4 + 12);
                        this.i12 = li32(this.i4 + 16);
                        mstate.esp = mstate.esp - 16;
                        si32(this.i12,mstate.esp);
                        si32(this.i10,mstate.esp + 4);
                        si32(this.i7,mstate.esp + 8);
                        si32(this.i9,mstate.esp + 12);
                        state = 17;
                        mstate.esp = mstate.esp - 4;
                        mstate.funcs[this.i11]();
                        return;
                     }
                     this.i4 = FSM_singlestep;
                     mstate.esp = mstate.esp - 8;
                     si32(this.i0,mstate.esp);
                     si32(this.i4,mstate.esp + 4);
                     state = 19;
                     mstate.esp = mstate.esp - 4;
                     FSM_singlestep.start();
                     return;
                  }
                  addr1943:
                  this.i0 = 4;
                  si8(this.i0,this.i3);
               }
               addr1951:
               this.i0 = 400;
               this.i3 = li32(this.i5 + 72);
               this.i1 = li32(this.i6);
               this.i3 = this.i3 - this.i2;
               this.i3 = this.i3 + this.i1;
               §§goto(addr1442);
            case 16:
               mstate.esp = mstate.esp + 8;
               §§goto(addr1654);
            case 17:
               this.i10 = mstate.eax;
               mstate.esp = mstate.esp + 16;
               if(this.i10 == 0)
               {
                  if(uint(this.i7) >= uint(2))
                  {
                     this.i11 = 4;
                     mstate.esp = mstate.esp - 8;
                     si32(this.i0,mstate.esp);
                     si32(this.i11,mstate.esp + 4);
                     state = 18;
                     mstate.esp = mstate.esp - 4;
                     FSM_singlestep.start();
                     return;
                  }
               }
               addr1842:
               this.i0 = 4;
               this.i11 = li32(this.i4 + 68);
               this.i7 = this.i9 - this.i7;
               this.i7 = this.i7 + this.i11;
               si32(this.i7,this.i4 + 68);
               si32(this.i10,this.i1);
               si32(this.i9,this.i8);
               si8(this.i0,this.i3);
               §§goto(addr1951);
            case 18:
               mstate.esp = mstate.esp + 8;
               §§goto(addr1842);
            case 19:
               mstate.esp = mstate.esp + 8;
               this.i0 = 0;
               si32(this.i0,this.i1);
               si32(this.i9,this.i8);
               §§goto(addr1943);
            case 20:
               mstate.esp = mstate.esp + 4;
               this.i0 = li32(this.i5 + 72);
               this.i3 = this.i5 + 72;
               if(uint(this.i0) <= uint(100))
               {
                  this.i0 = 100;
                  §§goto(addr2083);
               }
               else
               {
                  this.i5 = 100;
                  this.i0 = this.i0 + -100;
                  si32(this.i0,this.i3);
                  mstate.eax = this.i5;
               }
               §§goto(addr188);
            case 21:
               while(true)
               {
                  this.i9 = mstate.eax;
                  mstate.esp = mstate.esp + 8;
                  if(this.i9 != 0)
                  {
                     this.i9 = 0;
                     this.i10 = this.i10 + this.i7;
                     si32(this.i9,this.i10 + -4);
                  }
                  this.i7 = this.i7 + -12;
                  this.i6 = this.i6 + 1;
                  if(this.i6 == this.i2)
                  {
                     §§goto(addr934);
                  }
                  §§goto(addr2153);
               }
         }
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp = mstate.esp + 4;
         mstate.esp = mstate.esp + 4;
         mstate.gworker = caller;
      }
   }
}
