require './ssl_manager'
require 'minitest/autorun'
require 'rack/test'


class SSLManager < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def get_domain_from_csr(csr)
    subject = csr.subject.to_s
    /([^=]+)\z/.match(subject)[1]
  end

  def test_create_cert
    key, csr_text = [nil, nil]

    # The contents of the .zip file are text files for key and csr
    Zip::File.open('testzip.zip') do |zip_file|
      zip_file.each do |entry|
        key = entry.get_input_stream.read if /key$/.match(entry.name)
        csr_text = entry.get_input_stream.read if /csr$/.match(entry.name)
      end
    end
    assert key
    assert csr_text
    assert csr = OpenSSL::X509::Request.new(csr_text)
    assert csr.verify(csr.public_key)
    assert_equal 'test.com', get_domain_from_csr(csr)
  end
end
