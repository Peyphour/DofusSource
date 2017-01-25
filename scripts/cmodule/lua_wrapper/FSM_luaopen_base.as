package cmodule.lua_wrapper
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_luaopen_base extends Machine
   {
      
      public static const intRegCount:int = 7;
      
      public static const NumberRegCount:int = 1;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public var f0:Number;
      
      public function FSM_luaopen_base()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_luaopen_base = null;
         _loc1_ = new FSM_luaopen_base();
         FSM_luaopen_base.gworker = _loc1_;
      }
      
      override public final function work() : void
      {
         switch(state)
         {
            case 0:
               mstate.esp = mstate.esp - 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp = mstate.esp - 96;
               this.i0 = -10002;
               this.i1 = li32(mstate.ebp + 8);
               mstate.esp = mstate.esp - 8;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 1:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i3 = li32(this.i1 + 8);
               this.f0 = lf64(this.i2);
               sf64(this.f0,this.i3);
               this.i2 = li32(this.i2 + 8);
               si32(this.i2,this.i3 + 8);
               this.i2 = li32(this.i1 + 8);
               this.i2 = this.i2 + 12;
               si32(this.i2,this.i1 + 8);
               mstate.esp = mstate.esp - 8;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 2:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = FSM_luaopen_base;
               this.i3 = this.i1 + 8;
               while(true)
               {
                  this.i4 = li8(this.i2 + 1);
                  this.i2 = this.i2 + 1;
                  this.i5 = this.i2;
                  if(this.i4 != 0)
                  {
                     this.i2 = this.i5;
                     continue;
                  }
                  break;
               }
               this.i4 = FSM_luaopen_base;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 - this.i4;
               si32(this.i1,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 3;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 3:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i2,mstate.ebp + -96);
               this.i2 = 4;
               si32(this.i2,mstate.ebp + -88);
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 16;
               this.i2 = this.i2 + -12;
               this.i5 = mstate.ebp + -96;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i5,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 4;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 4:
               mstate.esp = mstate.esp + 16;
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + -12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               si32(this.i1,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               si32(this.i0,mstate.esp + 8);
               state = 5;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 5:
               mstate.esp = mstate.esp + 12;
               this.i0 = li32(this.i1 + 16);
               this.i2 = li32(this.i0 + 68);
               this.i0 = li32(this.i0 + 64);
               this.i4 = this.i1 + 16;
               if(uint(this.i2) >= uint(this.i0))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i1,mstate.esp);
                  state = 6;
                  mstate.esp = mstate.esp - 4;
                  FSM_luaopen_base.start();
                  return;
               }
               addr475:
               this.i0 = FSM_luaopen_base;
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 12;
               this.i5 = 7;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i5,mstate.esp + 8);
               state = 7;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 6:
               mstate.esp = mstate.esp + 4;
               §§goto(addr475);
            case 7:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i0,this.i2);
               this.i0 = 4;
               si32(this.i0,this.i2 + 8);
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + 12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 8;
               this.i0 = -10002;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 8:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = FSM_luaopen_base;
               while(true)
               {
                  this.i5 = li8(this.i2 + 1);
                  this.i2 = this.i2 + 1;
                  this.i6 = this.i2;
                  if(this.i5 != 0)
                  {
                     this.i2 = this.i6;
                     continue;
                  }
                  break;
               }
               this.i5 = FSM_luaopen_base;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 - this.i5;
               si32(this.i1,mstate.esp);
               si32(this.i5,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 9;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 9:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i2,mstate.ebp + -48);
               this.i2 = 4;
               si32(this.i2,mstate.ebp + -40);
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 16;
               this.i2 = this.i2 + -12;
               this.i5 = mstate.ebp + -48;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i5,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 10;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 10:
               mstate.esp = mstate.esp + 16;
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + -12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               this.i2 = 0;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 11;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 11:
               mstate.esp = mstate.esp + 12;
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               this.i2 = 1;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 12;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 12:
               mstate.esp = mstate.esp + 12;
               mstate.esp = mstate.esp - 8;
               this.i0 = -2;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 13:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = FSM_luaopen_base;
               while(true)
               {
                  this.i5 = li8(this.i2 + 1);
                  this.i2 = this.i2 + 1;
                  this.i6 = this.i2;
                  if(this.i5 != 0)
                  {
                     this.i2 = this.i6;
                     continue;
                  }
                  break;
               }
               this.i5 = FSM_luaopen_base;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 - this.i5;
               si32(this.i1,mstate.esp);
               si32(this.i5,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 14;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 14:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i2,mstate.ebp + -32);
               this.i2 = 4;
               si32(this.i2,mstate.ebp + -24);
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 16;
               this.i2 = this.i2 + -12;
               this.i5 = mstate.ebp + -32;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i5,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 15;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 15:
               mstate.esp = mstate.esp + 16;
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + -12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               this.i2 = 0;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 16;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 16:
               mstate.esp = mstate.esp + 12;
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               this.i2 = 1;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 17;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 17:
               mstate.esp = mstate.esp + 12;
               mstate.esp = mstate.esp - 8;
               this.i0 = -2;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 18:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = FSM_luaopen_base;
               while(true)
               {
                  this.i5 = li8(this.i2 + 1);
                  this.i2 = this.i2 + 1;
                  this.i6 = this.i2;
                  if(this.i5 != 0)
                  {
                     this.i2 = this.i6;
                     continue;
                  }
                  break;
               }
               this.i5 = FSM_luaopen_base;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 - this.i5;
               si32(this.i1,mstate.esp);
               si32(this.i5,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 19;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 19:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i2,mstate.ebp + -16);
               this.i2 = 4;
               si32(this.i2,mstate.ebp + -8);
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 16;
               this.i2 = this.i2 + -12;
               this.i5 = mstate.ebp + -16;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i5,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 20;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 20:
               mstate.esp = mstate.esp + 16;
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + -12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 8;
               this.i0 = 1;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               state = 21;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 21:
               mstate.esp = mstate.esp + 8;
               mstate.esp = mstate.esp - 8;
               this.i0 = -1;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 22:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = li32(this.i3);
               this.f0 = lf64(this.i0);
               sf64(this.f0,this.i2);
               this.i0 = li32(this.i0 + 8);
               si32(this.i0,this.i2 + 8);
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + 12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 8;
               this.i0 = -2;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 23:
               mstate.esp = mstate.esp + 8;
               this.i0 = li32(this.i4);
               this.i2 = li32(this.i0 + 68);
               this.i0 = li32(this.i0 + 64);
               if(uint(this.i2) >= uint(this.i0))
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i1,mstate.esp);
                  state = 24;
                  mstate.esp = mstate.esp - 4;
                  FSM_luaopen_base.start();
                  return;
               }
               break;
            case 24:
               mstate.esp = mstate.esp + 4;
               break;
            case 25:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i0,this.i2);
               this.i0 = 4;
               si32(this.i0,this.i2 + 8);
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + 12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 8;
               this.i0 = -2;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 26:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = FSM_luaopen_base;
               while(true)
               {
                  this.i4 = li8(this.i2 + 1);
                  this.i2 = this.i2 + 1;
                  this.i5 = this.i2;
                  if(this.i4 != 0)
                  {
                     this.i2 = this.i5;
                     continue;
                  }
                  break;
               }
               this.i4 = FSM_luaopen_base;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 - this.i4;
               si32(this.i1,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 27;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 27:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i2,mstate.ebp + -64);
               this.i2 = 4;
               si32(this.i2,mstate.ebp + -56);
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 16;
               this.i2 = this.i2 + -12;
               this.i4 = mstate.ebp + -64;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 28;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 28:
               mstate.esp = mstate.esp + 16;
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + -12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               this.i2 = 1;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 29;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 29:
               mstate.esp = mstate.esp + 12;
               mstate.esp = mstate.esp - 8;
               this.i0 = -10002;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
            case 30:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i2 = FSM_luaopen_base;
               while(true)
               {
                  this.i4 = li8(this.i2 + 1);
                  this.i2 = this.i2 + 1;
                  this.i5 = this.i2;
                  if(this.i4 != 0)
                  {
                     this.i2 = this.i5;
                     continue;
                  }
                  break;
               }
               this.i4 = FSM_luaopen_base;
               mstate.esp = mstate.esp - 12;
               this.i2 = this.i2 - this.i4;
               si32(this.i1,mstate.esp);
               si32(this.i4,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 31;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 31:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 12;
               si32(this.i2,mstate.ebp + -80);
               this.i2 = 4;
               si32(this.i2,mstate.ebp + -72);
               this.i2 = li32(this.i3);
               mstate.esp = mstate.esp - 16;
               this.i2 = this.i2 + -12;
               this.i4 = mstate.ebp + -80;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i4,mstate.esp + 8);
               si32(this.i2,mstate.esp + 12);
               state = 32;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 32:
               mstate.esp = mstate.esp + 16;
               this.i0 = li32(this.i3);
               this.i0 = this.i0 + -12;
               si32(this.i0,this.i3);
               mstate.esp = mstate.esp - 12;
               this.i0 = FSM_luaopen_base;
               this.i2 = FSM_luaopen_base;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               state = 33;
               mstate.esp = mstate.esp - 4;
               FSM_luaopen_base.start();
               return;
            case 33:
               mstate.esp = mstate.esp + 12;
               this.i0 = 2;
               mstate.eax = this.i0;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp = mstate.esp + 4;
               mstate.esp = mstate.esp + 4;
               mstate.gworker = caller;
               return;
         }
         this.i0 = FSM_luaopen_base;
         this.i2 = li32(this.i3);
         mstate.esp = mstate.esp - 12;
         this.i4 = 2;
         si32(this.i1,mstate.esp);
         si32(this.i0,mstate.esp + 4);
         si32(this.i4,mstate.esp + 8);
         state = 25;
         mstate.esp = mstate.esp - 4;
         FSM_luaopen_base.start();
      }
   }
}
