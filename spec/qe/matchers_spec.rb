require "spec_helper"

describe Qe::EnqueueMatcher do
  let(:date) { Time.now }

  before { Qe.jobs.clear }

  it "enqueues job" do
    expect {
      HelloWorker.enqueue(a: 1)
    }.to enqueue(HelloWorker).with(a: 1)
  end

  it "enqueues job with options as a block" do
    expect {
      HelloWorker.enqueue(a: 1)
    }.to enqueue(HelloWorker).with { {a: 1} }
  end

  it "enqueues job without mentioning options" do
    expect {
      HelloWorker.enqueue(a: 1)
    }.to enqueue(HelloWorker)
  end

  it "doesn't enqueue job" do
    expect {
      # noop
    }.not_to enqueue(HelloWorker)
  end

  it "doesn't enqueue job with options" do
    expect {
      HelloWorker.enqueue(b: 1)
    }.not_to enqueue(HelloWorker).with(a: 1)
  end

  it "schedules job" do
    expect {
      HelloWorker.enqueue(a: 1, run_at: date)
    }.to schedule(HelloWorker).on(date).with(a: 1)
  end

  it "schedules job without mentioning options" do
    expect {
      HelloWorker.enqueue(a: 1, run_at: date)
    }.to schedule(HelloWorker).on(date)
  end

  it "requires date on scheduled job" do
    expect {
      HelloWorker.enqueue(a: 1, run_at: date)
    }.not_to schedule(HelloWorker).on(nil)
  end
end
