package com.ankama.codegen.client.model
{
   public class GameActionsDefinition
   {
       
      
      public var id:Number = 0;
      
      public var category_id:Number = 0;
      
      public var name:String = null;
      
      public var restriction_id:Number = 0;
      
      public var actions:GameActionsActionsMeta = null;
      
      public var online_date:Date = null;
      
      public var offline_date:Date = null;
      
      public var added_date:Date = null;
      
      public var added_account_id:Number = 0;
      
      public var modified_date:Date = null;
      
      public var modified_account_id:Number = 0;
      
      public var definition_lang:Array;
      
      public var definition_title:Array;
      
      public var definition_description:Array;
      
      public function GameActionsDefinition()
      {
         this.definition_lang = new Array();
         this.definition_title = new Array();
         this.definition_description = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsDefinition {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  category_id: ").concat(this.category_id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  restriction_id: ").concat(this.restriction_id).concat("\n");
         _loc1_.concat("  actions: ").concat(this.actions).concat("\n");
         _loc1_.concat("  online_date: ").concat(this.online_date).concat("\n");
         _loc1_.concat("  offline_date: ").concat(this.offline_date).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("  added_account_id: ").concat(this.added_account_id).concat("\n");
         _loc1_.concat("  modified_date: ").concat(this.modified_date).concat("\n");
         _loc1_.concat("  modified_account_id: ").concat(this.modified_account_id).concat("\n");
         _loc1_.concat("  definition_lang: ").concat(this.definition_lang).concat("\n");
         _loc1_.concat("  definition_title: ").concat(this.definition_title).concat("\n");
         _loc1_.concat("  definition_description: ").concat(this.definition_description).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
