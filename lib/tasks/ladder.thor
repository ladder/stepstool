# require defined gems
Bundler.require(:default)

class Ladder < Thor
  desc "ping URL", "Ping a Ladder instance"
  def ping(url)
    puts RestClient.get compose_url(url)
  rescue => err
    p err
  end

  desc "apikey URL", "Generate an API key"
  option :email, :required => true, :aliases => '-e', :banner => 'your_email', :desc => 'Email address'
  def apikey(url)
    puts RestClient.post compose_url(url, '/api_key'), nil
  rescue => err
    p err
  end

  desc "init URL", "(Re)initialize a Ladder instance"
  option :key, :required => true, :aliases => '-k', :banner => 'your_api_key', :desc => 'Ladder API key'
  def init(url)
    puts RestClient.delete compose_url(url)
  rescue => err
    p err
  end

  private

  # ensure that a string matches proper HTTP/HTTPS syntax
  def validate_url(string)
    schemes = ['http', 'https']
    match = string.match(URI.regexp(schemes))
    return (0 == match.begin(0) and string.size == match.end(0)) if match
    false
  end

  # format a URL for POSTing
  def compose_url(url, path = '/')
    abort "Invalid URL: #{url}" unless validate_url(url)

    query = {}
    query['email'] = options['email'] if options['email']
    query['api_key'] = options['key'] if options['key']

    uri = URI(url)
    uri.path = path
    uri.query = URI.encode_www_form(query) unless query.empty?
    uri.to_s
  end

end