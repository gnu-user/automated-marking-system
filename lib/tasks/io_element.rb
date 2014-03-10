class IOElement
    attr_accessor :value, :input

    #Value is used for either the input or output and input identifies whether the value is
    #input or output, input == false means output, input == true means input
    def initialize(value, input)
        @value = value
        @input = input
    end
end