require 'tty-prompt'
require_relative "Appointment"
require_relative "DateTime"
require_relative "Interface"
require_relative "Service"
require_relative "ServiceProvider"
require_relative "AvailabilityBlock"

class PromptInputStrategy 
    def initialize()
        @prompt = TTY::Prompt.new(interrupt: :exit)
    end

    def ask(text)
        @prompt.ask(text)
    end

    def select(text, commands, options)
        @prompt.select("Please choose a command... (press 'control-c' to quit)", commands, options)
    end
end

#prompt = TTY::Prompt.new(active_color: :cyan)
prompt = TTY::Prompt.new(interrupt: :exit)
interface = Interface.new(PromptInputStrategy.new())

interface.run()