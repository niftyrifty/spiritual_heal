class AvailabilityBlock
    attr_reader :time, :duration, :is_recurring

    def initialize(time, duration, is_recurring)
        @time = time
        @duration = duration
        @is_recurring = is_recurring
    end
end
