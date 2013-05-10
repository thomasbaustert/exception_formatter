require 'spec_helper'
require 'exception_formatter'

describe ExceptionFormatter do

  describe "::format" do

    it "delegates to #format" do
      exception = double('exception', message: "error", backtrace: ["file:1", "file:2"])
      formatter = double('exception_formatter')

      ExceptionFormatter.should_receive(:new).with(pattern: "%m\n%b").and_return(formatter)
      formatter.should_receive(:format).with(exception)

      ExceptionFormatter.format(exception, pattern: "%m\n%b")
    end

    context "no pattern given" do
      it "returns default message with exception message and backtrace " do
        exception = new_exception(class: double("FooError", name: "FooError"))
        formatter = ExceptionFormatter.new
        formatter.format(exception).should == "FooError: A Error Message\nline1\nline2"
      end
    end

    context "pattern %m" do
      it "returns message with exception message" do
        exception = new_exception(message: "a freaking error")
        ExceptionFormatter.format(exception, pattern: "%m").should == "a freaking error"
      end
    end

    context "pattern %k" do
      it "returns message with exception class" do
        exception = new_exception(class: double("StandardError", name: "StandardError"))
        ExceptionFormatter.format(exception, pattern: "%k").should == "StandardError"
      end
    end

    context "pattern %b" do
      it "returns message with exception backtrace" do
        exception = new_exception(backtrace: ["file:42", "file:76"])
        ExceptionFormatter.format(exception, pattern: "%b").should == "file:42\nfile:76"
      end
    end

    context "pattern %c" do
      context "exception respond to cause" do
        it "returns message with exception cause" do
          exception = new_exception(cause: new_exception(message: "cause error"))
          ExceptionFormatter.format(exception, pattern: "%c").should == "cause error"
        end
      end

      context "exception does respond to cause but not to cause.message" do
        it "returns message without exception cause" do
          exception = new_exception(cause: double("object_without_message"))
          ExceptionFormatter.format(exception, pattern: "%c").should == ""
        end
      end

      context "exception does not respond to cause" do
        it "returns message without exception cause" do
          exception = new_exception
          ExceptionFormatter.format(exception, pattern: "%c").should == ""
        end
      end
    end

    context "pattern %c{method}" do
      it "returns message with exception message return by method" do
        exception = new_exception(reason: new_exception(message: "error reason"))
        ExceptionFormatter.format(exception, pattern: "%c{reason}").should == "error reason"
      end
    end

    context "%r" do
      context "ActiveRecord:::RecordInvalid exception" do
        it "returns message with record error messages" do
          record = double('record', errors: double("ActiveModel::Errors", full_messages: ["Name must be present", "Url is invalid"]))
          exception = double('exception', message: "ActiveRecord::RecordInvalid", backtrace: ["file:1", "file:2"], record: record)
          ExceptionFormatter.format(exception, pattern: "%r").should == '["Name must be present", "Url is invalid"]'
          ExceptionFormatter.format(exception, pattern: "%m: %r\n%b").
              should == %Q{ActiveRecord::RecordInvalid: ["Name must be present", "Url is invalid"]\nfile:1\nfile:2}
        end
      end
    end

    context "pattern %x{method}" do
      context "exception respond to method" do
        it "returns message with exception.send(mathod)" do
          exception = new_exception(awesome_message: "this is a awesome message")
          ExceptionFormatter.format(exception, pattern: "%x{awesome_message}").should == "this is a awesome message"
        end
      end

      context "exception does not respond to method" do
        it "returns blank string" do
          exception = new_exception
          ExceptionFormatter.format(exception, pattern: "%x{awesome_message}").should == ""
        end
      end
    end

  end

  def new_exception(options = {})
    double('exception', { message: "A Error Message", backtrace: ["line1", "line2"] }.merge(options))
  end

end
