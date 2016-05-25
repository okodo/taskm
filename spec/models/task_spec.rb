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

  describe 'scopes' do
    let!(:tasks) { create_list(:task, 5) }

    it 'should find only one by query' do
      expect(Task.filter(query: Task.first.name).length).to be_eql(1)
    end

    it 'should find all by empty query' do
      expect(Task.filter(query: nil).length).to be_eql(tasks.length)
    end

    it 'should find all by given query' do
      expect(Task.filter(query: 'Task').length).to be_eql(tasks.length)
    end

    it 'should find all by empty assignee' do
      expect(Task.filter(assignee_id: nil).length).to be_eql(tasks.length)
    end

    it 'should find only one by assignee' do
      expect(Task.filter(assignee_id: User.first.id).length).to be_eql(1)
    end

    it 'started first' do
      tasks[2].start!
      expect(Task.filter({}).first).to be_eql(tasks[2])
    end

    it 'finished last' do
      tasks[2].start!
      tasks[2].finish!
      expect(Task.filter({}).last).to be_eql(tasks[2])
    end
  end
end
