# require defined gems
Bundler.require(:default)

class Ladder < Thor
  class_option :key, :required => true, :aliases => '-k', :banner => true, :desc => 'Ladder API key'

  desc "ping URL", "Ping a Ladder instance"
  def ping(url)
    puts RestClient.get compose_url(url)
  rescue => err
    p err
  end

  desc "destroy URL", "Delete and (re)initialize a Ladder instance"
  def destroy(url)
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
  def compose_url(url)
    abort "Invalid URL: #{url}" unless validate_url(url)

    query = {}
    query['api_key'] = options['key'] if options['key']

    uri = URI(url)
    uri.path = '/'
    uri.query = URI.encode_www_form(query)
    uri.to_s
  end

end