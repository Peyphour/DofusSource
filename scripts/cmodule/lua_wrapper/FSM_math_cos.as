package cmodule.lua_wrapper
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_math_cos extends Machine
   {
      
      public static const intRegCount:int = 4;
      
      public static const NumberRegCount:int = 1;
       
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var f0:Number;
      
      public var i3:int;
      
      public function FSM_math_cos()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM_math_cos = null;
         _loc1_ = new FSM_math_cos();
         FSM_math_cos.gworker = _loc1_;
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
               this.i0 = 1;
               mstate.esp = mstate.esp - 8;
               this.i1 = li32(mstate.ebp + 8);
               si32(this.i1,mstate.esp);
               si32(this.i0,mstate.esp + 4);
               state = 1;
               mstate.esp = mstate.esp - 4;
               FSM_math_cos.start();
               return;
            case 1:
               this.f0 = mstate.st0;
               mstate.esp = mstate.esp + 8;
               this.f0 = Math.cos(this.f0);
               this.i2 = li32(this.i1 + 8);
               sf64(this.f0,this.i2);
               this.i3 = 3;
               si32(this.i3,this.i2 + 8);
               this.i2 = li32(this.i1 + 8);
               this.i2 = this.i2 + 12;
               si32(this.i2,this.i1 + 8);
               mstate.eax = this.i0;
               mstate.esp = mstate.ebp;
               mstate.ebp = li32(mstate.esp);
               mstate.esp = mstate.esp + 4;
               mstate.esp = mstate.esp + 4;
               mstate.gworker = caller;
               return;
         }
      }
   }
}