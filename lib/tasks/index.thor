# require defined gems
Bundler.require(:default)

class Index < Thor
  desc "search URL", "Query a search index"
  option :key, :required => true, :aliases => '-k', :banner => 'your_api_key', :desc => 'Ladder API key'
  option :query, :required => true, :aliases => '-q', :banner => 'query_string', :desc => 'Search query string'
  def search(url)
    puts RestClient.get compose_url(url)
  rescue => err
    p err
  end

  desc "init URL", "(Re)initialize a search index"
  option :key, :required => true, :aliases => '-k', :banner => 'your_api_key', :desc => 'Ladder API key'
  def init(url)
    puts RestClient.delete compose_url(url)
  rescue => err
    p err
  end

  desc "reindex URL", "Rebuild a search index"
  option :key, :required => true, :aliases => '-k', :banner => 'your_api_key', :desc => 'Ladder API key'
  def reindex(url)
    puts RestClient.put compose_url(url, '/search/reindex/'), nil
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
  def compose_url(url, path = '/search')
    abort "Invalid URL: #{url}" unless validate_url(url)

    query = {}
    query['api_key'] = options['key'] if options['key']
    query['q'] = options['query'] if options['query']

    uri = URI(url)
    uri.path = path
    uri.query = URI.encode_www_form(query)
    uri.to_s
  end

end