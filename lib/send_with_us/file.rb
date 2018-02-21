module SendWithUs
  class File < SimpleDelegator
    def initialize(file_data, opts = {})
      attachment = if file_data.is_a?(String)
                     SendWithUs::Attachment.new(file_data)
                   else
                     if file_data[:data] and file_data[:id]
                       file_data
                     else
                       SendWithUs::Attachment.new(file_data[:attachment], file_data[:filename])
                     end
                   end
      super(attachment)
    end
  end
end
