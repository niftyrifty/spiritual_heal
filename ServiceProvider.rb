require 'tty-prompt'

class ServiceProvider
    attr_reader :name, :number, :services, :appointments, :availability_blocks

    def initialize(name, number, services)
        @name = name
        @number = number
        @services = services
        @appointments = []
        @availability_blocks = []
    end

    def add_service(service)
        services.push(service)
    end

    def add_appt(appt)
        @appointments.push(appt)
    end

    def add_availability_block(new_block)
      appointments.each do |appointment|
        if(overlaps_with_appointment?(new_block.time, new_block.duration, new_block.is_recurring, appointment))
          puts "To add this availability block, the following appointment must be deleted:"
          appointment.output_appointment()
          if(get_delete_appointment_response())
            appointments.delete(appointment)
          else
            puts "Availability block could not be added"
            return
          end
        end
      end
      availability_blocks.push(new_block)
      puts "Availability block added successfully"
    end

    def timeslot_is_available?(new_time, new_duration, is_recurring)
      if(overlaps_with_any_existing_appointment?(new_time, new_duration, is_recurring))
        return false
      elsif(overlaps_with_any_availability_block?(new_time, new_duration, is_recurring))
        return false
      end
      return true
    end

    def name
      @name
    end

    private

    def overlaps_with_any_existing_appointment?(new_time, new_duration, is_recurring)
      @appointments.each do |appointment|
        if(overlaps_with_appointment?(new_time, new_duration, is_recurring, appointment))
          return true
        end
      end
      return false
    end

    def overlaps_with_appointment?(new_time, new_duration, is_recurring, existingAppointment)
      if(existingAppointment.time.wday == new_time.wday)
        if(hours_overlap?(existingAppointment.time, existingAppointment.service.duration, new_time, new_duration))
          if(is_same_date?(existingAppointment.time, new_time))
            return true
          else
            if(existingAppointment.is_recurring && is_recurring)
              return true
            elsif(new_time <= existingAppointment.time && is_recurring)
              return true
            elsif(existingAppointment.time <= new_time && existingAppointment.is_recurring)
              return true
            end
          end
        end
      end
    end

    def overlaps_with_any_availability_block?(new_time, new_duration, is_recurring)
      @availability_blocks.each do |availability_block|
        if(availability_block.time.wday == new_time.wday)
          if(hours_overlap?(availability_block.time, availability_block.duration, new_time, new_duration))
            if(is_same_date?(availability_block.time, new_time))
              return true
            else
              if(availability_block.is_recurring && is_recurring)
                return true
              elsif(new_time <= availability_block.time && is_recurring)
                return true
              elsif(availability_block.time <= new_time && availability_block.is_recurring)
                return true
              end
            end
          end
        end
      end
      return false
    end

    def hours_overlap?(time_1, time_1_duration, time_2, time_2_duration)
      #Check which time starts first. Then add the duration to the earlier start time
      #to see if it overlaps with the later start time.
      time_1_string = time_1.strftime('%R')
      time_2_string = time_2.strftime('%R')
      if(time_1_string < time_2_string)
        return (time_1 + (time_1_duration.to_i*60*60)).strftime('%R')  > time_2_string
      else
        return (time_2 + (time_2_duration.to_i*60*60)).strftime('%R')  > time_1_string
      end
    end

    def is_same_date?(time_1, time_2)
      return (time_1.day == time_2.day && time_1.month == time_2.month && time_1.year == time_2.year)
    end

    def get_delete_appointment_response()
      prompt = TTY::Prompt.new
      delete_appointment_reponse = prompt.ask("Delete appointment? (y/n): ")

      while(delete_appointment_reponse != 'y' && delete_appointment_reponse != 'n')
        puts "Invalid response (must enter 'y' or 'n')"
        delete_appointment_reponse = prompt.ask("Delete appointment? (y/n): ")
      end

      return delete_appointment_reponse == 'y'
    end
end
