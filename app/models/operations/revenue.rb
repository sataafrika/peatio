# frozen_string_literal: true

module Operations
  # {Revenue} is a income statement operation
  class Revenue < Base
    belongs_to :ref, polymorphic: true
    belongs_to :currency, foreign_key: :currency_id

    def self.debit!(attrs, amount)
      # Parsing entry
      attrs.delete(:credit)
      # Create with reference
      create!(attrs)
    end

    def self.credit!(attrs, amount)
      # Parsing entry
      attrs.delete(:debit)
      attrs[:credit] = amount
      # Create with reference
      create!(attrs)
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
# Table name: revenues
#
#  id          :integer          not null, primary key
#  code        :integer          not null
#  currency_id :string(255)      not null
#  ref_id      :integer          not null
#  ref_type    :string(255)      not null
#  debit       :decimal(32, 16)  default(0.0), not null
#  credit      :decimal(32, 16)  default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_revenues_on_currency_id          (currency_id)
#  index_revenues_on_ref_type_and_ref_id  (ref_type,ref_id)
#
