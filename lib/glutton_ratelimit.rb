module GluttonRatelimit

  def rate_limit symbol, executions, time_period, rl_class = AveragedThrottle
    rl = rl_class.new executions, time_period
    old_symbol = "#{symbol}_old".to_sym
    alias_method old_symbol, symbol
    define_method symbol do |*args|
      use_glutton = !self.class.send(:can_use_throttle?)

      rl.wait if use_glutton
      self.send old_symbol, *args
    end
  end

  def rate_limit_for_class_method symbol, executions, time_period, rl_class = AveragedThrottle
    rl = rl_class.new executions, time_period
    old_symbol = "#{symbol}_old".to_sym
    singleton_class.send(:alias_method, old_symbol, symbol)
    define_singleton_method symbol do |*args|
      use_glutton = !send(:can_use_throttle?)

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

  def can_use_throttle?
    ENV['KEYPAY_THROTTLE_ALLOWED'] == 'true'
  end
end

dir = File.expand_path(File.dirname(__FILE__))
require File.join(dir, "glutton_ratelimit", "bursty_ring_buffer")
require File.join(dir, "glutton_ratelimit", "bursty_token_bucket")
require File.join(dir, "glutton_ratelimit", "averaged_throttle")
