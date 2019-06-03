class Service
    attr_reader :name, :price, :duration

    def initialize(name, price, duration)
        @name = name
        @price = price
        @duration = duration
    end
end
