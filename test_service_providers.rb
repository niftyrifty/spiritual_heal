require_relative 'ServiceProvider'
require_relative 'Organization'

RSpec.describe ServiceProvider do
  describe '#initialize' do
    it 'initializes each instance of ServiceProvider' do
      service_provider = ServiceProvider.new('Provider', 1231111111, ['Gaming', 'Swimming'], )
      expect(service_provider.name).to eq('Provider')
      expect(service_provider.number).to eq(1231111111)
      expect(service_provider.services[0]).to eq('Gaming')
      expect(service_provider.services[1]).to eq('Swimming')
    end
  end
  describe '#list_service_providers' do
    it 'returns all service providers' do
      expect{list_service_providers}.to output('The service providers are: Provider').to_stdout
    end
  end
end