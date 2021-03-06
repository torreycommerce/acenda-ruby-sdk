load 'lib/acenda-client.rb'

describe 'Acenda::Response' do
    before (:all) do
        @acenda = Acenda::API.new ENV["client_id"], ENV["client_secret"], ENV["store_url"]
        @response = @acenda.query('GET', '/product')
    end

    context 'Should' do
        it 'store params' do
            expect(@response.get_params().class).to eq(Hash)
        end

        it 'store url' do
            expect(@response.get_url().class).to eq(URI::HTTP)
        end

        it 'store results' do
            expect(@response.get_result().class).to eq(Array)
        end

        it 'store numbers of results' do
            expect(@response.get_number().class).to eq(Fixnum)
        end

        it 'store code' do
            expect(@response.get_code().class).to eq(Fixnum)
        end

        it 'store status' do
            expect(@response.get_status().class).to eq(String)
        end
    end

end
