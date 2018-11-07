# frozen_string_literal: true

# Provides models and errors for the ::AccountingService.
module Operations
  # {Operations::Base} provides generic methods for the accounting operations
  # models.
  # @abstract
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end
end
