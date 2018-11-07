# frozen_string_literal: true

module Operations
  # {Asset} is a balance sheet operation
  class Liability < Base
    belongs_to :ref, polymorphic: true
    belongs_to :currency, foreign_key: :currency_id

    def self.debit!(entry)
      # Parsing entry
      attributes = { ref: entry, member_id: entry.member_id }
      if entry.class.superclass.to_s.in?(%w[Deposit Withdraw])
        attributes[:currency_id] = entry.currency_id
        attributes[:debit] = entry.amount
        attributes[:code] = entry.currency.coin? ? 102 : 101
      elsif entry.class.superclass.to_s.in?(%w[Order])
        raise 'Wrong entry!'
      else
        raise 'Wrong entry!'
      end
      # Create with reference
      create!(attributes)
    end

    def self.credit!(entry)
      # Parsing entry
      attributes = { ref: entry, member_id: entry.member_id }
      if entry.class.superclass.to_s.in?(%w[Deposit Withdraw])
        attributes[:currency_id] = entry.currency_id
        attributes[:debit] = entry.amount
        attributes[:code] = entry.currency.coin? ? 102 : 101
      elsif entry.class.superclass.to_s.in?(%w[Order])
        raise 'Wrong entry!'
      else
        raise 'Wrong entry!'
      end

      # Create with reference
      create!(attributes)
    end

    def self.transfer!(entry)
      # Parsing entry

      # Create with reference
      create!(attributes)
    end
  end
end

# == Schema Information
# Schema version: 20181105120211
#
# Table name: liabilities
#
#  id          :integer          not null, primary key
#  code        :integer          not null
#  currency_id :string(255)      not null
#  member_id   :integer          not null
#  ref_id      :integer          not null
#  ref_type    :string(255)      not null
#  debit       :decimal(32, 16)  default(0.0), not null
#  credit      :decimal(32, 16)  default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_liabilities_on_currency_id          (currency_id)
#  index_liabilities_on_member_id            (member_id)
#  index_liabilities_on_ref_type_and_ref_id  (ref_type,ref_id)
#
