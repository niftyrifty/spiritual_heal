require 'tty-prompt'
require_relative "files/Appointment"
require_relative "files/DateTime"
require_relative "files/Organization"
require_relative "files/Service"
require_relative "files/ServiceProvider"
require_relative "files/AvailabilityBlock"


prompt = TTY::Prompt.new(active_color: :cyan)
org = Organization.new(prompt)

commands = ["Add service", "Add service provider", "Remove service", "Remove service provider", 
"List services", "List service providers", "Schedule appointment", "List appointments", 
"Schedule time off", "View schedule"]

# response = (prompt.select("Choose a command...", org.list_commands())).to_s()
response = (prompt.select("Choose a command...", commands, per_page: 10)).to_s()

while (response != "close")
    case response
    when "Add service"
        org.add_service()
    when "Remove service"
        org.remove_service()
    when "List services"
        org.list_services()
    when "Add service provider"
        org.add_service_provider()
    when "Remove service provider"
        org.remove_service_provider()
    when "List service providers"
        org.list_service_providers()
    when "Schedule appointment"
        org.schedule_appointment()
    when "List appointments"
        org.list_appointments()
    when "Schedule time off"
        org.schedule_availability_block()
    when "View schedule"
        org.view_schedule()
    else
        puts "Error: \nInvalid command!\n"
        org.list_commands()
    end

    response = (prompt.select("Choose a command...", commands, per_page: 10)).to_s()
end