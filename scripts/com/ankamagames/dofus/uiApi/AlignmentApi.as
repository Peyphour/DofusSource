package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentBalance;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentEffect;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentOrder;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRank;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRankJntGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentTitle;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.internalDatacenter.conquest.AllianceOnTheHillWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AlignmentFrame;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class AlignmentApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _orderRanks:Array;
      
      private var _rankGifts:Array;
      
      private var _rankId:uint;
      
      private var _sideOrders:Array;
      
      private var _sideId:uint;
      
      private var include_mapPosition:MapPosition = null;
      
      public function AlignmentApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DataApi));
         super();
      }
      
      private function get allianceFrame() : AllianceFrame
      {
         return Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
      }
      
      private function get alignmentFrame() : AlignmentFrame
      {
         return Kernel.getWorker().getFrame(AlignmentFrame) as AlignmentFrame;
      }
      
      private function get roleplayEntitiesFrame() : RoleplayEntitiesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._orderRanks = null;
         this._rankGifts = null;
         this._sideOrders = null;
      }
      
      [Untrusted]
      public function getBalance(param1:uint) : AlignmentBalance
      {
         return AlignmentBalance.getAlignmentBalanceById(param1);
      }
      
      [Untrusted]
      public function getBalances() : Array
      {
         return AlignmentBalance.getAlignmentBalances();
      }
      
      [Untrusted]
      public function getEffect(param1:uint) : AlignmentEffect
      {
         return AlignmentEffect.getAlignmentEffectById(param1);
      }
      
      [Untrusted]
      public function getGift(param1:uint) : AlignmentGift
      {
         return AlignmentGift.getAlignmentGiftById(param1);
      }
      
      [Untrusted]
      public function getGifts() : Array
      {
         return AlignmentGift.getAlignmentGifts();
      }
      
      [Untrusted]
      public function getRankGifts(param1:uint) : AlignmentRankJntGift
      {
         return AlignmentRankJntGift.getAlignmentRankJntGiftById(param1);
      }
      
      [Untrusted]
      public function getGiftEffect(param1:uint) : AlignmentEffect
      {
         return this.getEffect(this.getGift(param1).effectId);
      }
      
      [Untrusted]
      public function getOrder(param1:uint) : AlignmentOrder
      {
         return AlignmentOrder.getAlignmentOrderById(param1);
      }
      
      [Untrusted]
      public function getOrders() : Array
      {
         return AlignmentOrder.getAlignmentOrders();
      }
      
      [Untrusted]
      public function getRank(param1:uint) : AlignmentRank
      {
         return AlignmentRank.getAlignmentRankById(param1);
      }
      
      [Untrusted]
      public function getRanks() : Array
      {
         return AlignmentRank.getAlignmentRanks();
      }
      
      [Untrusted]
      public function getRankOrder(param1:uint) : AlignmentOrder
      {
         return this.getOrder(this.getRank(param1).orderId);
      }
      
      [Untrusted]
      public function getOrderRanks(param1:uint) : Array
      {
         var _loc6_:AlignmentRank = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = AlignmentRank.getAlignmentRanks();
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_)
            {
               if(_loc6_.orderId == param1)
               {
                  _loc2_.push(_loc6_);
               }
            }
            _loc5_++;
         }
         return _loc2_.sortOn("minimumAlignment",Array.NUMERIC);
      }
      
      [Untrusted]
      public function getSide(param1:uint) : AlignmentSide
      {
         return AlignmentSide.getAlignmentSideById(param1);
      }
      
      [Untrusted]
      public function getOrderSide(param1:uint) : AlignmentSide
      {
         return this.getSide(this.getOrder(param1).sideId);
      }
      
      [Untrusted]
      public function getSideOrders(param1:uint) : Array
      {
         this._sideId = param1;
         AlignmentRank.getAlignmentRanks().forEach(this.filterOrdersBySide);
         return this._sideOrders;
      }
      
      [Untrusted]
      public function getTitleName(param1:uint, param2:int) : String
      {
         return AlignmentTitle.getAlignmentTitlesById(param1).getNameFromGrade(param2);
      }
      
      [Untrusted]
      public function getTitleShortName(param1:uint, param2:int) : String
      {
         return AlignmentTitle.getAlignmentTitlesById(param1).getShortNameFromGrade(param2);
      }
      
      [Untrusted]
      public function getPlayerRank() : int
      {
         return this.alignmentFrame.playerRank;
      }
      
      [Untrusted]
      public function getAlliancesOnTheHill() : Vector.<AllianceOnTheHillWrapper>
      {
         return this.allianceFrame.alliancesOnTheHill;
      }
      
      private function filterGiftsByRank(param1:*, param2:int, param3:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         this._rankGifts = new Array();
         if(param1.id == this._rankId)
         {
            _loc4_ = param1.gifts;
            _loc5_ = AlignmentGift.getAlignmentGifts();
            for each(_loc6_ in _loc4_)
            {
               for each(_loc7_ in _loc5_)
               {
                  if(_loc6_ == _loc7_.id)
                  {
                     this._rankGifts.push(_loc7_);
                  }
               }
            }
         }
      }
      
      private function filterOrdersBySide(param1:*, param2:int, param3:Array) : void
      {
         this._sideOrders = new Array();
         if(param1.sideId == this._sideId)
         {
            this._sideOrders.push(param1);
         }
      }
   }
}
