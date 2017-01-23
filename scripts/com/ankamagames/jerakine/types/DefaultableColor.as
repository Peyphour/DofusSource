package com.ankamagames.jerakine.types
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class DefaultableColor extends Color implements IExternalizable
   {
       
      
      public var isDefault:Boolean = false;
      
      public function DefaultableColor(param1:uint = 0)
      {
         super(param1);
      }
      
      override public function writeExternal(param1:IDataOutput) : void
      {
         super.writeExternal(param1);
         param1.writeBoolean(this.isDefault);
      }
      
      override public function readExternal(param1:IDataInput) : void
      {
         super.readExternal(param1);
         this.isDefault = param1.readBoolean();
      }
   }
}
