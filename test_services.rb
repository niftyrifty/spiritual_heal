require_relative 'Service'
require_relative 'Interface'
require 'pry'

#Goal: Take one specific and write a test for an action 
class CommandScriptInputStrategy
  def initialize(commands)
    @commands = commands
  end

  def ask(text)
    @commands[0][text]
  end
end


RSpec.describe Service do
  describe 'adding a service' do
    it 'adds the service' do
      commands = [
        {"Name of the organization: " => "TEST ORG"},
        {"Please choose a command... (press 'control-c' to quit)" => "Add service"},
        {"Name of the service: " => "Massage"},
        {"Price of the service (ex. '3.00'): " => "1.00"},
        {"Duration of the service (in hours): " => "3"}
      ]
  #Assert that the massage exists
  #expect(list_services()).to incl
      interface = Interface.new(CommandScriptInputStrategy.new(commands))
      interface.run(commands)
    end
  end
end
