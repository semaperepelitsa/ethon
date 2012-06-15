module Ethon
  module Easies

    # This module contains the logic around adding headers to libcurl.
    module Header

      # Return headers, return empty hash if none.
      #
      # @example Return the headers.
      #   easy.headers
      #
      # @return [ Hash ] The headers.
      def headers
        @headers ||= {}
      end

      # Set the headers.
      #
      # @example Set the headers.
      #   easy.headers = {'User-Agent' => 'ethon'}
      #
      # @param [ Hash ] headers The headers.
      def headers=(headers)
        @headers = headers
      end

      # Return header_list.
      #
      # @example Return header_list.
      #   easy.header_list
      #
      # @return [ FFI::Pointer ] The header list.
      def header_list
        @header_list
      end

      # Set previously defined headers in libcurl.
      #
      # @example Set headers in libcurl.
      #   easy.set_headers
      #
      # @return [ Symbol ] The return value from Curl.set_option.
      def set_headers
        @header_list = nil
        headers.each {|k, v| @header_list = Curl.slist_append(@header_list, compose_header(k,v)) }
        Curl.set_option(:httpheader, @header_list, handle)
      end

      # Compose libcurl header string from key and value.
      # Also replaces null bytes, because libcurl will complain about
      # otherwise.
      #
      # @example Compose header.
      #   easy.compose_header('User-Agent', 'Ethon')
      #
      # @param [ String ] key The header name.
      # @param [ String ] value The header value.
      #
      # @return [ String ] The composed header.
      def compose_header(key, value)
        "#{key}:#{value.gsub(0.chr, '\\\0')}"
      end
    end
  end
end
