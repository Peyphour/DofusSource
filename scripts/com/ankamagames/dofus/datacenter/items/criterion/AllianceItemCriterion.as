package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class AllianceItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function AllianceItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         if(_criterionValue == 0)
         {
            return I18n.getUiText("ui.criterion.noAlliance");
         }
         return I18n.getUiText("ui.criterion.hasAlliance");
      }
      
      override public function clone() : IItemCriterion
      {
         var _loc1_:AllianceItemCriterion = new AllianceItemCriterion(this.basicText);
         return _loc1_;
      }
      
      override protected function getCriterion() : int
      {
         var _loc1_:AllianceWrapper = AllianceFrame.getInstance().alliance;
         if(_loc1_)
         {
            return 1;
         }
         return 0;
      }
   }
}
