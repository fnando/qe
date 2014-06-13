require "spec_helper"

describe Qe::Immediate do
  let(:job) { double("job").as_null_object }

  it "sets options" do
    expect(HelloWorker)
      .to receive(:new)
      .with(:a => 1)
      .and_return(job)

    Qe::Immediate.enqueue(HelloWorker, :a => 1)
  end

  it "performs job" do
    allow(HelloWorker).to receive_messages :new => job
    expect(job).to receive(:perform)

    Qe::Immediate.enqueue(HelloWorker)
  end

  it "schedules job" do
    date = Time.now

    expect(Qe::Immediate)
      .to receive(:enqueue)
      .with(HelloWorker, :a => 1)

    Qe::Immediate.schedule(HelloWorker, date, :a => 1)
  end
end
