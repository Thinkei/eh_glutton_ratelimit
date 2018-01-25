module GluttonRatelimit

  def rate_limit symbol, executions, time_period, rl_class = AveragedThrottle
    rl = rl_class.new executions, time_period
    old_symbol = "#{symbol}_old".to_sym
    alias_method old_symbol, symbol
    define_method symbol do |*args|
      use_glutton = true
      business_id = nil

      begin
        if respond_to?(:organisation)
          business_id = organisation.try(:external_id)
        elsif instance_variable_defined?(:@organisation)
          business_id = @organisation.try(:external_id)
        elsif self.class.private_method_defined?(:organisation)
          business_id = send(:organisation).try(:external_id)
        end

        if business_id.present?
          use_glutton = !self.class.send(:can_use_throttle?, business_id)
        else
          puts "No business ID found from rate_limit for method: #{symbol.to_s}"
        end
      rescue StandardError => e
        puts "An error occured from rate_limit when getting external id for Glutton: #{e.message}"
      end

      rl.wait if use_glutton
      self.send old_symbol, *args
    end
  end

  def rate_limit_for_class_method symbol, executions, time_period, rl_class = AveragedThrottle
    rl = rl_class.new executions, time_period
    old_symbol = "#{symbol}_old".to_sym
    singleton_class.send(:alias_method, old_symbol, symbol)
    define_singleton_method symbol do |*args|
      use_glutton = true
      business_id = nil

      begin
        case symbol
        when :delete_from_keypay
          business_id = args[0].try(:organisation).try(:external_id)
        when :find_keypay_leave_request
          business_id = args[0]
        when :fetch_all_kp_payruns
          business_id = args[0][:payroll_organisation_id]
        when :pull_all
          business_id = args[1][:payroll_organisation_id]
        when :pull_by_id
          business_id = args[1][:payroll_organisation_id]
        end

        if business_id.present?
          use_glutton = !send(:can_use_throttle?, business_id)
        else
          puts "No business ID found from rate_limit_for_class_method for method: #{symbol.to_s}"
        end
      rescue StandardError => e
        puts "An error occured from rate_limit_for_class_method when getting external id for Glutton: #{e.message}"
      end

      rl.wait if use_glutton
      self.send old_symbol, *args
    end
  end
  
  private
  # All the other classes extend this parent and are therefore
  # constructed in the same manner.
  class ParentLimiter
    attr_reader :executions
    
    def initialize executions, time_period
      @executions = executions
      @time_period = time_period
    end
    
    def times(num, &block)
      raise ArgumentError, "Code block expected"  if not block
      raise ArgumentError, "Parameter expected to be Fixnum but found a #{num.class}."  unless num.class.equal?(Fixnum)
      num.times do
        wait
        yield
      end
    end
  end

  def can_use_throttle?(business_id)
    allowed_orgs_env = ENV['KEYPAY_THROTTLE_ALLOWED_ORGS']
    return false if allowed_orgs_env.blank?

    org_ids = allowed_orgs_env.gsub(/\s+/, '').split(',')
    org_ids.include?(business_id)
  end
end

dir = File.expand_path(File.dirname(__FILE__))
require File.join(dir, "glutton_ratelimit", "bursty_ring_buffer")
require File.join(dir, "glutton_ratelimit", "bursty_token_bucket")
require File.join(dir, "glutton_ratelimit", "averaged_throttle")
