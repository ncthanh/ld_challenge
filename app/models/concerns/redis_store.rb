require "redis_connector"

module RedisStore
  extend ActiveSupport::Concern

  included do
    def self.identifier_attribute(id_attr)
      define_singleton_method(:find) do |id|
        RedisConnector.instance.redis.with do |conn|
          details = conn.hgetall("#{model_name.name}:#{id}")
          details.blank? ? nil : model_name.name.constantize.new(details)
        end
      end

      define_method(:save) do
        return false unless valid?
        attrs = instance_variables.reject { |v| %i[@password @password_confirmation].include?(v) || %w[NilClass ActiveModel::Errors].include?(instance_variable_get(v).class.name) }
        RedisConnector.instance.redis.with do |conn|
          conn.hset("#{self.class}:#{instance_variable_get("@#{id_attr}".to_sym)}", *attrs.map { |attribute| [attribute.to_s.sub(/^@/, ""), instance_variable_get(attribute).to_s] }.flatten)
        end
      end
    end
  end

  class UniqueValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      RedisConnector.instance.redis.with do |conn|
        record.errors.add attribute, "has already been taken" if conn.hgetall("#{record.class}:#{value}").present?
      end
    end
  end
end
