module GluttonRatelimit
  
  class AveragedThrottle < ParentLimiter
    
    def reset_bucket
      @before_previous_execution = Time.now if @before_previous_execution.nil?
      @oldest_timestamp = Time.now
      @tokens = @executions
      @total_task_time = 0
    end
    
    def executed_this_period
      @executions - @tokens
    end
    
    def average_task_time
      @total_task_time.to_f / executed_this_period
    end
    
    def wait
      reset_bucket if @tokens.nil?
      
      now = Time.now
      delta_since_previous = now - @before_previous_execution
      @total_task_time += delta_since_previous
      remaining_time = @time_period - (now - @oldest_timestamp)
      
      if @tokens.zero?
        sleep(remaining_time) if remaining_time > 0
        reset_bucket
      elsif executed_this_period != 0
        begin
          throttle = (remaining_time.to_f + delta_since_previous) / (@tokens+1) - average_task_time
          sleep throttle if throttle > 0
        rescue RangeError
          params = {
            throttle: throttle,
            remaining_time: remaining_time,
            delta_since_previous: delta_since_previous,
            tokens: @tokens,
            average_task_time: average_task_time
          }
          raise GluttonRatelimit::GluttonSleepException.new('GluttonSleepException occured', params)
        end
      end
      
      @tokens -= 1
      @before_previous_execution = Time.now
    end
    
  end

end


