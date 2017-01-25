package org.as3commons.bytecode.abc
{
   import flash.errors.IllegalOperationError;
   import org.as3commons.bytecode.abc.enum.Opcode;
   
   public final class JumpTargetData
   {
       
      
      private var _jumpOpcode:Op;
      
      private var _targetOpcode:Op;
      
      private var _extraOpcodes:Vector.<Op>;
      
      public function JumpTargetData(param1:Op = null, param2:Op = null)
      {
         super();
         this._jumpOpcode = param1;
         this._targetOpcode = param2;
      }
      
      public function get extraOpcodes() : Vector.<Op>
      {
         return this._extraOpcodes;
      }
      
      public function get targetOpcode() : Op
      {
         return this._targetOpcode;
      }
      
      public function set targetOpcode(param1:Op) : void
      {
         this._targetOpcode = param1;
      }
      
      public function addTarget(param1:Op) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._extraOpcodes = this._extraOpcodes || new Vector.<Op>();
         this._extraOpcodes[this._extraOpcodes.length] = param1;
      }
      
      public function get jumpOpcode() : Op
      {
         return this._jumpOpcode;
      }
      
      public function set jumpOpcode(param1:Op) : void
      {
         this._jumpOpcode = param1;
         if(this._jumpOpcode != null && Opcode.jumpOpcodes[this._jumpOpcode.opcode] == null)
         {
            throw new IllegalOperationError("Opcode " + this._jumpOpcode.opcode.opcodeName + " is not a jump code");
         }
      }
   }
}
