package com.ankama.codegen.client.model
{
   public class ShopReference
   {
       
      
      public var description:String = null;
      
      public var name:String = null;
      
      public var free:Boolean = false;
      
      public var quantity:Number = 0;
      
      public var restype:String = null;
      
      public var reference_accountstatus:ShopReferenceTypeAccountStatus = null;
      
      public var reference_icegift:Array;
      
      public var reference_virtualgift:Array;
      
      public var reference_kard:Array;
      
      public var reference_krosmaster:Array;
      
      public var reference_nothing:ShopReferenceTypeNothing = null;
      
      public var reference_tactilewars:ShopReferenceTypeTactilewars = null;
      
      public var reference_virtualsubscriptionlevel:ShopReferenceTypeVirtualSubscriptionLevel = null;
      
      public var reference_video:ShopReferenceTypeVideo = null;
      
      public var reference_music:ShopReferenceTypeMusic = null;
      
      public var reference_flag:ShopReferenceTypeFlag = null;
      
      public var reference_chartransfer:ShopReferenceTypeCharTransfer = null;
      
      public var reference_digitalcomic:ShopReferenceTypeDigitalComic = null;
      
      public var reference_premium:ShopReferenceTypePremium = null;
      
      public var reference_recurringvirtualsubscription:ShopReferenceTypeRecurringVirtualSubscription = null;
      
      public var reference_ogrine:ShopReferenceTypeOgrine = null;
      
      public var reference_gameaction:ShopReferenceTypeGameAction = null;
      
      public function ShopReference()
      {
         this.reference_icegift = new Array();
         this.reference_virtualgift = new Array();
         this.reference_kard = new Array();
         this.reference_krosmaster = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReference {\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  free: ").concat(this.free).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  reference_accountstatus: ").concat(this.reference_accountstatus).concat("\n");
         _loc1_.concat("  reference_icegift: ").concat(this.reference_icegift).concat("\n");
         _loc1_.concat("  reference_virtualgift: ").concat(this.reference_virtualgift).concat("\n");
         _loc1_.concat("  reference_kard: ").concat(this.reference_kard).concat("\n");
         _loc1_.concat("  reference_krosmaster: ").concat(this.reference_krosmaster).concat("\n");
         _loc1_.concat("  reference_nothing: ").concat(this.reference_nothing).concat("\n");
         _loc1_.concat("  reference_tactilewars: ").concat(this.reference_tactilewars).concat("\n");
         _loc1_.concat("  reference_virtualsubscriptionlevel: ").concat(this.reference_virtualsubscriptionlevel).concat("\n");
         _loc1_.concat("  reference_video: ").concat(this.reference_video).concat("\n");
         _loc1_.concat("  reference_music: ").concat(this.reference_music).concat("\n");
         _loc1_.concat("  reference_flag: ").concat(this.reference_flag).concat("\n");
         _loc1_.concat("  reference_chartransfer: ").concat(this.reference_chartransfer).concat("\n");
         _loc1_.concat("  reference_digitalcomic: ").concat(this.reference_digitalcomic).concat("\n");
         _loc1_.concat("  reference_premium: ").concat(this.reference_premium).concat("\n");
         _loc1_.concat("  reference_recurringvirtualsubscription: ").concat(this.reference_recurringvirtualsubscription).concat("\n");
         _loc1_.concat("  reference_ogrine: ").concat(this.reference_ogrine).concat("\n");
         _loc1_.concat("  reference_gameaction: ").concat(this.reference_gameaction).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
