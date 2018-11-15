# encoding: UTF-8
# frozen_string_literal: true

module AccountingService
  class Chart
    CHART = [
      { code:           101,
        type:           :assets,
        kind:           :main,
        currency_type:  :fiat,
        description:    'Main Fiat Assets Account',
        scope:          %i[member]
      },
      { code:           102,
        type:           :assets,
        kind:           :main,
        currency_type:  :coin,
        description:    'Main Crypto Assets Account',
        scope:          %i[member]
      },
      { code:           201,
        type:           :liabilities,
        kind:           :main,
        currency_type:  :fiat,
        description:    'Main Fiat Liabilities Account',
        scope:          %i[member]
      },
      { code:           202,
        type:           :liabilities,
        kind:           :main,
        currency_type:  :coin,
        description:    'Main Crypto Liabilities Account',
        scope:          %i[member]
      },
      { code:           211,
        type:           :liabilities,
        kind:           :locked,
        currency_type:  :fiat,
        description:    'Locked Fiat Liabilities Account',
        scope:          %i[member]
      },
      { code:           212,
        type:           :liabilities,
        kind:           :locked,
        currency_type:  :coin,
        description:    'Locked Crypto Liabilities Account',
        scope:          %i[member]
      },
      { code:           410,
        type:           :revenue,
        kind:           :main,
        currency_type:  :coin,
        description:    'Revenue Account',
        scope:          %i[platform]
      },
      { code:           542,
        type:           :expense,
        kind:           :main,
        currency_type:  :coin,
        description:    'Expense Account',
        scope:          %i[platform]
      }
    ].freeze

    class << self
      # TODO: Passing scope to options doesn't work.
      def code_for(options)
        CHART.select { |entry| entry.merge(options) == entry }
      end
    end
  end
end
