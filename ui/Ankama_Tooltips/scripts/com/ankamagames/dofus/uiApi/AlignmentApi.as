package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.alignments.AlignmentBalance;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentEffect;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentOrder;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRank;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRankJntGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   
   public class AlignmentApi
   {
       
      
      public function AlignmentApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getBalance(param1:uint) : AlignmentBalance
      {
         return null;
      }
      
      [Untrusted]
      public function getBalances() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getEffect(param1:uint) : AlignmentEffect
      {
         return null;
      }
      
      [Untrusted]
      public function getGift(param1:uint) : AlignmentGift
      {
         return null;
      }
      
      [Untrusted]
      public function getGifts() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getRankGifts(param1:uint) : AlignmentRankJntGift
      {
         return null;
      }
      
      [Untrusted]
      public function getGiftEffect(param1:uint) : AlignmentEffect
      {
         return null;
      }
      
      [Untrusted]
      public function getOrder(param1:uint) : AlignmentOrder
      {
         return null;
      }
      
      [Untrusted]
      public function getOrders() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getRank(param1:uint) : AlignmentRank
      {
         return null;
      }
      
      [Untrusted]
      public function getRanks() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getRankOrder(param1:uint) : AlignmentOrder
      {
         return null;
      }
      
      [Untrusted]
      public function getOrderRanks(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSide(param1:uint) : AlignmentSide
      {
         return null;
      }
      
      [Untrusted]
      public function getOrderSide(param1:uint) : AlignmentSide
      {
         return null;
      }
      
      [Untrusted]
      public function getSideOrders(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleName(param1:uint, param2:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleShortName(param1:uint, param2:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getPlayerRank() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlliancesOnTheHill() : Object
      {
         return null;
      }
   }
}
