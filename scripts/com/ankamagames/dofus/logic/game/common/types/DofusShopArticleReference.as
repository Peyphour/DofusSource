package com.ankamagames.dofus.logic.game.common.types
{
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.types.Uri;
   
   public class DofusShopArticleReference extends DofusShopObject implements ISlotData, IDataCenter
   {
      
      private static var _errorIconUri:Uri;
       
      
      private var _imageUrl:String;
      
      private var _quantity:uint;
      
      private var _uri:Uri;
      
      private var _backGroundIconUri:Uri;
      
      public function DofusShopArticleReference(param1:Object)
      {
         super(param1);
      }
      
      override public function init(param1:Object) : void
      {
         super.init(param1);
         this._imageUrl = param1.image;
         this._quantity = param1.quantity;
      }
      
      public function get iconUri() : Uri
      {
         if(!this._uri)
         {
            if(this._imageUrl)
            {
               this._uri = new Uri(this._imageUrl);
            }
            else
            {
               this._uri = this.errorIconUri;
            }
         }
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         return null;
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat("error.png"));
         }
         return _errorIconUri;
      }
      
      public function get backGroundIconUri() : Uri
      {
         if(!this._backGroundIconUri)
         {
            this._backGroundIconUri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin").concat("texture/slot/emptySlot.png"));
         }
         return this._backGroundIconUri;
      }
      
      public function set backGroundIconUri(param1:Uri) : void
      {
         this._backGroundIconUri = param1;
      }
      
      public function get info1() : String
      {
         return this._quantity > 1?this._quantity.toString():null;
      }
      
      public function get active() : Boolean
      {
         return false;
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function set endTime(param1:int) : void
      {
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
   }
}
