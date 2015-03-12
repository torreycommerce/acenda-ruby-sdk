load '../lib/acenda-client.rb'

describe 'Acenda::API.query' do
    before (:all) do
        @config = ""
        File.open("config.json", "r") do |f|
            f.each_line do |line|
                @config += line
            end
        end

        @config = JSON.parse(@config)
        @acenda = Acenda::API.new @config["client_id"], @config["client_secret"], @config["store_url"]

        @response = @acenda.query('GET', '/product')
    end

    context 'should not query' do
        it 'with wrong type of VERB' do
            expect{ @acenda.query('ERROR', '/product') }.to raise_error(Acenda::APIErrorClient)
        end
    end
end
