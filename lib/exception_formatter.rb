require "exception_formatter/version"

class ExceptionFormatter

  DEFAULT_PATTERN = "%k: %m\n%b"

  def self.format(exception, options = {})
    self.new(options).format(exception)
  end

  def initialize(options = {})
    @pattern = options[:pattern] ? options[:pattern].to_s : DEFAULT_PATTERN
  end


  def format(exception)
    s = @pattern.dup
    s = s.gsub('%b', exception.backtrace.join("\n"))
    s = s.gsub(/%c{(\w+)}/) { |match| exception_cause(exception, $1) }
    s = s.gsub('%c', exception_cause(exception, :cause))
    s = s.gsub('%k', exception.class.name)
    s = s.gsub('%m', exception.message.to_s)
    s = s.gsub('%r', exception_record_errors(exception))
    s = s.gsub(/%x{(\w+)}/) { |match| exception_method(exception, $1) }
    s
  end

  private

  def exception_cause(exception, method)
    if exception.respond_to?(method) && exception.send(method).respond_to?(:message)
      exception.send(method).message
    else
      ""
    end
  end

  def exception_record_errors(exception)
    if exception.respond_to?(:record) &&
       exception.record.respond_to?(:errors)
       exception.record.errors.respond_to?(:full_messages)
      exception.record.errors.full_messages.to_s
    else
      ""
    end
  end

  def exception_method(exception, method)
    exception.respond_to?(method) ? exception.send(method) : ""
  end

end
