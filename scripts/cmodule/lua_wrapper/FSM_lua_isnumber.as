package cmodule.lua_wrapper
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_lua_isnumber extends Machine
   {
      
      public static const intRegCount:int = 2;
      
      public static const NumberRegCount:int = 1;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var f0:Number;
      
      public function FSM_lua_isnumber()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_lua_isnumber = null;
         _loc1_ = new FSM_lua_isnumber();
         FSM_lua_isnumber.gworker = _loc1_;
      }
      
      override public final function work() : void
      {
         switch(state)
         {
            case 0:
               mstate.esp = mstate.esp - 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp = mstate.esp - 32;
               mstate.esp = mstate.esp - 8;
               this.i0 = li32(mstate.ebp + 8);
               this.i1 = li32(mstate.ebp + 12);
               si32(this.i0,mstate.esp);
               si32(this.i1,mstate.esp + 4);
               mstate.esp = mstate.esp - 4;
               FSM_lua_isnumber.start();
            case 1:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               this.i1 = li32(this.i0 + 8);
               if(this.i1 != 3)
               {
                  if(this.i1 == 4)
                  {
                     this.i1 = mstate.ebp + -8;
                     this.i0 = li32(this.i0);
                     mstate.esp = mstate.esp - 8;
                     this.i0 = this.i0 + 16;
                     si32(this.i0,mstate.esp);
                     si32(this.i1,mstate.esp + 4);
                     state = 2;
                     mstate.esp = mstate.esp - 4;
                     FSM_lua_isnumber.start();
                     return;
                  }
                  addr187:
                  addr190:
                  this.i0 = 0;
                  mstate.eax = this.i0;
                  mstate.esp = mstate.ebp;
                  mstate.ebp = li32(mstate.esp);
                  mstate.esp = mstate.esp + 4;
                  mstate.esp = mstate.esp + 4;
                  mstate.gworker = caller;
                  return;
               }
               break;
            case 2:
               this.i0 = mstate.eax;
               mstate.esp = mstate.esp + 8;
               if(this.i0 != 0)
               {
                  this.i0 = 3;
                  this.f0 = lf64(mstate.ebp + -8);
                  sf64(this.f0,mstate.ebp + -32);
                  si32(this.i0,mstate.ebp + -24);
                  break;
               }
               §§goto(addr187);
         }
         this.i0 = 1;
         §§goto(addr190);
      }
   }
}
