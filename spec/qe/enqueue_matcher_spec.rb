require "spec_helper"

describe Qe::EnqueueMatcher do
  it "sets adapter" do
    expect(Qe.adapter).to eql(Qe::Testing)
  end

  it "enqueues job with options" do
    expect {
      HelloWorker.enqueue(:message => "hello")
    }.to enqueue(HelloWorker).with(:message => "hello")
  end

  it "enqueues job without options" do
    expect {
      HelloWorker.enqueue
    }.to enqueue(HelloWorker)
  end

  it "doesn't enqueue job with options" do
    expect {
      HelloWorker.enqueue
    }.not_to enqueue(HelloWorker).with(:a => 1)
  end

  it "enqueues job with options but matches it without options" do
    expect {
      HelloWorker.enqueue(:message => "hello")
    }.to enqueue(HelloWorker)
  end
end
