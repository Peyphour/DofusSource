package com.ankama.codegen.client.model
{
   public class Account
   {
      
      public static const RestypeEnum_ANKAMA:String = "ANKAMA";
      
      public static const RestypeEnum_EXTERNAL:String = "EXTERNAL";
      
      public static const RestypeEnum_GUEST:String = "GUEST";
      
      public static const RestypeEnum_GHOST:String = "GHOST";
      
      public static const CommunityEnum_COMMUNITY_0:String = "COMMUNITY_0";
      
      public static const CommunityEnum_COMMUNITY_1:String = "COMMUNITY_1";
      
      public static const CommunityEnum_COMMUNITY_2:String = "COMMUNITY_2";
      
      public static const CommunityEnum_COMMUNITY_3:String = "COMMUNITY_3";
      
      public static const CommunityEnum_COMMUNITY_4:String = "COMMUNITY_4";
      
      public static const CommunityEnum_COMMUNITY_5:String = "COMMUNITY_5";
      
      public static const CommunityEnum_COMMUNITY_6:String = "COMMUNITY_6";
      
      public static const CommunityEnum_COMMUNITY_7:String = "COMMUNITY_7";
      
      public static const CommunityEnum_COMMUNITY_8:String = "COMMUNITY_8";
      
      public static const CommunityEnum_COMMUNITY_9:String = "COMMUNITY_9";
      
      public static const CommunityEnum_COMMUNITY_10:String = "COMMUNITY_10";
      
      public static const CommunityEnum_COMMUNITY_11:String = "COMMUNITY_11";
      
      public static const CommunityEnum_COMMUNITY_12:String = "COMMUNITY_12";
      
      public static const CommunityEnum_COMMUNITY_13:String = "COMMUNITY_13";
      
      public static const CommunityEnum_COMMUNITY_14:String = "COMMUNITY_14";
       
      
      public var id:Number = 0;
      
      public var restype:String = null;
      
      public var login:String = null;
      
      public var nickname:String = null;
      
      public var security:Array;
      
      public var lang:String = null;
      
      public var community:String = null;
      
      public var added_date:Date = null;
      
      public var added_ip:String = null;
      
      public var login_date:Date = null;
      
      public var login_ip:String = null;
      
      public function Account()
      {
         this.security = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class Account {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  login: ").concat(this.login).concat("\n");
         _loc1_.concat("  nickname: ").concat(this.nickname).concat("\n");
         _loc1_.concat("  security: ").concat(this.security).concat("\n");
         _loc1_.concat("  lang: ").concat(this.lang).concat("\n");
         _loc1_.concat("  community: ").concat(this.community).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("  added_ip: ").concat(this.added_ip).concat("\n");
         _loc1_.concat("  login_date: ").concat(this.login_date).concat("\n");
         _loc1_.concat("  login_ip: ").concat(this.login_ip).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
