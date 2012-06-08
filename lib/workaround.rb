require 'quality_extensions//enumerable/grep_plus_offset'
module Capybara
  module Node
    Base.class_eval do
      def synchronize(seconds=Capybara.default_wait_time)
        retries = (seconds.to_f / 0.05).round

        begin
          begin
            @synchronize_nesting ||= 0
            @synchronize_nesting += 1
            #puts %(@synchronize_nesting=#{(@synchronize_nesting).inspect}: )
            #pp caller(0).grep_plus_offset(/in `synchronize'/, 1)
            yield
          ensure
            @synchronize_nesting -= 1
          end
        rescue => e
          puts %(#{@synchronize_nesting} retries=#{(retries).inspect} e=#{(e).inspect})
          raise e unless driver.wait?
          raise e unless driver.invalid_element_errors.include?(e.class) or e.is_a?(Capybara::ElementNotFound)
          raise e if retries.zero? or @synchronize_nesting > 0
          sleep(0.05)
          reload if Capybara.automatic_reload
          retries -= 1
          retry
        end
      end
    end
  end
end

