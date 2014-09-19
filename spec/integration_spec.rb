require 'spec_helper'
require 'execjs'

# add environment variable flag for long integration tests
unless ENV['INTEGRATION'] == 'false'

describe 'Integrations' do
  Dir.glob(Pathname.new(__FILE__).dirname.join('integration/**.js').to_s).each do |path|
    js = File.read(path)

    if js =~ /\/\/@wip/
      puts "Skipping @wip test #{File.basename path}\n"
      next
    end

    num = 10

    if js =~ /\/\/@times (\d+)/
      num = $1.to_i
    end

    # ensure there is a global object to reference.
    js = "window=this; #{js}"

    num.times do
      it "#{File.basename(path)} should evaluate to the same value before and after obfuscation" do
        ob_js = JSObfu.new(js, iterations: 2).obfuscate.to_s
        expect(ob_js).to evaluate_to js
      end
    end

  end
end

end
