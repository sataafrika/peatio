# frozen_string_literal: true


describe AccountingService do

  let(:member) { create(:member) }
  let(:order)  { create(:order_bid) }
  let(:trade)  { create(:trade) }
  
  let(:currency) { Currency.find(:btc) }

  context ''
  # 1. Create Asset for coin or fiat (credit), code: 102/101
  # 2. Create main Liability for coin or fiat (credit), code: 202/201
  subject { AccountingService.record_deposit(deposit) }

  it 'create asset and liability records' do
    #AccountingService.record_trade(trade)
    #binding.pry
    
    # Check credit Asset and Liability for subject
  end
end
