require "addressable/uri"
require "cgi"
require "htmlentities"
require "httparty"
#require "net/http"
require "recursive_open_struct"
require "uri"

require "ls_linkdirect_api/api_resource"
require "ls_linkdirect_api/api_response"
require "ls_linkdirect_api/version"
require "ls_linkdirect_api/text_links"
require "ls_linkdirect_api/banner_links"
require "ls_linkdirect_api/drm_links"

require "ls_linkdirect_api/errors/error"
require "ls_linkdirect_api/errors/authentication_error"
require "ls_linkdirect_api/errors/argument_error"
require "ls_linkdirect_api/errors/not_implemented_error"
require "ls_linkdirect_api/errors/invalid_request_error"



module LsLinkdirectAPI
  @api_base_url = "http://lld2.linksynergy.com/services/restLinks"
  @api_timeout = 30

  class << self
    attr_accessor :token, :api_base_url
    attr_reader :api_timeout
  end

  def self.api_timeout=(timeout)
    raise ArgumentError, "Timeout must be a Fixnum; got #{timeout.class} instead" unless timeout.is_a? Fixnum
    raise ArgumentError, "Timeout must be > 0; got #{timeout} instead" unless timeout > 0
    @api_timeout = timeout
  end
end
