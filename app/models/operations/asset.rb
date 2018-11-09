# frozen_string_literal: true

module Operations
  # {Asset} is a balance sheet operation
  class Asset < Base
    belongs_to :ref, polymorphic: true
    belongs_to :currency, foreign_key: :currency_id

    validates :code, numericality: { greater_than_or_equal_to: 101, less_than: 199 }


    def self.debit!(attributes, amount)
      # Create with reference and correct attributes
      attributes[:debit] = amount
      create!(attributes)
    end

    def self.credit!(attributes, amount)
      # Create with reference and correct attributes
      attributes[:credit] = amount
      create!(attributes)
    end

    def self.transfer!(entry)
      raise 'This method not implemented for Assets!'
      # Parsing entry

      # Create with reference
      create!(ref: entry)
    end
  end
end

# == Schema Information
# Schema version: 20181105120211
#
# Table name: assets
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
#  index_assets_on_currency_id          (currency_id)
#  index_assets_on_ref_type_and_ref_id  (ref_type,ref_id)
#
