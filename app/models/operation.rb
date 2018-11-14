# frozen_string_literal: true

# {Operation} provides generic methods for the accounting operations
# models.
# @abstract
class Operation < ActiveRecord::Base
  belongs_to :reference, polymorphic: true
  belongs_to :currency, foreign_key: :currency_id

  self.abstract_class = true
end
