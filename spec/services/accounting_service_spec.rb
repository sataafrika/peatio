# frozen_string_literal: true


describe AccountingService do

  let(:member) { create(:member) }
  
  let(:currency) { Currency.find(:btc) }

  let()

  context ''
  # 1. Create Asset for coin or fiat (credit), code: 102/101
  # 2. Create main Liability for coin or fiat (credit), code: 202/201
  subject { AccountingService.record_deposit(deposit) }

  it 'create asset and liability records' do
    binding.pry
    
    # Check credit Asset and Liability for subject
  end
end
