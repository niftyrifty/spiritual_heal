class Appointment
    attr_reader :time, :service, :client, :is_recurring

    def initialize(time, service, client, is_recurring)
        @time = time
        @service = service
        @client = client
        @is_recurring = is_recurring
    end

    def output_appointment
      puts "Date/Time/Timezone: #{@time.inspect}  | Service: #{@service.name} | Client: #{@client} | Weekly: #{@is_recurring}"
    end
end
