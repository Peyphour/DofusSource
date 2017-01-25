package com.ankamagames.dofus.misc.stats.ui
{
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.messages.ColorChangeMessage;
   import com.ankamagames.berilia.components.messages.EntityReadyMessage;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterCreationAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterNameSuggestionRequestAction;
   import com.ankamagames.dofus.misc.stats.StatisticDataTypeEnum;
   import com.ankamagames.dofus.misc.stats.StatsAction;
   import com.ankamagames.dofus.network.enums.StatisticTypeEnum;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.getQualifiedClassName;
   
   public class CharacterCreationStats implements IUiStats
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(CharacterCreationStats));
       
      
      private var _action:StatsAction;
      
      private var _ui:UiRootContainer;
      
      public function CharacterCreationStats(param1:UiRootContainer)
      {
         super();
         this._ui = param1;
         this._action = StatsAction.get(StatisticTypeEnum.STEP0200_CREATE_FIRST_CHARACTER);
         this._action.addParam("Breed_ID",StatisticDataTypeEnum.BYTE);
         this._action.addParam("Gender",StatisticDataTypeEnum.STRING);
         this._action.addParam("Face_Chosen",StatisticDataTypeEnum.SHORT);
         this._action.addParam("Used_Style_Generator",StatisticDataTypeEnum.BOOLEAN);
         this._action.addParam("Used_Proposed_Style",StatisticDataTypeEnum.BOOLEAN);
         this._action.addParam("Used_Name_Generator",StatisticDataTypeEnum.BOOLEAN);
         this._action.start();
      }
      
      public function process(param1:Message) : void
      {
         var _loc2_:EntityReadyMessage = null;
         var _loc3_:EntityDisplayer = null;
         var _loc4_:MouseClickMessage = null;
         switch(true)
         {
            case param1 is CharacterCreationAction:
               this._action.setParam("Gender",!!(this._ui.getElement("btn_breedSex0") as ButtonContainer).selected?"M":"F");
               this._action.send();
               break;
            case param1 is EntityReadyMessage:
               _loc2_ = param1 as EntityReadyMessage;
               _loc3_ = _loc2_.target as EntityDisplayer;
               this._action.setParam("Breed_ID",_loc3_.look.skins[0]);
               this._action.setParam("Face_Chosen",_loc3_.look.skins[1]);
               break;
            case param1 is CharacterNameSuggestionRequestAction:
               this._action.setParam("Used_Name_Generator",true);
               break;
            case param1 is MouseClickMessage:
               _loc4_ = param1 as MouseClickMessage;
               switch(_loc4_.target.name)
               {
                  case "btn_generateColor":
                     this._action.setParam("Used_Style_Generator",true);
                     break;
                  case "btn_reinitColor":
                     this._action.setParam("Used_Proposed_Style",false);
                     break;
                  case "btn_breedSex0":
                  case "btn_customSex0":
                     this._action.setParam("Gender","M");
                     break;
                  case "btn_breedSex1":
                  case "btn_customSex1":
                     this._action.setParam("Gender","F");
               }
               break;
            case param1 is ColorChangeMessage:
               this._action.setParam("Used_Proposed_Style",false);
         }
      }
      
      public function onHook(param1:Hook, param2:Array) : void
      {
      }
      
      public function remove() : void
      {
      }
   }
}
