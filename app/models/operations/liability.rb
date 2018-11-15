# frozen_string_literal: true

module Operations
  # {Liability} is a balance sheet operation
  class Liability < Operation
    class << self
      def credit(reference:, amount:, kind:)
        currency = reference.currency
        account_code = Chart.code_for(
          type: :liability,
          kind: kind,
          currency_type: currency.type.to_sym
        )
        create!(
          credit:      amount,
          reference:   reference,
          currency_id: currency.id,
          code:        account_code
        )
      end

      def debit(reference:, amount:, kind:)
        currency = reference.currency
        account_code = Chart.code_for(
          type: :liability,
          kind: kind,
          currency_type: currency.type.to_sym
        )
        create!(
          debit:       amount,
          reference:   reference,
          currency_id: currency.id,
          code:        account_code
        )
      end

      def transfer!(main, locked, attrs)
        if attrs[:ref].is_a?(Order)
          attrs[:code] = main
          debit!(attrs, attrs[:ref].locked)
          attrs[:code] = locked
          credit!(attrs, attrs[:ref].locked)
        else
          raise 'Not implemented!'
          # credit!(attrs, attrs[:ref].volume)
        end
        # Create with reference
      end
    end
  end
end

# == Schema Information
# Schema version: 20181105120211
#
# Table name: liabilities
#
#  id             :integer          not null, primary key
#  code           :integer          not null
#  currency_id    :string(255)      not null
#  member_id      :integer          not null
#  reference_id   :integer          not null
#  reference_type :string(255)      not null
#  debit          :decimal(32, 16)  default(0.0), not null
#  credit         :decimal(32, 16)  default(0.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_liabilities_on_currency_id                      (currency_id)
#  index_liabilities_on_member_id                        (member_id)
#  index_liabilities_on_reference_type_and_reference_id  (reference_type,reference_id)
#
