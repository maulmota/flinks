# frozen_string_literal: true

module Flinks
  module API
    module Card

      # https://sandbox-api.flinks.io/Readme/#delete-card-information
      # @param [String] login_id
      # @return [Hash]
      def delete_card(card_id:)
        get("#{customer_id}/BankingServices/DeleteCard/#{card_id}")
      end
    end
  end
end
