package com.ankamagames.berilia.components.messages
{
   import com.ankamagames.berilia.components.TextureBase;
   
   public class TextureLoadFailMessage extends ComponentMessage
   {
       
      
      private var _texture:TextureBase;
      
      public function TextureLoadFailMessage(param1:TextureBase)
      {
         super(param1);
         this._texture = param1;
      }
      
      public function get texture() : TextureBase
      {
         return this._texture;
      }
   }
}
