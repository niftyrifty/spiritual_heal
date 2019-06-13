require 'tty-prompt'
require_relative "Appointment"
require_relative "DateTime"
require_relative "Interface"
require_relative "Service"
require_relative "ServiceProvider"
require_relative "AvailabilityBlock"


#prompt = TTY::Prompt.new(active_color: :cyan)
prompt = TTY::Prompt.new(interrupt: :exit)
interface = Interface.new(prompt)


commands = ["Add service", "Add service provider", "Remove service", "Remove service provider", 
"List services", "List service providers", "Schedule appointment", "List appointments", 
"Schedule time off", "View schedule"]

# response = (prompt.select("Choose a command...", interface.list_commands())).to_s()
response = (prompt.select("Please choose a command... (press 'control-c' to quit)", commands, per_page: 10)).to_s()

while (response != "close")
    case response
    when "Add service"
        interface.add_service()
    when "Remove service"
        interface.remove_service()
    when "List services"
        interface.list_services()
    when "Add service provider"
        interface.add_service_provider()
    when "Remove service provider"
        interface.remove_service_provider()
    when "List service providers"
        interface.list_service_providers()
    when "Schedule appointment"
        interface.schedule_appointment()
    when "List appointments"
        interface.list_appointments()
    when "Schedule time off"
        interface.schedule_availability_block()
    when "View schedule"
        interface.view_schedule()
    else
        puts "Error: \nInvalid command!\n"
        interface.list_commands()
    end

    response = (prompt.select("Choose a command...", commands, per_page: 10)).to_s()
end