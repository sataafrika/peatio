# frozen_string_literal: true

# AccountingService provides basic accounting tools.
#
# Operation.debit/credit/transfer
#
#
module AccountingService
  # Takes a {::Deposit} and creates an operation for it.
  #
  # Here's it's basic flow:
  # 1. Create {Operations::Asset} for coin or fiat (*credit*), code: +102/101+
  # 2. Create main Liability for coin or fiat (*credit*), code: +202/201+
  def self.record_deposit(deposit)
    account = deposit.account
    if deposit.valid?
      account.transaction do
        # 1- update member account balance
        # 2- create credit assets
        # 3- create debit liability
        account.plus_funds(deposit.amount)
        Operations::Asset.credit!(deposit)
        Operations::Liability.credit!(deposit)
      end
    end
  end

  # Takes a {::Withdraw} and creates an operation for it.
  #
  # 1. Create +Expense+ for blockchain fees (*credit*), code: +542+.
  # 2. Create +Revenues+ for platform withdraw fees (*credit*), code: ???.
  #    This two operations need to discuss (1, 2)
  # 3. Create +Asset+ for minus funds (*debit*), code: +102/101+.
  # 4. Create main +Liability+ for minus funds (*debit*), code: +201/202+.
  def self.record_withdrawal(withdraw)
    raise ArgumentError unless withdraw.is_a?(Withdraw)
    if withdraw.valid?
      withdraw.account.transaction do
        # 1- update member account balance
        # 2- create debit assets
        # 3- create credit liability
        # 4- create Revenue/Expense for fee ???
        account.plus_funds(amount)
        Operations::Asset.debit!(withdraw)
        Operations::Liability.debit!(withdraw)
        Operations::Expense.credit!(withdraw)
      end
    end
  end

  # 1. Create locked Liability for plus locked funds  (credit), code: 212
  # 2. Create main Liability for minus funds fot locking (debit), code: 202
  def self.record_order(order)
    if order.valid?
      order.transaction do
        account1 = {
          code: 212,
          member_id: 42
        }
        "%04d-%08d" % [212, 42]
        Operations::Liability.transfer!(account1, account2, amount, currency)
        # 1- update member account balance
        # 2- create transfer from main to locked account liability
        # Operations::Liability.transfer(src: account1.main, dst: account1.locked)
      end
    end
  end

  # subject { AccountingService.create_trade(trade) }
  # 1. Create main Liability for plus funds after trade (credit), code: 202
  # 2. Create Revenues for trading fees income (credit), code: 410
  # 3. Create locked Liability for minus unlock funds (debit), code: 212
  def self.record_trade(trade)
    if trade.valid?
      order.transaction do
        # 1- update member account balance
        # 2- create debit locked liability for order amount
        # 3- create credit main liability for trade amount
        # 4- create credit Revenues for platform trading fees
      end
    end
  end
end
