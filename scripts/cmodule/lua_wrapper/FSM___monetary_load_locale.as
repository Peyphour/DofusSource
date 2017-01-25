package cmodule.lua_wrapper
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public final class FSM___monetary_load_locale extends Machine
   {
      
      public static const intRegCount:int = 7;
      
      public static const NumberRegCount:int = 0;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public function FSM___monetary_load_locale()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM___monetary_load_locale = null;
         _loc1_ = new FSM___monetary_load_locale();
         FSM___monetary_load_locale.gworker = _loc1_;
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
               this.i0 = FSM___monetary_load_locale;
               mstate.esp = mstate.esp - 28;
               this.i1 = li32(mstate.ebp + 8);
               this.i2 = FSM___monetary_load_locale;
               this.i3 = FSM___monetary_load_locale;
               this.i4 = FSM___monetary_load_locale;
               this.i5 = 15;
               this.i6 = 21;
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               si32(this.i2,mstate.esp + 8);
               si32(this.i3,mstate.esp + 12);
               si32(this.i6,mstate.esp + 16);
               si32(this.i5,mstate.esp + 20);
               si32(this.i4,mstate.esp + 24);
               state = 1;
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
               return;
            case 1:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 28;
               if(this.i0 != -1)
               {
                  this.i1 = 0;
                  si8(this.i1,FSM___monetary_load_locale);
                  if(this.i0 == 0)
                  {
                     this.i1 = li32(FSM___monetary_load_locale + 16);
                     mstate.esp = mstate.esp - 4;
                     si32(this.i1,mstate.esp);
                     mstate.esp = mstate.esp - 4;
                     FSM___monetary_load_locale.start();
                  }
               }
               addr1115:
               mstate.eax = this.i0;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp = mstate.esp + 4;
               mstate.esp = mstate.esp + 4;
               mstate.gworker = caller;
               return;
            case 2:
               this.i1 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               si32(this.i1,FSM___monetary_load_locale + 16);
               this.i1 = li32(FSM___monetary_load_locale + 28);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 3:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 32);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 4:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 36);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 5:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 40);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 6:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 44);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 7:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 48);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 8:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 52);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 9:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 56);
               mstate.esp = mstate.esp - 4;
               si32(this.i1,mstate.esp);
               mstate.esp = mstate.esp - 4;
               FSM___monetary_load_locale.start();
            case 10:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 60);
               if(this.i1 == 0)
               {
                  this.i1 = li32(FSM___monetary_load_locale + 36);
                  si32(this.i1,FSM___monetary_load_locale + 60);
                  this.i1 = li32(FSM___monetary_load_locale + 64);
                  if(this.i1 != 0)
                  {
                     addr660:
                     mstate.esp = mstate.esp - 4;
                     si32(this.i1,mstate.esp);
                     mstate.esp = mstate.esp - 4;
                     FSM___monetary_load_locale.start();
                  }
                  addr866:
                  this.i1 = li32(FSM___monetary_load_locale + 40);
                  si32(this.i1,FSM___monetary_load_locale + 68);
                  this.i1 = li32(FSM___monetary_load_locale + 72);
                  addr1040:
                  if(this.i1 != 0)
                  {
                     addr893:
                     mstate.esp = mstate.esp - 4;
                     si32(this.i1,mstate.esp);
                     mstate.esp = mstate.esp - 4;
                     FSM___monetary_load_locale.start();
                  }
                  else
                  {
                     addr953:
                     this.i1 = li32(FSM___monetary_load_locale + 48);
                     si32(this.i1,FSM___monetary_load_locale + 72);
                     this.i1 = li32(FSM___monetary_load_locale + 76);
                     addr1144:
                     if(this.i1 != 0)
                     {
                        addr980:
                        mstate.esp = mstate.esp - 4;
                        si32(this.i1,mstate.esp);
                        mstate.esp = mstate.esp - 4;
                        FSM___monetary_load_locale.start();
                     }
                     addr1144:
                     this.i1 = li32(FSM___monetary_load_locale + 56);
                     si32(this.i1,FSM___monetary_load_locale + 80);
                     §§goto(addr1115);
                  }
                  this.i1 = li32(FSM___monetary_load_locale + 52);
                  si32(this.i1,FSM___monetary_load_locale + 76);
                  this.i1 = li32(FSM___monetary_load_locale + 80);
                  if(this.i1 != 0)
                  {
                     addr1067:
                     mstate.esp = mstate.esp - 4;
                     si32(this.i1,mstate.esp);
                     mstate.esp = mstate.esp - 4;
                     FSM___monetary_load_locale.start();
                  }
                  else
                  {
                     §§goto(addr1144);
                  }
                  §§goto(addr1115);
               }
               else
               {
                  mstate.esp = mstate.esp - 4;
                  si32(this.i1,mstate.esp);
                  mstate.esp = mstate.esp - 4;
                  FSM___monetary_load_locale.start();
               }
               addr779:
               this.i1 = li32(FSM___monetary_load_locale + 44);
               si32(this.i1,FSM___monetary_load_locale + 64);
               this.i1 = li32(FSM___monetary_load_locale + 68);
               if(this.i1 != 0)
               {
                  addr806:
                  mstate.esp = mstate.esp - 4;
                  si32(this.i1,mstate.esp);
                  mstate.esp = mstate.esp - 4;
                  FSM___monetary_load_locale.start();
               }
               else
               {
                  §§goto(addr866);
               }
               §§goto(addr953);
            case 11:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 68);
               if(this.i1 != 0)
               {
                  §§goto(addr806);
               }
               else
               {
                  §§goto(addr866);
               }
               §§goto(addr953);
            case 12:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 64);
               if(this.i1 != 0)
               {
                  §§goto(addr660);
               }
               else
               {
                  §§goto(addr779);
               }
               §§goto(addr866);
            case 13:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 72);
               if(this.i1 != 0)
               {
                  §§goto(addr893);
               }
               else
               {
                  §§goto(addr953);
               }
               §§goto(addr1040);
            case 14:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 76);
               if(this.i1 != 0)
               {
                  §§goto(addr980);
               }
               else
               {
                  §§goto(addr1040);
               }
               §§goto(addr1144);
            case 15:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               this.i1 = li32(FSM___monetary_load_locale + 80);
               if(this.i1 != 0)
               {
                  §§goto(addr1067);
               }
               else
               {
                  §§goto(addr1144);
               }
               §§goto(addr1115);
            case 16:
               this.i2 = mstate.eax;
               mstate.esp = mstate.esp + 4;
               this.i2 = this.i2 == -1?127:int(this.i2);
               si8(this.i2,this.i1);
               §§goto(addr1115);
         }
      }
   }
}
