package com.ankamagames.jerakine.messages
{
   import com.ankamagames.jerakine.utils.errors.AbstractMethodCallError;
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   
   public class RegisteringFrame implements Frame
   {
       
      
      private var _allowsRegistration:Boolean;
      
      private var _registeredTypes:Dictionary;
      
      protected var _priority:int = 1;
      
      public function RegisteringFrame()
      {
         super();
         this.initialize();
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:Function = this._registeredTypes[param1["constructor"]];
         if(_loc2_ != null)
         {
            return _loc2_(param1);
         }
         return false;
      }
      
      protected function registerMessages() : void
      {
         throw new AbstractMethodCallError();
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      protected function register(param1:Class, param2:Function) : void
      {
         if(!this._allowsRegistration || !param1)
         {
            throw new IllegalOperationError();
         }
         if(this._registeredTypes[param1])
         {
            throw new IllegalOperationError("Cannot register twice a message");
         }
         this._registeredTypes[param1] = param2;
      }
      
      private function initialize() : void
      {
         this._registeredTypes = new Dictionary();
         this._allowsRegistration = true;
         this.registerMessages();
         this._allowsRegistration = false;
      }
   }
}
