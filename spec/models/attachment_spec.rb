require 'rails_helper'

describe Attachment do
  subject { build(:attachment) }

  it { should belong_to(:task) }

  context 'mimetype' do
    it 'should not be an image' do
      expect(subject.image?).to be_falsey
    end

    it 'should be an image' do
      attachment = create(:attachment, :image)
      expect(attachment.image?).to be_truthy
    end
  end

  context 'data file validations' do
    it 'should not be valid cause no file uploaded' do
      attachment = Attachment.new
      attachment.valid?
      expect(attachment.errors[:data_file]).to be_present
    end

    it 'should be valid' do
      attachment = Attachment.new(data_file: File.new(File.join(Rails.root, 'spec', 'test_files', 'test.pdf')))
      attachment.valid?
      expect(attachment.errors[:data_file]).to be_blank
    end
  end

  it '#url' do
    expect(subject.data_file.url).to be_eql("/attachments/#{subject.id}")
  end
end
