require 'spoofer'

class SpooferRunner
  def evaluate(code_string)
    instance_eval(code_string)
  end
end
