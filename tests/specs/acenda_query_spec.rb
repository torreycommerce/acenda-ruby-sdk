load 'lib/acenda-client.rb'

describe 'Acenda::API.query' do
    before (:all) do
        @acenda = Acenda::API.new ENV["client_id"], ENV["client_secret"], ENV["store_url"]
        @response = @acenda.query('GET', '/product')
    end

    context 'should not query' do
        it 'with wrong type of VERB' do
            expect{ @acenda.query('ERROR', '/product') }.to raise_error(Acenda::APIErrorClient)
        end
    end
end
