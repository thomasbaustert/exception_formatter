# ExceptionFormatter

*I was sick of writing "#{exception.class.name}: #{exception.message}\\n#{exception.backtrace.join("\\n")}"*

Simple formatter for ruby exception messages.

Features:

* Custom format pattern
* Nested exception support
* ActiveRecord:::RecordInvalid exception support


## Installation

Add this line to your application's Gemfile:

    gem 'exception_formatter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_formatter

## Examples

### Using default pattern

If no pattern is given the default pattern is used (see ExceptionFormatter::DEFAULT_PATTERN):

    begin
      ... code ... code ... code
    rescue => ex
      logger.error ExceptionFormatter.format(ex)
    end

Will produce the string:

      StandardError: the exception message
      file:31
      file:76

### Using custom pattern

    begin
      ... code ... code ... code
    rescue => ex
      logger.error ExceptionFormatter.format(ex, pattern: "[%k] %m\nStacktrace:\n%b")
    end

Will produce the string:

      [StandardError] the exception message
      Stacktrace:
      file:31
      file:76

Alternatively use instance method:

    FORMATTER = ExceptionFormatter.new(pattern: "[%k] %m\n%b")

    begin
      ... code ... code ... code
    rescue => ex
      logger.error FORMATTER.format(ex)
    end

## Available pattern

    %b         = exception backtrace joined with "\n"
    %c         = cause, the nested exception message (by calling exception.cause.message)
    %c{method} = cause, the nested exception message (by calling exception.method.message)
                 (useful if nested exception does not respond to #cause but to #reason or what ever)
    %k         = exception class name
    %m         = exception message
    %r         = record errors, the record error messages in case of ActiveRecord:::RecordInvalid exception
                 (by calling exception.record.errors.full_messages)
    %x{method} = message return by calling exception.send(method)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
