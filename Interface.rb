require 'tty-prompt'
require_relative 'Separate'

class Interface

    def initialize(input_strategy)
        @input_strategy = input_strategy
        @services = Array.new
        @service_providers = Array.new
        @name = input_strategy.ask("Name of the organization: ")
        puts "\nThe #{@name} organization has been created!\n"
        line_break()
    end

    def run()
      commands = ["Add service", "Add service provider", "Remove service", "Remove service provider", 
                  "List services", "List service providers", "Schedule appointment", "List appointments", 
                  "Schedule time off", "View schedule"]

      # response = (prompt.select("Choose a command...", interface.list_commands())).to_s()
      response = (@input_strategy.select("Please choose a command... (press 'control-c' to quit)", commands, per_page: 10)).to_s()

      interface = self 

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

          response = (@input_strategy.select("Choose a command...", commands, per_page: 10)).to_s()
      end

    end

    










    def add_service()
        prompt = TTY::Prompt.new

        service_name = @input_strategy.ask("Name of the service: ")
        while true
          if service_name != nil
            break
          else
            puts "Error: Not a valid service name. Please enter a valid service below. "
            service_name = @input_strategy.ask("Name of the service: ")
          end
        end

        if (!service_name)
          puts "Error: Service Must Have Name"
          line_break()
          return
        end

        if(service_already_exists?(service_name))
          puts "Error: Service Already Exists"
          line_break()
          return
        end

        service_price = @input_strategy.ask("Price of the service (ex. '3.00'): ")
        while true
          if service_price != nil
            break
          else
            puts "Error: Not a valid service price. Please enter a valid service price below. "
            service_price = @input_strategy.ask("Price of the service (ex. '3.00'): ")
          end
        end

        service_duration = @input_strategy.ask("Duration of the service (in hours): ")
        while true
          if service_duration != nil
            break
          else
            puts "Error: Not a valid service duration. Please enter a valid service duration below. "
            service_duration = @input_strategy.ask("Duration of the service (in hours): ")
          end
        end

        @services.push(Service.new(service_name, service_price, service_duration))
        puts "The #{service_name} service has been created!"
        line_break()
    end

    def remove_service()
        prompt = TTY::Prompt.new

        service_names = []

        @services.each do |service|
          service_names.push(service.name)
        end

        service_to_delete = prompt.select("Choose the service to delete...", service_names)

        @services.each do |existing_service|
          if(existing_service.name == service_to_delete)
            @services.delete(existing_service)
            puts "The #{service_to_delete} service has been deleted"
            line_break()
            return
          end
        end

        puts "The #{@service_to_delete} service does not exist!"
        line_break()
    end

    def list_services()
        if @services.length < 1
            puts "\nCurrently no services are offered"
        else
            puts "\nThe offered services are:\n"
            i = 0
            while i < @services.length
                service_name = @services[i].name
                puts "\t#{service_name}"
                i += 1
            end
        end
    end

    def add_service_provider()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.ask("Name of the service provider: ")
      while true
        if service_provider_name != nil
          break
        else
          puts "Error: Not a valid service provider name. Please enter a valid service provider name below. "
          service_provider_name = prompt.ask("Name of the service provider: ")
        end
      end

      if (!service_provider_name)
        puts "Error: Service Provider Must Have Name"
        line_break()
        return
      end

      if(service_provider_already_exists?(service_provider_name))
        puts "Service Provider already exists"
        line_break()
        return
      end

      service_provider_number = prompt.ask("Service provider phone number: ")
      while true
        if service_provider_number != nil
          break
        else
          puts "Error: Not a valid service provider number. Please enter a valid service provider number below. "
          service_provider_number = prompt.ask("Service provider phone number: ")
        end
      end


      available_service_names = prompt.multi_select("Which services can #{service_provider_name} provide?:", get_service_choices())
      available_service_names_array = available_service_names
      available_services = Array.new

      available_service_names_array.each do |service_name|
        @services.each do |service|
          if(service.name == service_name)
            available_services.push(service)
            break
          end
        end
      end

      if (available_services.length > 0)
        @service_providers.push(ServiceProvider.new(service_provider_name, service_provider_number, available_services))
        puts "\nThe #{service_provider_name} service provider has been created!"
        line_break()
      else
        puts "\nError: A service provider must provide at least one service."
        line_break()
      end
    end

    def remove_service_provider()
      prompt = TTY::Prompt.new

      providers = []

      @service_providers.each do |provider|
        providers.push(provider.name)
      end
      
      provider_to_delete = prompt.select("Choose which service provider to delete:", providers)

      @service_providers.each do |provider|
        if(provider.name == provider_to_delete)
          @service_providers.delete(provider)
          puts "Service Provider #{provider_to_delete} has been deleted"
          line_break()
          return
        end
      end
      puts "Error: Service provider does not exist"
      line_break()
    end

    def list_service_providers()
      if @service_providers.length < 1
          puts "\nCurrently no service providers"
      else
          puts "\nThe service providers are:\n"
          i = 0
          while i < @service_providers.length
              service_provider_name = @service_providers[i].name
              puts "\t#{service_provider_name}"
              i += 1
          end
      end
    end

    def schedule_appointment()
      prompt = TTY::Prompt.new
      client = prompt.ask("Client name: ")
      service_provider_name = prompt.select("Choose a service provider:", get_service_providers_array())
      service_provider = get_service_provider_by_name(service_provider_name)

      service_name = prompt.select("Choose a service:", get_service_choices())
      service = get_service_by_name(service_name)

      if(!service_provider_provides_service?(service_provider_name, service_name))
        puts "Error: #{service_provider_name} does not provide #{service_name}"
        line_break()
        return
      end

      day, month, year = get_date_response(true)

      if (!day || !month || !year)
        return
      end

      start_hour, start_minute = get_time_response(true)

      if(start_hour == nil || start_minute == nil)
        puts "Error: Invalid Time"
        line_break()
        return
      end

      appointment_time = Time.new(year, month, day, start_hour, start_minute)
      is_recurring = get_recurring_response()

      # client = prompt.ask("Client name: ")
      # while true
      #   if client != nil
      #     break
      #   else
      #     puts "Error: Not a valid name. Please enter a valid name below. "
      #     client = prompt.ask("Client name: ")
      #   end
      # end


      if(service_provider.timeslot_is_available?(appointment_time, service.duration, is_recurring))
        appt = Appointment.new(appointment_time, service, client, is_recurring)
        service_provider.add_appt(appt)
        puts "\nAppointment added successfully"
        line_break()
      else
        puts "\nError: Can't add a new appointment to that time"
        line_break()
      end
    end

    def list_appointments()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.select("Choose a service provider:", get_service_providers_array())
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Error: Service provider does not exist"
        line_break()
        return
      end

      service_provider.appointments.each do |appointment|
        appointment.output_appointment
      end
    end

    def view_schedule()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.select("Choose a service provider:", get_service_providers_array)
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Service provider does not exist"
        line_break()
        return
      end

      day, month, year = get_date_response(false)

      if (!day || !month || !year)
        return
      end

      time = Time.new(year, month, day)

      if (service_provider.appointments.length == 0)
        puts "#{service_provider_name} doesn't have any appointments on that day."
      end

      service_provider.appointments.each do |appointment|
        if(appointment.is_recurring)
          if(time.wday == appointment.time.wday)
            appointment.output_appointment
          end
        else
          if(is_same_date?(time, appointment.time))
            appointment.output_appointment
          end
        end
      end
    end

    def schedule_availability_block()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.select("Choose a service provider:", get_service_providers_array)
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Error: Service provider does not exist"
        line_break()
        return
      end

      day, month, year = get_date_response(true)

      if (!day || !month || !year)
        return
      end

      start_hour, start_minute = get_time_response(false)

      if(start_hour == nil || start_minute == nil)
        puts "Error: Invalid Time"
        line_break()
        return
      end

      block_time = Time.new(year, month, day, start_hour, start_minute)
      block_duration = prompt.ask("Duration of the block (in hours): ")
      while true
        if block_duration != nil
          break
        else
          puts "Error: Not a valid duration. Please enter a valid duration below. "
          block_duration = prompt.ask("Duration of the block (in hours): ")
        end
      end


      is_recurring = get_recurring_response()

      new_block = AvailabilityBlock.new(block_time, block_duration, is_recurring)
      service_provider.add_availability_block(new_block)
    end

    def list_commands()

      return ((Interface.public_instance_methods - Object.public_instance_methods).sort)

    end

    private

    def get_service_choices()
      service_choices = Array.new

      i = 0
      while i < @services.length
        service_choices.push(@services[i].name)
        i += 1
      end

      return service_choices
    end

    def get_service_providers_array()
      available_service_providers = Array.new
      i = 0
      while i < @service_providers.length
        available_service_providers.push(@service_providers[i].name)
        i += 1
      end
      return available_service_providers
    end

    def service_already_exists?(new_service_name)
      @services.each do |existing_service|
        if(existing_service.name == new_service_name)
          return true
        end
      end
      false
    end

    def service_provider_already_exists?(new_service_provider_name)
      @service_providers.each do |existing_service_provider|
        if(existing_service_provider.name == new_service_provider_name)
          return true
        end
      end
      return false
    end

    def service_provider_provides_service?(service_provider_name, service_name)
      @service_providers.each do |service_provider|
        if(service_provider.name == service_provider_name)
          service_provider.services.each do |service|
            if(service.name == service_name)
              return true
            end
          end
          return false
        end
      end
      return false
    end

    def get_service_by_name(service_name)
      @services.each do |service|
        if(service.name == service_name)
          return service
        end
      end
      return nil
    end

    def get_service_provider_by_name(service_provider_name)
      @service_providers.each do |service_provider|
        if(service_provider.name == service_provider_name)
          return service_provider
        end
      end
      return nil
    end

    def get_recurring_response
      prompt = TTY::Prompt.new
      is_recurring_response = prompt.ask("Appointment recurs weekly? (y/n): ")

      while(is_recurring_response != 'y' && is_recurring_response != 'n')
        puts "Error: Invalid response (must enter 'y' or 'n')"
        is_recurring_response = prompt.ask("Appointment recurs weekly? (y/n): ")
      end

      return is_recurring_response == 'y'
    end

    def get_date_response(view_sched)
      prompt = TTY::Prompt.new
      
      month = prompt.ask("Month (ex. '4'): ")
      
      while (month.to_i < 1 || month.to_i > 12 || !month)
        puts "Error: Invalid Month"
        line_break()
        month = prompt.ask("Month of appointment (ex. '4'): ")
      end
      
      day = prompt.ask("Date of appointment: ")
      while (day.to_i < 1 || day.to_i > 31 || !day)
        puts "Error: Invalid Day"
        line_break()
        day = prompt.ask("Date of appointment: ")
      end
      
      year = prompt.ask("Year of appointment : ")
      while (year.to_i < 2019 || !year)
        puts "Error: Invalid Year"
        line_break()
        year = prompt.ask("Year of appointment : ")
      end
      return day, month, year
    end

    def get_time_response(if_appt)
      prompt = TTY::Prompt.new
      if (if_appt)
        time_string = prompt.ask("Time of appointment (ex. '14:45'): ")
        while true
          if time_string != nil
            break
          else
            puts "Error: Not a valid time. Please enter a valid time below. "
            time_string = prompt.ask("Time of appointment (ex. '14:45'): ")
          end
        end
      else
        # I don't understand why it is somewhat asked twice.
        time_string = prompt.ask("Time off start time (ex. '14:45'): ")
        while true
          if time_string != nil
            break
          else
            puts "Error: Not a valid time. Please enter a valid time below. "
            time_string = prompt.ask("Time off start time (ex. '14:45'): ")
          end
        end

      end

      time_string_array = time_string.split(':')

      if(time_string_array.length != 2)
        return nil, nil
      end

      hour = time_string_array[0].to_i
      minute = time_string_array[1].to_i

      if(hour < 0 || hour > 23)
        hour = nil
      end

      if(minute < 0 || minute > 59)
        minute = nil
      end

      return hour, minute
    end

    def is_same_date?(time_1, time_2)
      return (time_1.day == time_2.day && time_1.month == time_2.month && time_1.year == time_2.year)
    end
end
