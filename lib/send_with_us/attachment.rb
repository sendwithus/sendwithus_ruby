module SendWithUs
  class Attachment
    def initialize attachment, filename = nil
      @attachment, @filename = attachment, filename
    end

    def filename
      @filename ||= @attachment.is_a?(String) ? ::File.basename(@attachment) : nil
    end

    def encoded_data
      file_data = @attachment.respond_to?(:read) ? @attachment : open(@attachment)
      Base64.encode64(file_data.read)
    end

    def to_h
      { id: filename,
        data: encoded_data }
    end
  end
end
