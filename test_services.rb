require_relative 'Service'
require_relative 'Organization'

#Goal: Take one specific and write a test for an action 

RSpec.describe Service do
  describe '#initialize' do
    it 'initializes each instance of Service' do
      service = Service.new('Massages',111,120)
      expect(service.name).to eq('Massages')
      expect(service.price).to eq(111)
      expect(service.duration).to eq(120)
    end
  end
  describe '#all_services' do
    it 'returns all service names' do
      DshsData.instance.services.push(Service.new('Gaming',111,120))
      DshsData.instance.services.push(Service.new('Swimming',222,1))
      DshsData.instance.services.push(Service.new('Running',21,2))
      expect(DshsData.instance.get_all_service_names).to eq(["mind reading", "demonic exorcism", "potion therapy", "liver transplants", "Gaming", "Swimming", "Running"])
    end
  end
  describe '#add_services' do
    it 'adds services' do
      expect{DshsData.instance.add_service('Name',11,12)}.to output("Name has successfully been added to services!".colorize(:green ).colorize( :background => :black) + "\n").to_stdout
    end
  end
  describe '#remove_services' do
    it 'removes services' do
      expect{DshsData.instance.remove_service('Name')}.to output("Name has successfully been removed from services".colorize(:green ).colorize( :background => :black) + "\n").to_stdout
    end
  end
  describe '#get_service_by_name' do
    it 'returns service by giving it a name' do
      expect(DshsData.instance.get_service_by_name('Swimming')).to eq(DshsData.instance.services[5])
    end
  end
end
