# frozen_string_literal: true

# AccountingService provides basic accounting tools.
#
# Operation.debit/credit/transfer
#
#
module AccountingService
  # Takes a {::Deposit} and creates an operation for it.
  # def self.record_deposit(deposit)
  #   raise ArgumentError unless deposit.is_a?(Deposit)
  #
  #   if deposit.valid?
  #     deposit.transaction do
  #       # 1- update member account balance
  #       # 2- create credit assets
  #       # 3- create debit liability
  #       deposit.account.plus_funds(deposit.amount)
  #       attrs = { ref: deposit }
  #       attrs[:currency_id] = deposit.currency_id
  #       attrs[:code] = deposit.currency.coin? ? 102 : 101
  #       Operations::Asset.credit!(attrs, deposit.amount)
  #       attrs[:code] = deposit.currency.coin? ? 112 : 111
  #       Operations::Liability.credit!(attrs, deposit.amount)
  #     end
  #   end
  # end

  # Takes a {::Withdraw} and creates an operation for it.
  def self.record_withdraw(withdraw)
    raise ArgumentError unless withdraw.is_a?(Withdraw)

    if withdraw.valid?
      withdraw.transaction do
        # 1- update member account balance
        # 2- create debit assets
        # 3- create debit liability
        # 4- create Revenue/Expense for fee ???
        withdraw.account.plus_funds(withdraw.amount)
        attrs = { ref: withdraw }
        attrs[:currency_id] = withdraw.currency_id
        attrs[:code] = withdraw.currency.coin? ? 102 : 101
        Operations::Asset.debit!(attrs, withdraw.amount)
        attrs[:code] = withdraw.currency.coin? ? 112 : 111
        Operations::Liability.debit!(attrs, withdraw.amount)
        # Operations::Expense.credit!(attrs)
      end
    end
  end

  # Takes a {::Order} and creates an operation for it.
  def self.record_order(order)
    raise ArgumentError unless order.is_a?(Order)

    return unless order.valid?
    order.transaction do
      # 1- update member account balance
      # 2- create transfer from main to locked account liability
      currency = define_currency(order)
      attrs = { ref: order }
      attrs[:currency_id] = currency.id
      main = currency.coin? ? 202 : 201
      locked = currency.coin? ? 212 : 211
      Operations::Liability.transfer!(main, locked, attrs)
    end
  end

  # Takes a {::Trade} and creates an operation for it.
  def self.record_trade(trade)
    raise ArgumentError unless trade.is_a?(Trade)

    if trade.valid?
      trade.transaction do
        bid = trade.bid
        ask = trade.ask
        attrs = { ref: trade }

        # Revenues for platform trading fees
        fee_for_bid = calculate_fee(bid)
        fee_for_ask = calculate_fee(ask)
        Operations::Revenue.credit!(attrs_for_fee(attrs, bid), fee_for_bid)
        Operations::Revenue.credit!(attrs_for_fee(attrs, ask), fee_for_ask)
        
        # Liabilities for recieved amount from trade
        Operations::Liability.credit!(attrs_for_bid(attrs, bid, :credit), bid.funds_received)
        Operations::Liability.credit!(attrs_for_ask(attrs, ask, :credit), ask.funds_received)

        # Liabilities for ulocked funds
        Operations::Liability.debit!(attrs_for_bid(attrs, bid, :debit), ask.funds_received)
        Operations::Liability.debit!(attrs_for_ask(attrs, ask, :debit), bid.funds_received)

        # Operations::Liability.transfer!(locked, main, attrs_bid)
        # 1- update member account balance
        # 2- create debit locked liability for order amount
        # 3- create credit main liability for trade amount
        # 4- create credit Revenues for platform trading fees
      end
    end
  end

  def self.calculate_fee(order)
    order.funds_received * order.fee
  end

  def self.attrs_for_fee(attrs, order)
    currency = define_currency(order)
    attrs[:code] = 410
    attrs[:currency_id] = currency.id
    attrs
  end

  def self.attrs_for_bid(attrs, bid, side)
    currency = define_currency(bid)
    attrs[:member_id] = bid.member_id
    case side
    when :credit
      attrs[:code] = currency.coin? ? 202 : 201
      attrs[:currency_id] = bid.ask
    when :debit
      attrs[:code] = currency.coin? ? 212 : 211
      attrs[:currency_id] = bid.bid
    end
    attrs
  end

  def self.attrs_for_ask(attrs, ask, side)
    currency = define_currency(ask)
    attrs[:member_id] = ask.member_id
    case side
    when :credit
      attrs[:code] = currency.coin? ? 202 : 201
      attrs[:currency_id] = ask.bid
    when :debit
      attrs[:code] = currency.coin? ? 212 : 211
      attrs[:currency_id] = ask.ask
    end
    attrs
  end

  def self.define_currency(order)
    case order.kind
    when 'ask'
      Currency.find(order.ask)
    when 'bid'
      Currency.find(order.bid)
    end
  end
end
