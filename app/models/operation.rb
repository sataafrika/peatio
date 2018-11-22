# frozen_string_literal: true

# {Operation} provides generic methods for the accounting operations
# models.
# @abstract
class Operation < ActiveRecord::Base
  belongs_to :reference, polymorphic: true
  belongs_to :currency, foreign_key: :currency_id

  validates :credit, :debit, numericality: { greater_than_or_equal_to: 0 }

  self.abstract_class = true

  class << self
    def operation_type
      name.demodulize.downcase.to_sym
    end

    def credit!(reference:, amount:, kind: :main, currency: nil)
      return if amount.zero?

      currency ||= reference.currency
      account_code = Operations::Chart.code_for(
        type:          operation_type,
        kind:          kind,
        currency_type: currency.type.to_sym
      )
      create!(
        credit:      amount,
        reference:   reference,
        currency_id: currency.id,
        code:        account_code
      )
    end

    def debit!(reference:, amount:, kind: :main, currency: nil)
      return if amount.zero?

      currency ||= reference.currency
      account_code = Operations::Chart.code_for(
        type:          operation_type,
        kind:          kind,
        currency_type: currency.type.to_sym
      )
      create!(
        debit:       amount,
        reference:   reference,
        currency_id: currency.id,
        code:        account_code
      )
    end

    def balance(currency:)
      where(currency: currency).yield_self do |operations|
        operations.sum(:credit) - operations.sum(:debit)
      end
    end
  end
end
