require_relative '../../test_helper'

class TestAttachment < Minitest::Test
  describe "#filename" do
    describe "when a filename is explicitly declared" do
      before do
        @attachment = SendWithUs::Attachment.new(
          StringIO.new("some data"),
          "rawr.txt"
        )
      end

      it "returns the explicit filename" do
        assert_equal "rawr.txt", @attachment.filename
      end
    end

    describe "when a filename is implied from a path" do
      before do
        @attachment = SendWithUs::Attachment.new(
          "this/is/a/path.txt"
        )
      end

      it "returns the basename of the path" do
        assert_equal "path.txt", @attachment.filename
      end
    end

    describe "when a filename is absent" do
      before do
        @attachment = SendWithUs::Attachment.new(
          StringIO.new("")
        )
      end

      it "returns nil" do
        assert_nil @attachment.filename
      end
    end
  end

  describe "#encoded_data" do
    describe "when the attachment is an IO object" do
      before do
        @attachment = SendWithUs::Attachment.new(
          StringIO.new("test text")
        )
      end

      it "returns the base 64'd content of the object" do
        assert_equal Base64.encode64("test text"), @attachment.encoded_data
      end
    end

    describe "when the attachment is not an IO object" do
      before do
        @attachment = SendWithUs::Attachment.new(
          "path/to/file.txt"
        )
        @attachment.expects(:open).
          with("path/to/file.txt").
          returns(StringIO.new("test text"))
      end

      it "returns the base 64'd content of the file/url in question" do
        assert_equal Base64.encode64("test text"), @attachment.encoded_data
      end
    end
  end
end
