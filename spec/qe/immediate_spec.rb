require "spec_helper"

describe Qe::Immediate do
  let(:job) { double("job").as_null_object }

  it "sets options" do
    HelloWorker
      .should_receive(:new)
      .with(:a => 1)
      .and_return(job)

    Qe::Immediate.enqueue(HelloWorker, :a => 1)
  end

  it "performs job" do
    HelloWorker.stub :new => job
    job.should_receive(:perform)

    Qe::Immediate.enqueue(HelloWorker)
  end

  it "schedules job" do
    date = Time.now

    Qe::Immediate
      .should_receive(:enqueue)
      .with(HelloWorker, :a => 1)

    Qe::Immediate.schedule(HelloWorker, date, :a => 1)
  end
end
