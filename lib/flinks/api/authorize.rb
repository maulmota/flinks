# frozen_string_literal: true

require 'dry-validation'

module Flinks
  module API
    module Authorize
      AuthorizeRequestSchema = Dry::Validation.Schema do
        required(:login_id).filled(:str?)

        optional(:language).filled(:str?)
        optional(:save).filled(:bool?)
        optional(:security_responses).filled(:hash?)
        optional(:schedule_refresh).filled(:bool?)
        optional(:direct_refresh).filled(:bool?)
        optional(:days_of_transactions).included_in?(['Days90', 'Days360'])
        optional(:most_recent_cached).filled(:bool?)
        optional(:with_transactions).filled(:bool?)
        optional(:with_balance).filled(:bool?)
      end

      AuthorizeWithCredentialsRequestSchema = Dry::Validation.Schema do
        required(:username).filled?(:str?)
        required(:password).filled?(:str?)
        required(:institution).filled?(:str?)

        optional(:language).filled(:str?)
        optional(:save).filled(:bool?)
        optional(:security_responses).filled(:hash?)
        optional(:schedule_refresh).filled(:bool?)
        optional(:direct_refresh).filled(:bool?)
        optional(:days_of_transactions).included_in?(['Days90', 'Days360'])
        optional(:most_recent_cached).filled(:bool?)
        optional(:with_transactions).filled(:bool?)
        optional(:with_balance).filled(:bool?)
      end

      AuthorizeMultipleRequestSchema = Dry::Validation.Schema do
        required(:login_ids).each(:str?)

        optional(:most_recent_cached).filled(:bool?)
      end

      # @see https://sandbox-api.flinks.io/Readme/#authorize
      # @param [String] login_id
      # @param [Hash] options
      # @return [Hash]
      def authorize(login_id:, options: {})
        payload = options.merge(login_id: login_id)
        validate_request!(AuthorizeRequestSchema, payload)

        post("#{customer_id}/BankingServices/Authorize", body: payload)
      end

      # @see https://sandbox-api.flinks.io/Readme/#authorize
      # @param [String] username
      # @param [String] password
      # @param [String] institution
      # @param [Hash] options
      def authorize_with_credentials(username:, password:, institution:, options: {})
        payload = options.merge(username: username, password: password, institution: institution)
        validate_request!(AuthorizeWithCredentialsRequestSchema, payload)

        post("#{customer_id}/BankingServices/Authorize", body: payload)
      end

      # @see https://sandbox-api.flinks.io/Readme/#authorize-multiple
      # @param [Array] login_ids
      # @param [Hash] options
      # @return [Hash]
      def authorize_multiple(login_ids:, options: {})
        payload = options.merge(login_ids: login_ids)
        validate_request!(AuthorizeMultipleRequestSchema, payload)

        post("#{customer_id}/BankingServices/AuthorizeMultiple", body: payload)
      end
    end
  end
end
