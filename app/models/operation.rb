# frozen_string_literal: true

# {Operation} provides generic methods for the accounting operations
# models.
# @abstract
class Operation < ActiveRecord::Base
  belongs_to :reference, polymorphic: true
  belongs_to :currency, foreign_key: :currency_id

  self.abstract_class = true

  class << self
    def balance(currency:)
      where(currency: currency).yield_self do |operations|
        operations.sum(:credit) - operations.sum(:debit)
      end
    end
  end
end
