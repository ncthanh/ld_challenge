require "redis_connector"

module RedisStore
  extend ActiveSupport::Concern

  included do
    define_singleton_method("find_by") do |**args|
      RedisConnector.instance.redis.with do |conn|
        attrs = conn.hgetall("#{model_name.human}:#{args.values.first}")
        attrs.blank? ? nil : User.new(attrs)
      end
    end
  end

  def save
    return false unless valid?
    attrs = instance_variables.reject { |v| %w[NilClass ActiveModel::Errors].include? instance_variable_get(v).class.name }
    RedisConnector.instance.redis.with do |conn|
      conn.hmset("#{self.class}:#{instance_variable_get(attrs.first)}", *attrs.map { |attribute| [attribute.to_s.sub(/^@/, ""), instance_variable_get(attribute).to_s] }.flatten)
    end
  end

  class UniqueValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      RedisConnector.instance.redis.with do |conn|
        record.errors.add attribute, (options[:message] || "has already been taken") if conn.hgetall("#{record.class}:#{value}").present?
      end
    end
  end
end
