class GluttonSleepException < StandardError
  attr_reader :params

  def initialize(msg, params = {})
    @params = params
    super(msg)
  end
end
