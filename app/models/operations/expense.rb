# frozen_string_literal: true

module Operations
  # {Expense} is a income statement operation
  class Expense < Operation
    def self.debit!(entry)
      # Parsing entry

      # Create with reference
      create!(ref: entry)
    end

    def self.credit!(entry)
      # Parsing entry

      # Create with reference
      create!(ref: entry)
    end

    def self.transfer!(entry)
      # Parsing entry

      # Create with reference
      create!(ref: entry)
    end
  end
end

# == Schema Information
# Schema version: 20181105120211
#
# Table name: expenses
#
#  id             :integer          not null, primary key
#  code           :integer          not null
#  currency_id    :string(255)      not null
#  reference_id   :integer          not null
#  reference_type :string(255)      not null
#  debit          :decimal(32, 16)  default(0.0), not null
#  credit         :decimal(32, 16)  default(0.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_expenses_on_currency_id                      (currency_id)
#  index_expenses_on_reference_type_and_reference_id  (reference_type,reference_id)
#
