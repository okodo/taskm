require 'rails_helper'

describe Task do
  subject { build(:task) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should have_many(:attachments).dependent(:destroy) }

  context '#states' do
    it 'initial' do
      expect(subject).to be_new
    end

    it 'start' do
      subject.start
      expect(subject).to be_started
    end

    it 'finish' do
      subject.start
      subject.finish
      expect(subject).to be_finished
    end

    it 'reopen from started' do
      subject.start
      subject.reopen
      expect(subject).to be_new
    end

    it 'reopen from finished' do
      subject.start
      subject.finish
      subject.reopen
      expect(subject).to be_new
    end

    it 'finish from new raises error' do
      expect { subject.finish }.to raise_error(AASM::InvalidTransition)
    end
  end
end
