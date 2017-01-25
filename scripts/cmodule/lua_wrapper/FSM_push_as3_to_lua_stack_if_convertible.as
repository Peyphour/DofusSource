package cmodule.lua_wrapper
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_push_as3_to_lua_stack_if_convertible extends Machine
   {
      
      public static const intRegCount:int = 11;
      
      public static const NumberRegCount:int = 2;
       
      
      public var i10:int;
      
      public var f0:Number;
      
      public var f1:Number;
      
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
      
      public function FSM_push_as3_to_lua_stack_if_convertible()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_push_as3_to_lua_stack_if_convertible = null;
         _loc1_ = new FSM_push_as3_to_lua_stack_if_convertible();
         FSM_push_as3_to_lua_stack_if_convertible.gworker = _loc1_;
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
               this.i1 = li32(this.i0 + 8);
               this.i2 = li32(this.i0 + 12);
               this.i3 = li32(FSM_push_as3_to_lua_stack_if_convertible);
               mstate.esp = mstate.esp - 8;
               this.i4 = li32(mstate.ebp + 12);
               si32(this.i4,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 1;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 1:
               this.i3 = mstate.eax;
               this.i1 = this.i1 - this.i2;
               mstate.esp = mstate.esp + 8;
               this.i1 = this.i1 / 12;
               this.i2 = this.i0 + 12;
               this.i5 = this.i0 + 8;
               if(this.i3 != 0)
               {
                  this.i3 = 3;
                  mstate.esp = mstate.esp - 4;
                  si32(this.i4,mstate.esp);
                  state = 2;
                  mstate.esp = mstate.esp - 4;
                  mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
                  return;
               }
               this.i3 = li32(FSM_push_as3_to_lua_stack_if_convertible);
               mstate.esp = mstate.esp - 8;
               si32(this.i4,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 3;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 2:
               this.f0 = mstate.st0;
               mstate.esp = mstate.esp + 4;
               this.i4 = li32(this.i5);
               sf64(this.f0,this.i4);
               si32(this.i3,this.i4 + 8);
               this.i4 = li32(this.i5);
               this.i4 = this.i4 + 12;
               si32(this.i4,this.i5);
               this.i3 = li32(this.i2);
               this.i4 = this.i4 - this.i3;
               this.i3 = this.i1 + 1;
               this.i4 = this.i4 / 12;
               if(this.i4 == this.i3)
               {
                  addr243:
                  this.i0 = 1;
                  break;
               }
               addr417:
               mstate.esp = mstate.esp - 8;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               state = 5;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 3:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               if(this.i3 != 0)
               {
                  this.i3 = 3;
                  mstate.esp = mstate.esp - 4;
                  si32(this.i4,mstate.esp);
                  state = 4;
                  mstate.esp = mstate.esp - 4;
                  mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
                  return;
               }
               this.i3 = li32(FSM_push_as3_to_lua_stack_if_convertible);
               mstate.esp = mstate.esp - 8;
               si32(this.i4,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 22;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 4:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i6 = li32(this.i5);
               this.f0 = Number(this.i4);
               sf64(this.f0,this.i6);
               si32(this.i3,this.i6 + 8);
               this.i4 = li32(this.i5);
               this.i4 = this.i4 + 12;
               si32(this.i4,this.i5);
               this.i3 = li32(this.i2);
               this.i4 = this.i4 - this.i3;
               this.i3 = this.i1 + 1;
               this.i4 = this.i4 / 12;
               if(this.i4 != this.i3)
               {
                  §§goto(addr417);
               }
               else
               {
                  addr242:
                  §§goto(addr243);
               }
            case 5:
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i0 + 16);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               this.i6 = this.i0 + 16;
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 6;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr523:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 16;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 7;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 6:
               mstate.esp = mstate.esp + 4;
               §§goto(addr523);
            case 7:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i3 = li32(this.i6);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 8;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr675:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 1;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 9;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 8:
               mstate.esp = mstate.esp + 4;
               §§goto(addr675);
            case 9:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i4 = this.i3 + 12;
               si32(this.i4,this.i5);
               this.i4 = 1081389056;
               this.i7 = 0;
               si32(this.i7,this.i3 + 12);
               si32(this.i4,this.i3 + 16);
               this.i4 = 3;
               si32(this.i4,this.i3 + 20);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i3 = li32(this.i6);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 10;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr873:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 38;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 11;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 10:
               mstate.esp = mstate.esp + 4;
               §§goto(addr873);
            case 11:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i4 = this.i3 + 12;
               si32(this.i4,this.i5);
               this.f0 = Number(this.i1);
               sf64(this.f0,this.i3 + 12);
               this.i4 = 3;
               si32(this.i4,this.i3 + 20);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i3 = li32(this.i6);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 12;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr1064:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 16;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 13;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 12:
               mstate.esp = mstate.esp + 4;
               §§goto(addr1064);
            case 13:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i4 = this.i3 + 12;
               si32(this.i4,this.i5);
               this.i7 = li32(this.i2);
               this.i4 = this.i4 - this.i7;
               this.i4 = this.i4 / 12;
               this.i4 = this.i4 + -7;
               this.f0 = Number(this.i4);
               sf64(this.f0,this.i3 + 12);
               this.i4 = 3;
               si32(this.i4,this.i3 + 20);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i3 = li32(this.i6);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 14;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr1279:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 18;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 15;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 14:
               mstate.esp = mstate.esp + 4;
               §§goto(addr1279);
            case 15:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i1 = this.i1 + 1;
               this.i4 = this.i3 + 12;
               si32(this.i4,this.i5);
               this.f0 = Number(this.i1);
               sf64(this.f0,this.i3 + 12);
               this.i1 = 3;
               si32(this.i1,this.i3 + 20);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 16;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr1476:
               this.i1 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i3 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i4 = 1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               state = 17;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 16:
               mstate.esp = mstate.esp + 4;
               §§goto(addr1476);
            case 17:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i1,this.i3);
               this.i1 = 4;
               si32(this.i1,this.i3 + 8);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 18;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr1628:
               this.i1 = 10;
               this.i3 = li32(this.i5);
               this.i4 = li32(this.i2);
               this.i3 = this.i3 - this.i4;
               this.i3 = this.i3 / 12;
               mstate.esp = mstate.esp - 12;
               this.i3 = this.i3 + -1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i3,mstate.esp + 8);
               state = 19;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 18:
               mstate.esp = mstate.esp + 4;
               §§goto(addr1628);
            case 19:
               mstate.esp = mstate.esp + 12;
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + -108;
               si32(this.i1,this.i5);
               mstate.esp = mstate.esp - 8;
               this.i1 = -2;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
            case 20:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i5);
               this.f0 = lf64(this.i1);
               sf64(this.f0,this.i3);
               this.i1 = li32(this.i1 + 8);
               si32(this.i1,this.i3 + 8);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               mstate.esp = mstate.esp - 8;
               this.i1 = -3;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
            case 21:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i5);
               this.i4 = this.i1;
               this.i7 = this.i1 + 12;
               if(uint(this.i7) >= uint(this.i3))
               {
                  this.i1 = this.i3;
               }
               else
               {
                  this.i1 = this.i1 + 12;
                  this.i3 = this.i4;
                  while(true)
                  {
                     this.f0 = lf64(this.i3 + 12);
                     sf64(this.f0,this.i3);
                     this.i4 = li32(this.i3 + 20);
                     si32(this.i4,this.i3 + 8);
                     this.i3 = li32(this.i5);
                     this.i4 = this.i1 + 12;
                     this.i7 = this.i1;
                     if(uint(this.i4) >= uint(this.i3))
                     {
                        break;
                     }
                     this.i1 = this.i4;
                     this.i3 = this.i7;
                  }
                  this.i1 = this.i3;
               }
               this.i1 = this.i1 + -12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 53;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr4569:
               this.i1 = 2;
               this.i3 = li32(this.i5);
               this.i2 = li32(this.i2);
               this.i2 = this.i3 - this.i2;
               this.i2 = this.i2 / 12;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 + -1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 54;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 22:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               if(this.i3 != 0)
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i4,mstate.esp);
                  state = 23;
                  mstate.esp = mstate.esp - 4;
                  mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
                  return;
               }
               this.i3 = li32(FSM_push_as3_to_lua_stack_if_convertible);
               mstate.esp = mstate.esp - 8;
               si32(this.i4,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 24;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 23:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i3 = li8(this.i4);
               this.i6 = this.i4;
               if(this.i3 != 0)
               {
                  this.i3 = this.i6;
                  while(true)
                  {
                     this.i7 = li8(this.i3 + 1);
                     this.i3 = this.i3 + 1;
                     this.i8 = this.i3;
                     if(this.i7 != 0)
                     {
                        this.i3 = this.i8;
                        continue;
                     }
                     break;
                  }
               }
               else
               {
                  this.i3 = this.i4;
               }
               this.i7 = li32(this.i0 + 16);
               this.i8 = li32(this.i7 + 68);
               this.i7 = li32(this.i7 + 64);
               this.i3 = this.i3 - this.i6;
               if(uint(this.i8) >= uint(this.i7))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 56;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr4798:
               this.i6 = 4;
               this.i7 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               si32(this.i0,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               si32(this.i3,mstate.esp + 8);
               state = 57;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 24:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               if(this.i3 != 0)
               {
                  this.i3 = 1;
                  mstate.esp = mstate.esp - 4;
                  si32(this.i4,mstate.esp);
                  state = 25;
                  mstate.esp = mstate.esp - 4;
                  mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
                  return;
               }
               state = 26;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 25:
               this.i4 = mstate.eax;
               this.i4 = this.i4 != 0?1:0;
               mstate.esp = mstate.esp + 4;
               this.i6 = li32(this.i5);
               this.i4 = this.i4 & 1;
               si32(this.i4,this.i6);
               si32(this.i3,this.i6 + 8);
               this.i4 = li32(this.i5);
               this.i4 = this.i4 + 12;
               si32(this.i4,this.i5);
               this.i3 = li32(this.i2);
               this.i4 = this.i4 - this.i3;
               this.i3 = this.i1 + 1;
               this.i4 = this.i4 / 12;
               if(this.i4 != this.i3)
               {
                  addr416:
                  §§goto(addr417);
               }
               else
               {
                  §§goto(addr242);
               }
            case 26:
               this.i3 = mstate.eax;
               if(this.i3 == this.i4)
               {
                  this.i4 = 0;
                  this.i3 = li32(this.i5);
                  si32(this.i4,this.i3 + 8);
                  this.i4 = li32(this.i5);
                  this.i4 = this.i4 + 12;
                  si32(this.i4,this.i5);
                  this.i3 = li32(this.i2);
                  this.i4 = this.i4 - this.i3;
                  this.i3 = this.i1 + 1;
                  this.i4 = this.i4 / 12;
                  if(this.i4 != this.i3)
                  {
                     §§goto(addr416);
                  }
                  else
                  {
                     §§goto(addr242);
                  }
               }
               else
               {
                  this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
                  this.i6 = li32(FSM_push_as3_to_lua_stack_if_convertible);
                  mstate.esp = mstate.esp - 16;
                  this.i7 = 0;
                  si32(this.i6,mstate.esp);
                  si32(this.i7,mstate.esp + 4);
                  si32(this.i3,mstate.esp + 8);
                  si32(this.i4,mstate.esp + 12);
                  state = 27;
                  mstate.esp = mstate.esp - 4;
                  mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
                  return;
               }
            case 27:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 16;
               mstate.esp = mstate.esp - 4;
               si32(this.i3,mstate.esp);
               state = 28;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 28:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               mstate.esp = mstate.esp - 4;
               si32(this.i3,mstate.esp);
               state = 29;
               mstate.esp = mstate.esp - 4;
               mstate.funcs[FSM_push_as3_to_lua_stack_if_convertible]();
               return;
            case 29:
               mstate.esp = mstate.esp + 4;
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i6 = 5;
               this.i8 = this.i4;
               while(true)
               {
                  this.i9 = this.i3 + this.i7;
                  this.i10 = this.i8 + this.i7;
                  this.i10 = li8(this.i10);
                  this.i9 = li8(this.i9);
                  if(this.i10 == this.i9)
                  {
                     this.i9 = this.i10 & 255;
                     if(this.i9 != 0)
                     {
                        this.i6 = this.i6 + -1;
                        this.i7 = this.i7 + 1;
                        if(this.i6 != 1)
                        {
                           continue;
                        }
                        this.i3 = 0;
                        mstate.esp = mstate.esp - 8;
                        si32(this.i4,mstate.esp);
                        si32(this.i3,mstate.esp + 4);
                        state = 31;
                        mstate.esp = mstate.esp - 4;
                        FSM_push_as3_to_lua_stack_if_convertible.start();
                        return;
                     }
                     this.i3 = 0;
                     mstate.esp = mstate.esp - 8;
                     si32(this.i4,mstate.esp);
                     si32(this.i3,mstate.esp + 4);
                     state = 32;
                     mstate.esp = mstate.esp - 4;
                     FSM_push_as3_to_lua_stack_if_convertible.start();
                     return;
                  }
                  break;
               }
               this.i3 = 0;
               mstate.esp = mstate.esp - 8;
               si32(this.i4,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 30;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 30:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i4 = li32(this.i5);
               this.i3 = li32(this.i2);
               this.i4 = this.i4 - this.i3;
               this.i4 = this.i4 / 12;
               if(this.i4 == this.i1)
               {
                  this.i0 = 0;
                  break;
               }
               mstate.esp = mstate.esp - 8;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               state = 33;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 31:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               addr2673:
               this.i3 = 0;
               this.i4 = li32(this.i5);
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i4 = li32(this.i2);
               this.i3 = this.i3 - this.i4;
               this.i4 = this.i1 + 1;
               this.i3 = this.i3 / 12;
               if(this.i3 != this.i4)
               {
                  §§goto(addr416);
               }
               else
               {
                  §§goto(addr242);
               }
            case 32:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               §§goto(addr2673);
            case 33:
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i0 + 16);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               this.i6 = this.i0 + 16;
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 34;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr2839:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 16;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 35;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 34:
               mstate.esp = mstate.esp + 4;
               §§goto(addr2839);
            case 35:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i3 = li32(this.i6);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 36;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr2989:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 1;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 37;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 36:
               mstate.esp = mstate.esp + 4;
               §§goto(addr2989);
            case 37:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i4 = this.i3 + 12;
               si32(this.i4,this.i5);
               this.i4 = 1081368576;
               this.i7 = 0;
               si32(this.i7,this.i3 + 12);
               si32(this.i4,this.i3 + 16);
               this.i4 = 3;
               si32(this.i4,this.i3 + 20);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               this.i3 = li32(this.i6);
               this.i4 = li32(this.i3 + 68);
               this.i3 = li32(this.i3 + 64);
               if(uint(this.i4) >= uint(this.i3))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 38;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr3185:
               this.i3 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i4 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i7 = 38;
               si32(this.i0,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               si32(this.i7,mstate.esp + 8);
               state = 39;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 38:
               mstate.esp = mstate.esp + 4;
               §§goto(addr3185);
            case 39:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i4);
               this.i3 = 4;
               si32(this.i3,this.i4 + 8);
               this.i3 = li32(this.i5);
               this.i4 = this.i3 + 12;
               si32(this.i4,this.i5);
               this.f0 = Number(this.i1);
               sf64(this.f0,this.i3 + 12);
               this.i1 = 3;
               si32(this.i1,this.i3 + 20);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 40;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr3374:
               this.i1 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i3 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i4 = 16;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               state = 41;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 40:
               mstate.esp = mstate.esp + 4;
               §§goto(addr3374);
            case 41:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i1,this.i3);
               this.i1 = 4;
               si32(this.i1,this.i3 + 8);
               this.i1 = li32(this.i5);
               this.i3 = this.i1 + 12;
               si32(this.i3,this.i5);
               this.i4 = li32(this.i2);
               this.i3 = this.i3 - this.i4;
               this.i3 = this.i3 / 12;
               this.i3 = this.i3 + -7;
               this.f1 = Number(this.i3);
               sf64(this.f1,this.i1 + 12);
               this.i3 = 3;
               si32(this.i3,this.i1 + 20);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 42;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr3587:
               this.i1 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i3 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i4 = 18;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               state = 43;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 42:
               mstate.esp = mstate.esp + 4;
               §§goto(addr3587);
            case 43:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i1,this.i3);
               this.i1 = 4;
               si32(this.i1,this.i3 + 8);
               this.i1 = li32(this.i5);
               this.i3 = this.i1 + 12;
               si32(this.i3,this.i5);
               sf64(this.f0,this.i1 + 12);
               this.i3 = 3;
               si32(this.i3,this.i1 + 20);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 44;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr3770:
               this.i1 = FSM_push_as3_to_lua_stack_if_convertible;
               this.i3 = li32(this.i5);
               mstate.esp = mstate.esp - 12;
               this.i4 = 1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               state = 45;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 44:
               mstate.esp = mstate.esp + 4;
               §§goto(addr3770);
            case 45:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i1,this.i3);
               this.i1 = 4;
               si32(this.i1,this.i3 + 8);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 46;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr3920:
               this.i1 = 10;
               this.i3 = li32(this.i5);
               this.i4 = li32(this.i2);
               this.i3 = this.i3 - this.i4;
               this.i3 = this.i3 / 12;
               mstate.esp = mstate.esp - 12;
               this.i3 = this.i3 + -1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i3,mstate.esp + 8);
               state = 47;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 46:
               mstate.esp = mstate.esp + 4;
               §§goto(addr3920);
            case 47:
               mstate.esp = mstate.esp + 12;
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + -108;
               si32(this.i1,this.i5);
               mstate.esp = mstate.esp - 8;
               this.i1 = -2;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
            case 48:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i5);
               this.f0 = lf64(this.i1);
               sf64(this.f0,this.i3);
               this.i1 = li32(this.i1 + 8);
               si32(this.i1,this.i3 + 8);
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + 12;
               si32(this.i1,this.i5);
               mstate.esp = mstate.esp - 8;
               this.i1 = -3;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
            case 49:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i5);
               this.i4 = this.i1;
               this.i7 = this.i1 + 12;
               if(uint(this.i7) >= uint(this.i3))
               {
                  this.i1 = this.i3;
               }
               else
               {
                  this.i1 = this.i1 + 12;
                  this.i3 = this.i4;
                  while(true)
                  {
                     this.f0 = lf64(this.i3 + 12);
                     sf64(this.f0,this.i3);
                     this.i4 = li32(this.i3 + 20);
                     si32(this.i4,this.i3 + 8);
                     this.i3 = li32(this.i5);
                     this.i4 = this.i1 + 12;
                     this.i7 = this.i1;
                     if(uint(this.i4) >= uint(this.i3))
                     {
                        break;
                     }
                     this.i1 = this.i4;
                     this.i3 = this.i7;
                  }
                  this.i1 = this.i3;
               }
               this.i1 = this.i1 + -12;
               si32(this.i1,this.i5);
               this.i1 = li32(this.i6);
               this.i3 = li32(this.i1 + 68);
               this.i1 = li32(this.i1 + 64);
               if(uint(this.i3) >= uint(this.i1))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i0,mstate.esp);
                  state = 50;
                  mstate.esp = mstate.esp - 4;
                  FSM_push_as3_to_lua_stack_if_convertible.start();
                  return;
               }
               addr4305:
               this.i1 = 2;
               this.i3 = li32(this.i5);
               this.i2 = li32(this.i2);
               this.i2 = this.i3 - this.i2;
               this.i2 = this.i2 / 12;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 + -1;
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 51;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 50:
               mstate.esp = mstate.esp + 4;
               §§goto(addr4305);
            case 51:
               mstate.esp = mstate.esp + 12;
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + -12;
               si32(this.i1,this.i5);
               mstate.esp = mstate.esp - 4;
               si32(this.i0,mstate.esp);
               state = 52;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 52:
               mstate.esp = mstate.esp + 4;
               this.i0 = 0;
               break;
            case 53:
               mstate.esp = mstate.esp + 4;
               §§goto(addr4569);
            case 54:
               mstate.esp = mstate.esp + 12;
               this.i1 = li32(this.i5);
               this.i1 = this.i1 + -12;
               si32(this.i1,this.i5);
               mstate.esp = mstate.esp - 4;
               si32(this.i0,mstate.esp);
               state = 55;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 55:
               mstate.esp = mstate.esp + 4;
               this.i0 = 1;
               break;
            case 56:
               mstate.esp = mstate.esp + 4;
               §§goto(addr4798);
            case 57:
               this.i3 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i3,this.i7);
               si32(this.i6,this.i7 + 8);
               this.i3 = li32(this.i5);
               this.i3 = this.i3 + 12;
               si32(this.i3,this.i5);
               mstate.esp = mstate.esp - 8;
               this.i3 = 0;
               si32(this.i4,mstate.esp);
               si32(this.i3,mstate.esp + 4);
               state = 58;
               mstate.esp = mstate.esp - 4;
               FSM_push_as3_to_lua_stack_if_convertible.start();
               return;
            case 58:
               this.i4 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i4 = li32(this.i5);
               this.i3 = li32(this.i2);
               this.i4 = this.i4 - this.i3;
               this.i3 = this.i1 + 1;
               this.i4 = this.i4 / 12;
               if(this.i4 != this.i3)
               {
                  §§goto(addr416);
               }
               else
               {
                  §§goto(addr242);
               }
         }
         mstate.eax = this.i0;
         mstate.esp = mstate.ebp;
         mstate.ebp = li32(mstate.esp);
         mstate.esp = mstate.esp + 4;
         mstate.esp = mstate.esp + 4;
         mstate.gworker = caller;
      }
   }
}
