package com.ankamagames.jerakine.types
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class ARGBColor extends DefaultableColor implements IExternalizable
   {
       
      
      private var _alpha:uint;
      
      public function ARGBColor(param1:uint = 0)
      {
         super(param1);
      }
      
      public function get alpha() : Number
      {
         return this._alpha / 255;
      }
      
      override public function readExternal(param1:IDataInput) : void
      {
         this._alpha = param1.readUnsignedByte();
         super.readExternal(param1);
      }
      
      override public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeByte(this._alpha);
         super.writeExternal(param1);
      }
      
      override public function release() : void
      {
         this._alpha = 0;
         super.release();
      }
      
      override protected function parseColor(param1:uint) : void
      {
         this._alpha = param1 >> 24 & 255;
         super.parseColor(param1);
      }
   }
}
