load '../lib/acenda-client.rb'

describe 'Acenda::API.new' do
    before (:all) do
        @config = ""
        File.open("config.json", "r") do |f|
            f.each_line do |line|
                @config += line
            end
        end

        @config = JSON.parse(@config)
    end

    context 'should not be instanciated' do
        it 'without parameters' do
            expect{ Acenda::API.new() }.to raise_error(ArgumentError)
        end

        it 'with wrong types of parameters' do
            expect{ Acenda::API.new(nil, nil, nil) }.to raise_error(Acenda::APIErrorClient)
        end

        it 'with wrong store_url format' do
            expect{ Acenda::API.new("test", "test", "test") }.to raise_error(Acenda::APIErrorClient)
        end
    end

    context 'should be instantiated ' do
        it 'with wrong credentials and good URL but should not generate token' do
            @acenda = Acenda::API.new("test", "test", @config["store_url"])
            expect{ @acenda.query('GET', '/product').get_code() }.to raise_error(Acenda::APIErrorHTTP)
        end

        it 'should be able to query with all good parameters' do
            expect(Acenda::API.new(@config["client_id"], @config["client_secret"], @config["store_url"]).query('GET', '/product').get_code()).to eq(200)
        end
    end
end
